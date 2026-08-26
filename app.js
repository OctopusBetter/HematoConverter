/* ==========================================================================
   HEMATOLOGY ANALYZER REPORT CONVERTER - APP LOGIC (app.js)
   Parses CSV, pairs PNG graphs as Base64, evaluates medical norms, renders A4 reports
   100% Ukrainian Language, Capsule UI Design System, Universal Compatibility
   Supports Biochemistry Integration (Mindray BS-230: Glu, GGT) + Smart Fuzzy Match
   ========================================================================== */

(function () {
    'use strict';

    // App State
    let parsedPatients = [];
    let filteredPatients = [];
    let unmatchedBiochemList = [];
    let uploadedFilesMap = new Map(); // UPPERCASE_FILENAME -> File Object
    let currentPatientIndex = 0;
    let availableDatesMap = new Map(); // "05.08.2026" -> "2026-08-05"
    let activeDateFilter = 'ALL';
    let activeStatusFilter = 'ALL'; // 'ALL', 'ABNORMAL', 'NORMAL'
    let db = null; // Native IndexedDB instance
    let activeModalBiochemItem = null;

    // DOM Elements
    let mainFolderInput, mainFolderDropZone, mainFolderStatus, uploadSection;
    let compactFolderBar, compactFolderText, reselectFolderBtn;
    let printAllBtn, printCurrentBtn, unlinkBiochemBtn;
    let patientCountBadge, workspace, patientList, patientSearch;
    let totalPatients, currentPatientTitle, singleReportContainer, printContainer;
    let dateFilterSelect, datePickerInput, clearDateBtn, statusFilterSelect, clearDbBtn;
    let unmatchedBiochemSection, unmatchedBiochemListEl, unmatchedCount, unmatchedHeader;
    let linkModal, modalTitle, modalBiochemDetails, closeModalBtn, modalPatientSearch, modalPatientList;
    let customContextMenu;

    // Parameter Dictionary: Ukrainian Descriptive Names & Units
    const PARAMETER_INFO = {
        'WBC': { ukrName: 'Лейкоцити', code: 'WBC', unit: '10⁹/л', min: 4.0, max: 10.0 },
        'Neu%': { ukrName: 'Нейтрофіли (%)', code: 'Neu %', unit: '%', min: 40.0, max: 70.0 },
        'Lym%': { ukrName: 'Лімфоцити (%)', code: 'Lym %', unit: '%', min: 20.0, max: 45.0 },
        'Mon%': { ukrName: 'Моноцити (%)', code: 'Mon %', unit: '%', min: 3.0, max: 10.0 },
        'Eos%': { ukrName: 'Еозинофіли (%)', code: 'Eos %', unit: '%', min: 0.5, max: 5.0 },
        'Bas%': { ukrName: 'Базофіли (%)', code: 'Bas %', unit: '%', min: 0.0, max: 1.0 },
        'Neu#': { ukrName: 'Нейтрофіли (абс.)', code: 'Neu #', unit: '10⁹/л', min: 2.00, max: 7.00 },
        'Lym#': { ukrName: 'Лімфоцити (абс.)', code: 'Lym #', unit: '10⁹/л', min: 1.00, max: 4.00 },
        'Mon#': { ukrName: 'Моноцити (абс.)', code: 'Mon #', unit: '10⁹/л', min: 0.10, max: 0.80 },
        'Eos#': { ukrName: 'Еозинофіли (абс.)', code: 'Eos #', unit: '10⁹/л', min: 0.02, max: 0.50 },
        'Bas#': { ukrName: 'Базофіли (абс.)', code: 'Bas #', unit: '10⁹/л', min: 0.00, max: 0.10 },
        'RBC': { ukrName: 'Еритроцити', code: 'RBC', unit: '10¹²/л', min: 3.80, max: 5.30 },
        'HGB': { ukrName: 'Гемоглобін', code: 'HGB', unit: 'г/л', min: 120, max: 160 },
        'HCT': { ukrName: 'Гематокрит', code: 'HCT', unit: '%', min: 36.0, max: 50.0 },
        'MCV': { ukrName: 'Середній об\'єм еритроцита', code: 'MCV', unit: 'фл', min: 80.0, max: 100.0 },
        'MCH': { ukrName: 'Середній вміст гемоглобіну в еритроциті', code: 'MCH', unit: 'пг', min: 27.0, max: 34.0 },
        'MCHC': { ukrName: 'Середня концентрація гемоглобіну в еритроцитах', code: 'MCHC', unit: 'г/л', min: 315, max: 360 },
        'RDW-CV': { ukrName: 'Ширина розподілу еритроцитів (CV)', code: 'RDW-CV', unit: '%', min: 11.5, max: 14.5 },
        'RDW-SD': { ukrName: 'Ширина розподілу еритроцитів (SD)', code: 'RDW-SD', unit: 'фл', min: 35.0, max: 56.0 },
        'PLT': { ukrName: 'Тромбоцити', code: 'PLT', unit: '10⁹/л', min: 150, max: 400 },
        'MPV': { ukrName: 'Середній об\'єм тромбоцитів', code: 'MPV', unit: 'фл', min: 7.0, max: 11.0 },
        'PDW': { ukrName: 'Ширина розподілу тромбоцитів', code: 'PDW', unit: 'фл', min: 9.0, max: 17.0 },
        'PCT': { ukrName: 'Тромбокрит', code: 'PCT', unit: '%', min: 0.10, max: 0.40 },
        'P-LCR': { ukrName: 'Частка великих тромбоцитів', code: 'P-LCR', unit: '%', min: 15.0, max: 35.0 },
        'P-LCC': { ukrName: 'Кількість великих тромбоцитів', code: 'P-LCC', unit: '10⁹/л', min: 30, max: 90 },
        'CRP': { ukrName: 'С-реактивний білок', code: 'CRP', unit: 'мг/л', min: 0.0, max: 5.0 },
        'Glu': { ukrName: 'Глюкоза (сироватка)', code: 'Glu', unit: 'ммоль/л', min: 4.10, max: 5.90 },
        'GGT': { ukrName: 'Гамма-глутамілтрансфераза (ГГТ)', code: 'GGT', unit: 'Од/л', min: 10.0, max: 50.0 }
    };

    /* ==========================================================================
       NATIVE INDEXEDDB LOCAL STORAGE MANAGER (FULL DATA PERSISTENCE)
       ========================================================================== */
    function initDB(callback) {
        if (!window.indexedDB) { if (callback) callback(); return; }
        const request = indexedDB.open('HematologyConverterDB', 2);

        request.onupgradeneeded = function (e) {
            const database = e.target.result;
            if (!database.objectStoreNames.contains('patientsStore')) {
                database.createObjectStore('patientsStore', { keyPath: 'uniqueKey' });
            }
            if (!database.objectStoreNames.contains('unmatchedBiochemStore')) {
                database.createObjectStore('unmatchedBiochemStore', { keyPath: 'uniqueKey' });
            }
        };

        request.onsuccess = function (e) {
            db = e.target.result;
            loadPatientsFromDB(callback);
        };

        request.onerror = function (e) {
            console.error('IndexedDB Error:', e);
            if (callback) callback();
        };
    }

    function savePatientsToDB(patientsToSave) {
        if (!db) return;
        const transaction = db.transaction(['patientsStore'], 'readwrite');
        const store = transaction.objectStore('patientsStore');

        patientsToSave.forEach(patient => {
            const uniqueKey = patient.uniqueKey || `${patient['ID образца.']}_${patient['Вр.измер.'] || patient['Время взят.пр.']}`;
            patient.uniqueKey = uniqueKey;
            store.put(patient);
        });
    }

    function saveUnmatchedBiochemToDB(unmatchedItems) {
        if (!db) return;
        try {
            const transaction = db.transaction(['unmatchedBiochemStore'], 'readwrite');
            const store = transaction.objectStore('unmatchedBiochemStore');
            store.clear();
            unmatchedItems.forEach(item => {
                const uniqueKey = item.uniqueKey || `BIOCHEM_${item['ID образца.']}_${item['Дата'] || item['Вр.измер.']}_${item['Фамилия'] || ''}`;
                item.uniqueKey = uniqueKey;
                store.put(item);
            });
        } catch (e) {
            console.warn('Could not save unmatched biochem to DB:', e);
        }
    }

    function loadPatientsFromDB(callback) {
        if (!db) { if (callback) callback(); return; }
        const transaction = db.transaction(['patientsStore'], 'readonly');
        const store = transaction.objectStore('patientsStore');
        const request = store.getAll();

        request.onsuccess = function (e) {
            const saved = e.target.result || [];
            if (saved.length > 0) {
                parsedPatients = saved;
                parsedPatients.forEach(p => evaluatePatientHealthStatus(p));
                parsedPatients = sortPatientsByHealthStatus(parsedPatients);

                const statusText = `Збережено в історії: ${parsedPatients.length} пацієнтів з графіками`;
                if (mainFolderStatus) mainFolderStatus.textContent = statusText;
                if (compactFolderText) compactFolderText.textContent = statusText;

                if (uploadSection) uploadSection.classList.add('compact');
                if (mainFolderDropZone) mainFolderDropZone.style.display = 'none';
                if (compactFolderBar) compactFolderBar.style.display = 'flex';

                populateDateFilterOptions();
                updateUI();
            }

            // Load unmatched biochem
            try {
                const bTransaction = db.transaction(['unmatchedBiochemStore'], 'readonly');
                const bStore = bTransaction.objectStore('unmatchedBiochemStore');
                const bReq = bStore.getAll();
                bReq.onsuccess = function (evt) {
                    unmatchedBiochemList = evt.target.result || [];
                    renderUnmatchedBiochemSection();
                };
            } catch (err) {}

            if (callback) callback();
        };

        request.onerror = function () {
            if (callback) callback();
        };
    }

    function clearDatabase() {
        if (!confirm('Ви дійсно бажаєте повністю очистити збережену базу пацієнтів та історію?')) return;
        if (db) {
            try {
                const transaction = db.transaction(['patientsStore', 'unmatchedBiochemStore'], 'readwrite');
                transaction.objectStore('patientsStore').clear();
                transaction.objectStore('unmatchedBiochemStore').clear();
            } catch (e) {
                const transaction = db.transaction(['patientsStore'], 'readwrite');
                transaction.objectStore('patientsStore').clear();
            }
        }
        parsedPatients = [];
        filteredPatients = [];
        unmatchedBiochemList = [];
        uploadedFilesMap.clear();
        availableDatesMap.clear();

        if (mainFolderStatus) mainFolderStatus.textContent = 'Базу повністю очищено.';
        if (compactFolderText) compactFolderText.textContent = 'Базу очищено.';
        if (uploadSection) uploadSection.classList.remove('compact');
        if (mainFolderDropZone) mainFolderDropZone.style.display = 'block';
        if (compactFolderBar) compactFolderBar.style.display = 'none';
        if (workspace) workspace.style.display = 'none';
        if (printAllBtn) printAllBtn.disabled = true;

        renderUnmatchedBiochemSection();
    }

    // Helper: Convert File to Base64 Data URL
    function fileToBase64(fileObj) {
        return new Promise((resolve) => {
            if (!fileObj) { resolve(null); return; }
            const reader = new FileReader();
            reader.onload = function (e) { resolve(e.target.result); };
            reader.onerror = function () { resolve(null); };
            reader.readAsDataURL(fileObj);
        });
    }

    // Format Date & Time: 05-08-2026 18:12:57 or 20.08.2026 -> { dateStr: "05.08.2026", timeStr: "18:12:57" }
    function splitUkrainianDateTime(rawTimeStr) {
        if (!rawTimeStr) return { dateStr: '—', timeStr: '—' };
        const match = String(rawTimeStr).match(/(\d{2})[-.](\d{2})[-.](\d{4})\s+(\d{2}:\d{2}:\d{2})/);
        if (match) {
            return { dateStr: `${match[1]}.${match[2]}.${match[3]}`, timeStr: match[4] };
        }
        const dateOnlyMatch = String(rawTimeStr).match(/(\d{2})[-.](\d{2})[-.](\d{4})/);
        if (dateOnlyMatch) {
            return { dateStr: `${dateOnlyMatch[1]}.${dateOnlyMatch[2]}.${dateOnlyMatch[3]}`, timeStr: '—' };
        }
        const isoMatch = String(rawTimeStr).match(/(\d{4})-(\d{2})-(\d{2})/);
        if (isoMatch) {
            return { dateStr: `${isoMatch[3]}.${isoMatch[2]}.${isoMatch[1]}`, timeStr: '—' };
        }
        return { dateStr: String(rawTimeStr), timeStr: '—' };
    }

    // Evaluate patient health status & count abnormal parameters
    function evaluatePatientHealthStatus(patient) {
        let abnormalCount = 0;
        const paramKeys = Object.keys(PARAMETER_INFO);

        paramKeys.forEach(key => {
            const rawVal = patient[key];
            if (rawVal !== undefined && rawVal !== '' && rawVal !== '***.*' && rawVal !== '***') {
                const numVal = parseFloat(String(rawVal).replace(',', '.'));
                const info = PARAMETER_INFO[key];
                if (info && !isNaN(numVal)) {
                    if (numVal < info.min || numVal > info.max) {
                        abnormalCount++;
                    }
                }
            }
        });

        patient.hasAbnormalities = abnormalCount > 0;
        patient.abnormalCount = abnormalCount;
        return patient;
    }

    // Sort Patients: Abnormal Patients FIRST (sorted by count desc), then Normal
    function sortPatientsByHealthStatus(patientsList) {
        return patientsList.sort((a, b) => {
            if (a.hasAbnormalities && !b.hasAbnormalities) return -1;
            if (!a.hasAbnormalities && b.hasAbnormalities) return 1;
            return b.abnormalCount - a.abnormalCount;
        });
    }

    /* ==========================================================================
       SMART FUZZY MATCHING ENGINE FOR PATIENT SURNAME & DATE
       ========================================================================== */
    function normalizeNameForMatch(name) {
        if (!name) return '';
        let s = String(name).toLowerCase().trim();
        s = s.replace(/[.,\-_'"`/\\#$@!%^&*()+=~?]/g, ' ');
        s = s.replace(/і/g, 'и').replace(/ї/g, 'и').replace(/є/g, 'е').replace(/ё/g, 'е').replace(/ы/g, 'и');
        s = s.replace(/\s+/g, ' ').trim();
        const parts = s.split(' ');
        return parts[0] || '';
    }

    function levenshteinDistance(s1, s2) {
        if (!s1 || !s2) return Math.max(s1 ? s1.length : 0, s2 ? s2.length : 0);
        const m = s1.length, n = s2.length;
        const dp = Array.from({ length: m + 1 }, () => Array(n + 1).fill(0));
        for (let i = 0; i <= m; i++) dp[i][0] = i;
        for (let j = 0; j <= n; j++) dp[0][j] = j;
        for (let i = 1; i <= m; i++) {
            for (let j = 1; j <= n; j++) {
                const cost = s1[i - 1] === s2[j - 1] ? 0 : 1;
                dp[i][j] = Math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost);
            }
        }
        return dp[m][n];
    }

    function isSurnameMatch(name1, name2) {
        const norm1 = normalizeNameForMatch(name1);
        const norm2 = normalizeNameForMatch(name2);
        if (!norm1 || !norm2) return false;
        if (norm1 === norm2) return true;
        if (norm1.startsWith(norm2) || norm2.startsWith(norm1)) {
            if (Math.min(norm1.length, norm2.length) >= 4) return true;
        }
        const dist = levenshteinDistance(norm1, norm2);
        const maxLen = Math.max(norm1.length, norm2.length);
        if (maxLen >= 5 && dist <= 1) return true;
        if (maxLen >= 7 && dist <= 2) return true;
        return false;
    }

    function extractComparableDate(rawStr) {
        const { dateStr } = splitUkrainianDateTime(rawStr);
        return dateStr !== '—' ? dateStr : '';
    }

    /* ==========================================================================
       INITIALIZE EVENT LISTENERS & DOM ELEMENTS
       ========================================================================== */
    function init() {
        mainFolderInput = document.getElementById('mainFolderInput');
        mainFolderDropZone = document.getElementById('mainFolderDropZone');
        mainFolderStatus = document.getElementById('mainFolderStatus');
        uploadSection = document.getElementById('uploadSection');
        compactFolderBar = document.getElementById('compactFolderBar');
        compactFolderText = document.getElementById('compactFolderText');
        reselectFolderBtn = document.getElementById('reselectFolderBtn');

        printAllBtn = document.getElementById('printAllBtn');
        printCurrentBtn = document.getElementById('printCurrentBtn');
        unlinkBiochemBtn = document.getElementById('unlinkBiochemBtn');
        patientCountBadge = document.getElementById('patientCountBadge');
        workspace = document.getElementById('workspace');
        patientList = document.getElementById('patientList');
        patientSearch = document.getElementById('patientSearch');
        totalPatients = document.getElementById('totalPatients');
        currentPatientTitle = document.getElementById('currentPatientTitle');
        singleReportContainer = document.getElementById('singleReportContainer');
        printContainer = document.getElementById('printContainer');
        dateFilterSelect = document.getElementById('dateFilterSelect');
        datePickerInput = document.getElementById('datePickerInput');
        clearDateBtn = document.getElementById('clearDateBtn');
        statusFilterSelect = document.getElementById('statusFilterSelect');
        clearDbBtn = document.getElementById('clearDbBtn');

        unmatchedBiochemSection = document.getElementById('unmatchedBiochemSection');
        unmatchedBiochemListEl = document.getElementById('unmatchedBiochemList');
        unmatchedCount = document.getElementById('unmatchedCount');
        unmatchedHeader = document.getElementById('unmatchedHeader');

        linkModal = document.getElementById('linkModal');
        modalTitle = document.getElementById('modalTitle');
        modalBiochemDetails = document.getElementById('modalBiochemDetails');
        closeModalBtn = document.getElementById('closeModalBtn');
        modalPatientSearch = document.getElementById('modalPatientSearch');
        modalPatientList = document.getElementById('modalPatientList');
        customContextMenu = document.getElementById('customContextMenu');

        if (mainFolderInput) mainFolderInput.addEventListener('change', handleFolderSelect);
        if (mainFolderDropZone) setupSilentDragAndDrop(mainFolderDropZone);

        if (reselectFolderBtn) {
            reselectFolderBtn.addEventListener('click', () => {
                uploadSection.classList.remove('compact');
                mainFolderDropZone.style.display = 'block';
                compactFolderBar.style.display = 'none';
            });
        }

        if (patientSearch) patientSearch.addEventListener('input', applyFilters);
        if (dateFilterSelect) dateFilterSelect.addEventListener('change', handleDateSelectChange);
        if (datePickerInput) datePickerInput.addEventListener('change', handleDatePickerChange);
        if (clearDateBtn) clearDateBtn.addEventListener('click', resetDateFilter);
        if (statusFilterSelect) statusFilterSelect.addEventListener('change', handleStatusFilterChange);
        if (clearDbBtn) clearDbBtn.addEventListener('click', clearDatabase);

        if (printAllBtn) printAllBtn.addEventListener('click', printAllReports);
        if (printCurrentBtn) printCurrentBtn.addEventListener('click', printCurrentReport);
        if (unlinkBiochemBtn) unlinkBiochemBtn.addEventListener('click', unlinkCurrentPatientBiochem);

        if (unmatchedHeader) {
            unmatchedHeader.addEventListener('click', () => {
                unmatchedBiochemSection.classList.toggle('collapsed');
            });
        }

        if (closeModalBtn) {
            closeModalBtn.addEventListener('click', closeLinkModal);
        }
        if (linkModal) {
            linkModal.addEventListener('click', (e) => {
                if (e.target === linkModal) closeLinkModal();
            });
        }
        if (modalPatientSearch) {
            modalPatientSearch.addEventListener('input', filterModalPatientList);
        }

        // Hide context menu on outside click
        document.addEventListener('click', () => {
            if (customContextMenu) customContextMenu.style.display = 'none';
        });

        // Initialize Native IndexedDB Storage
        initDB();
    }

    // Silent Drag and Drop Helper
    function setupSilentDragAndDrop(zone) {
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            zone.addEventListener(eventName, preventDefaults, false);
            document.body.addEventListener(eventName, preventDefaults, false);
        });

        ['dragenter', 'dragover'].forEach(eventName => {
            zone.addEventListener(eventName, () => zone.classList.add('drag-over'), false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            zone.addEventListener(eventName, () => zone.classList.remove('drag-over'), false);
        });

        zone.addEventListener('drop', async (e) => {
            const dt = e.dataTransfer;
            const items = dt.items;
            const files = [];

            if (items && items.length > 0 && items[0].webkitGetAsEntry) {
                for (let i = 0; i < items.length; i++) {
                    const entry = items[i].webkitGetAsEntry();
                    if (entry) await traverseEntry(entry);
                }
            } else if (dt.files && dt.files.length > 0) {
                for (let i = 0; i < dt.files.length; i++) {
                    files.push(dt.files[i]);
                }
            }

            async function traverseEntry(entry) {
                if (entry.isFile) {
                    const file = await new Promise((resolve) => entry.file(resolve));
                    files.push(file);
                } else if (entry.isDirectory) {
                    const dirReader = entry.createReader();
                    const readEntries = async () => {
                        const entries = await new Promise((resolve) => dirReader.readEntries(resolve));
                        if (entries.length > 0) {
                            for (const child of entries) {
                                await traverseEntry(child);
                            }
                            await readEntries();
                        }
                    };
                    await readEntries();
                }
            }

            if (files.length > 0) {
                processFolderFiles(files);
            }
        });
    }

    function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
    }

    function handleFolderSelect(e) {
        const files = e.target.files;
        if (files && files.length > 0) processFolderFiles(files);
    }

    /* ==========================================================================
       PROCESS IMPORTED FILES (HEMATOLOGY + BIOCHEMISTRY)
       ========================================================================== */
    async function processFolderFiles(files) {
        const fileArray = Array.from(files);
        const csvFiles = fileArray.filter(f => f.name.toLowerCase().endsWith('.csv'));
        const pngFiles = fileArray.filter(f => f.name.toLowerCase().endsWith('.png'));

        pngFiles.forEach(file => {
            uploadedFilesMap.set(file.name.toUpperCase(), file);
        });

        if (csvFiles.length === 0 && pngFiles.length === 0) {
            mainFolderStatus.textContent = `У вибраній папці не знайдено файлів .csv або .png`;
            return;
        }

        mainFolderStatus.textContent = `Обробка та зчитування файлів...`;

        let newHematologyPatients = [];
        let newBiochemRecords = [];

        for (const csvFile of csvFiles) {
            const text = await new Promise((resolve) => {
                const reader = new FileReader();
                reader.onload = e => resolve(e.target.result);
                reader.readAsText(csvFile, 'UTF-8');
            });

            const parsedRows = parseCSVText(text);
            parsedRows.forEach(row => {
                if (row._isBiochem) {
                    newBiochemRecords.push(row);
                } else {
                    newHematologyPatients.push(row);
                }
            });
        }

        // Attach PNG Base64 Data URLs to each hematology patient
        for (const patient of newHematologyPatients) {
            await attachImagesToPatient(patient);
        }

        // Combine Hematology Patients with existing parsed patients, avoiding duplicates
        const existingKeys = new Set(parsedPatients.map(p => p.uniqueKey || `${p['ID образца.']}_${p['Вр.измер.'] || p['Время взят.пр.']}`));
        
        newHematologyPatients.forEach(p => {
            const key = `${p['ID образца.']}_${p['Вр.измер.'] || p['Время взят.пр.']}`;
            p.uniqueKey = key;
            if (!existingKeys.has(key)) {
                parsedPatients.push(p);
                existingKeys.add(key);
            } else {
                const existing = parsedPatients.find(x => x.uniqueKey === key);
                if (existing) {
                    if (p.wbcImgData) existing.wbcImgData = p.wbcImgData;
                    if (p.rbcImgData) existing.rbcImgData = p.rbcImgData;
                    if (p.pltImgData) existing.pltImgData = p.pltImgData;
                    if (p.diffImgData) existing.diffImgData = p.diffImgData;
                }
            }
        });

        // Also check if any existing patient needs updated PNG images
        for (const patient of parsedPatients) {
            if (!patient.wbcImgData || !patient.rbcImgData) {
                await attachImagesToPatient(patient);
            }
        }

        // Merge Biochemistry Records with Hematology Patients (Smart Auto-Match)
        if (newBiochemRecords.length > 0 || unmatchedBiochemList.length > 0) {
            const allBiochemToMatch = newBiochemRecords.concat(unmatchedBiochemList);
            unmatchedBiochemList = [];
            mergeBiochemistryRecords(allBiochemToMatch);
        }

        // Evaluate Health Status & Sort Abnormal Patients to TOP
        parsedPatients.forEach(p => evaluatePatientHealthStatus(p));
        parsedPatients = sortPatientsByHealthStatus(parsedPatients);

        // Persist to native IndexedDB
        savePatientsToDB(parsedPatients);
        saveUnmatchedBiochemToDB(unmatchedBiochemList);

        const statusText = `Завантажено пацієнтів: ${parsedPatients.length}` + 
                           (unmatchedBiochemList.length > 0 ? ` (неприв'язаної біохімії: ${unmatchedBiochemList.length})` : '');
        mainFolderStatus.textContent = statusText;
        compactFolderText.textContent = statusText;

        // Collapse Upload Section
        uploadSection.classList.add('compact');
        mainFolderDropZone.style.display = 'none';
        compactFolderBar.style.display = 'flex';

        populateDateFilterOptions();
        updateUI();
        renderUnmatchedBiochemSection();
    }

    // Attach Base64 PNG data directly to patient object
    async function attachImagesToPatient(patient) {
        const sampleID = patient['ID образца.'] || '';
        const rawTestTime = patient['Вр.измер.'] || patient['Время взят.пр.'] || '';

        let timeStampStr = '';
        if (rawTestTime) {
            const parts = String(rawTestTime).match(/(\d{2})[-.](\d{2})[-.](\d{4})\s+(\d{2}):(\d{2}):(\d{2})/);
            if (parts) {
                timeStampStr = `${parts[3]}${parts[2]}${parts[1]}${parts[4]}${parts[5]}${parts[6]}`;
            }
        }

        let wbcFile = null, rbcFile = null, pltFile = null, diffFile = null;

        for (const [filename, fileObj] of uploadedFilesMap.entries()) {
            const idPattern = sampleID ? `_${sampleID}_` : '';

            if ((idPattern && filename.includes(idPattern)) || (timeStampStr && filename.includes(timeStampStr))) {
                if (filename.startsWith('H_') && filename.endsWith('_WBC.PNG')) wbcFile = fileObj;
                else if (filename.startsWith('H_') && filename.endsWith('_RBC.PNG')) rbcFile = fileObj;
                else if (filename.startsWith('H_') && filename.endsWith('_PLT.PNG')) pltFile = fileObj;
                else if (filename.startsWith('D_') && (filename.includes('DIFF_LSMS') || filename.includes('DIFF'))) diffFile = fileObj;
            }
        }

        if (wbcFile) patient.wbcImgData = await fileToBase64(wbcFile);
        if (rbcFile) patient.rbcImgData = await fileToBase64(rbcFile);
        if (pltFile) patient.pltImgData = await fileToBase64(pltFile);
        if (diffFile) patient.diffImgData = await fileToBase64(diffFile);
    }

    /* ==========================================================================
       BIOCHEMISTRY MERGING & LINKING LOGIC
       ========================================================================== */
    function mergeBiochemistryRecords(biochemRecords) {
        const seenBiochem = new Set();

        biochemRecords.forEach(b => {
            const bKey = `${b['ID образца.']}_${b['Дата'] || b['Вр.измер.']}_${b['Фамилия'] || ''}_${b['Glu'] || ''}_${b['GGT'] || ''}`;
            if (seenBiochem.has(bKey)) return;
            seenBiochem.add(bKey);

            const bDate = extractComparableDate(b['Дата'] || b['Вр.измер.'] || b['Время взят.пр.']);
            const bSurname = b['Фамилия'] || b['ФИО'] || b['Имя'] || '';

            // Find matching candidate patients on the SAME date
            let candidateMatches = [];

            parsedPatients.forEach(p => {
                const pDate = extractComparableDate(p['Вр.измер.'] || p['Время взят.пр.'] || p['Дата']);
                const pSurname = p['Фамилия'] || p['Имя'] || '';

                // Date matching (or if either has no date, fall back to surname only)
                const dateMatches = (!bDate || !pDate || bDate === pDate);

                if (dateMatches && isSurnameMatch(pSurname, bSurname)) {
                    candidateMatches.push(p);
                }
            });

            // If exactly 1 candidate matches -> confident auto-link!
            if (candidateMatches.length === 1) {
                const target = candidateMatches[0];
                if (b['Glu']) target['Glu'] = b['Glu'];
                if (b['GGT']) target['GGT'] = b['GGT'];
                target._hasBiochem = true;
                target._biochemSource = b;
                evaluatePatientHealthStatus(target);
            } else {
                // If 0 matches or multiple ambiguous matches -> place in unmatched pool
                unmatchedBiochemList.push(b);
            }
        });
    }

    function renderUnmatchedBiochemSection() {
        if (!unmatchedBiochemSection || !unmatchedBiochemListEl || !unmatchedCount) return;

        if (unmatchedBiochemList.length === 0) {
            unmatchedBiochemSection.style.display = 'none';
            return;
        }

        unmatchedBiochemSection.style.display = 'block';
        unmatchedCount.textContent = unmatchedBiochemList.length;
        unmatchedBiochemListEl.innerHTML = '';

        unmatchedBiochemList.forEach((item, index) => {
            const li = document.createElement('li');
            li.className = 'unmatched-item';

            const nameStr = item['ФИО'] || `${item['Фамилия'] || ''} ${item['Имя'] || ''}`.trim() || `Зразок #${item['ID образца.'] || '?'}`;
            const dateStr = item['Дата'] || extractComparableDate(item['Вр.измер.'] || item['Время']) || '—';
            const gluStr = item['Glu'] ? `Glu: ${item['Glu']}` : '';
            const ggtStr = item['GGT'] ? `GGT: ${item['GGT']}` : '';
            const valuesStr = [gluStr, ggtStr].filter(Boolean).join(', ');

            li.innerHTML = `
                <div class="unmatched-item-info">
                    <div class="unmatched-item-name">${nameStr}</div>
                    <div class="unmatched-item-sub">📅 ${dateStr} | 🧪 ${valuesStr}</div>
                </div>
                <button class="btn-link-pill" title="Об'єднати з пацієнтом гематології">🔗 Прив'язати</button>
            `;

            const btn = li.querySelector('.btn-link-pill');
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                openLinkModal(index);
            });

            li.addEventListener('contextmenu', (e) => {
                e.preventDefault();
                showContextMenu(e.clientX, e.clientY, [
                    { label: `🔗 Прив'язати до пацієнта...`, action: () => openLinkModal(index) },
                    { label: `🗑️ Видалити цей запис біохімії`, action: () => removeUnmatchedBiochem(index) }
                ]);
            });

            unmatchedBiochemListEl.appendChild(li);
        });
    }

    function removeUnmatchedBiochem(index) {
        unmatchedBiochemList.splice(index, 1);
        saveUnmatchedBiochemToDB(unmatchedBiochemList);
        renderUnmatchedBiochemSection();
    }

    function openLinkModal(biochemIndex) {
        activeModalBiochemItem = unmatchedBiochemList[biochemIndex];
        if (!activeModalBiochemItem) return;

        const nameStr = activeModalBiochemItem['ФИО'] || `${activeModalBiochemItem['Фамилия'] || ''} ${activeModalBiochemItem['Имя'] || ''}`.trim() || `Зразок #${activeModalBiochemItem['ID образца.'] || '?'}`;
        const dateStr = activeModalBiochemItem['Дата'] || extractComparableDate(activeModalBiochemItem['Вр.измер.']) || '—';
        const gluStr = activeModalBiochemItem['Glu'] ? `Glu: ${activeModalBiochemItem['Glu']} ммоль/л` : '';
        const ggtStr = activeModalBiochemItem['GGT'] ? `GGT: ${activeModalBiochemItem['GGT']} Од/л` : '';
        const valuesStr = [gluStr, ggtStr].filter(Boolean).join(' | ');

        modalBiochemDetails.textContent = `Аналіз біохімії: ${nameStr} (${dateStr}) — ${valuesStr}`;
        if (modalPatientSearch) modalPatientSearch.value = '';

        populateModalPatientList();
        if (linkModal) linkModal.style.display = 'flex';
    }

    function closeLinkModal() {
        if (linkModal) linkModal.style.display = 'none';
        activeModalBiochemItem = null;
    }

    function populateModalPatientList(query = '') {
        if (!modalPatientList) return;
        modalPatientList.innerHTML = '';

        const q = query.toLowerCase().trim();
        const bDate = activeModalBiochemItem ? extractComparableDate(activeModalBiochemItem['Дата'] || activeModalBiochemItem['Вр.измер.']) : '';

        const matched = parsedPatients.filter(p => {
            const fullName = `${p['Фамилия'] || ''} ${p['Имя'] || ''}`.toLowerCase();
            const sid = (p['ID образца.'] || '').toLowerCase();

            if (q) {
                return fullName.includes(q) || sid.includes(q);
            }
            return true;
        });

        matched.forEach(p => {
            const li = document.createElement('li');
            li.className = 'modal-patient-item';

            const fullName = `${p['Фамилия'] || ''} ${p['Имя'] || ''}`.trim() || 'Пацієнт';
            const sid = p['ID образца.'] || '—';
            const pDate = extractComparableDate(p['Вр.измер.'] || p['Время взят.пр.']);
            const hasBio = p._hasBiochem ? ' <span class="badge-mini-bio">Вже має біохімію</span>' : '';
            const sameDateMark = (bDate && pDate === bDate) ? ' <span class="badge-same-date">📅 Співпадає дата</span>' : '';

            li.innerHTML = `
                <div class="modal-item-title">${fullName} ${hasBio} ${sameDateMark}</div>
                <div class="modal-item-meta">ID: ${sid} | Дата: ${pDate}</div>
            `;

            li.addEventListener('click', () => {
                executeManualLink(p);
            });

            modalPatientList.appendChild(li);
        });
    }

    function filterModalPatientList(e) {
        populateModalPatientList(e.target.value);
    }

    function executeManualLink(targetPatient) {
        if (!activeModalBiochemItem || !targetPatient) return;

        if (activeModalBiochemItem['Glu']) targetPatient['Glu'] = activeModalBiochemItem['Glu'];
        if (activeModalBiochemItem['GGT']) targetPatient['GGT'] = activeModalBiochemItem['GGT'];
        targetPatient._hasBiochem = true;
        targetPatient._biochemSource = activeModalBiochemItem;

        // Remove from unmatched list
        const idx = unmatchedBiochemList.indexOf(activeModalBiochemItem);
        if (idx !== -1) unmatchedBiochemList.splice(idx, 1);

        evaluatePatientHealthStatus(targetPatient);
        savePatientsToDB(parsedPatients);
        saveUnmatchedBiochemToDB(unmatchedBiochemList);

        closeLinkModal();
        renderPatientList();
        renderCurrentPatient();
        renderUnmatchedBiochemSection();
    }

    function unlinkCurrentPatientBiochem() {
        const patient = filteredPatients[currentPatientIndex];
        if (!patient || !patient._hasBiochem) return;

        if (!confirm(`Від'єднати біохімію (Glu / GGT) від пацієнта ${patient['Фамилия'] || ''} ${patient['Имя'] || ''}?`)) return;

        const bSource = patient._biochemSource || {
            'ID образца.': patient['ID образца.'],
            'Фамилия': patient['Фамилия'],
            'Имя': patient['Имя'],
            'Дата': extractComparableDate(patient['Вр.измер.'] || patient['Время взят.пр.']),
            'Glu': patient['Glu'],
            'GGT': patient['GGT']
        };

        unmatchedBiochemList.push(bSource);
        delete patient['Glu'];
        delete patient['GGT'];
        patient._hasBiochem = false;
        delete patient._biochemSource;

        evaluatePatientHealthStatus(patient);
        savePatientsToDB(parsedPatients);
        saveUnmatchedBiochemToDB(unmatchedBiochemList);

        renderPatientList();
        renderCurrentPatient();
        renderUnmatchedBiochemSection();
    }

    // Context Menu Handler
    function showContextMenu(x, y, items) {
        if (!customContextMenu) return;
        customContextMenu.innerHTML = '';
        items.forEach(item => {
            const btn = document.createElement('div');
            btn.className = 'context-menu-item';
            btn.textContent = item.label;
            btn.addEventListener('click', () => {
                customContextMenu.style.display = 'none';
                item.action();
            });
            customContextMenu.appendChild(btn);
        });
        customContextMenu.style.left = `${x}px`;
        customContextMenu.style.top = `${y}px`;
        customContextMenu.style.display = 'block';
    }

    /* ==========================================================================
       DATE FILTER LOGIC
       ========================================================================== */
    function extractPatientDate(testTimeStr) {
        if (!testTimeStr) return null;
        const match = String(testTimeStr).match(/(\d{2})[-.](\d{2})[-.](\d{4})/);
        if (match) {
            const day = match[1], month = match[2], year = match[3];
            return { displayDate: `${day}.${month}.${year}`, isoDate: `${year}-${month}-${day}` };
        }
        const isoMatch = String(testTimeStr).match(/(\d{4})-(\d{2})-(\d{2})/);
        if (isoMatch) {
            return { displayDate: `${isoMatch[3]}.${isoMatch[2]}.${isoMatch[1]}`, isoDate: isoMatch[0] };
        }
        return null;
    }

    function populateDateFilterOptions() {
        availableDatesMap.clear();
        parsedPatients.forEach(patient => {
            const rawTime = patient['Вр.измер.'] || patient['Время взят.пр.'] || patient['Дата'];
            const dateObj = extractPatientDate(rawTime);
            if (dateObj) availableDatesMap.set(dateObj.displayDate, dateObj.isoDate);
        });

        if (!dateFilterSelect) return;
        dateFilterSelect.innerHTML = '<option value="ALL">Всі наявні дати</option>';

        const sortedDates = Array.from(availableDatesMap.keys()).sort((a, b) => {
            const [d1, m1, y1] = a.split('.').map(Number);
            const [d2, m2, y2] = b.split('.').map(Number);
            return new Date(y2, m2 - 1, d2) - new Date(y1, m1 - 1, d1);
        });

        sortedDates.forEach(dateStr => {
            const option = document.createElement('option');
            option.value = dateStr;
            option.textContent = `📅 ${dateStr}`;
            dateFilterSelect.appendChild(option);
        });
    }

    function handleDateSelectChange(e) {
        activeDateFilter = e.target.value;
        if (activeDateFilter !== 'ALL' && availableDatesMap.has(activeDateFilter)) {
            datePickerInput.value = availableDatesMap.get(activeDateFilter);
        } else {
            datePickerInput.value = '';
        }
        applyFilters();
    }

    function handleDatePickerChange(e) {
        const pickedIso = e.target.value;
        if (!pickedIso) { resetDateFilter(); return; }
        const [year, month, day] = pickedIso.split('-');
        const targetDisplayDate = `${day}.${month}.${year}`;
        activeDateFilter = targetDisplayDate;
        dateFilterSelect.value = availableDatesMap.has(targetDisplayDate) ? targetDisplayDate : 'ALL';
        applyFilters();
    }

    function resetDateFilter() {
        activeDateFilter = 'ALL';
        if (dateFilterSelect) dateFilterSelect.value = 'ALL';
        if (datePickerInput) datePickerInput.value = '';
        applyFilters();
    }

    function handleStatusFilterChange(e) {
        activeStatusFilter = e.target.value;
        applyFilters();
    }

    /* ==========================================================================
       FILTERING & SEARCH
       ========================================================================== */
    function applyFilters() {
        const query = patientSearch ? patientSearch.value.toLowerCase().trim() : '';

        filteredPatients = parsedPatients.filter(patient => {
            // Health Status Filter
            if (activeStatusFilter === 'ABNORMAL' && !patient.hasAbnormalities) return false;
            if (activeStatusFilter === 'NORMAL' && patient.hasAbnormalities) return false;

            // Date Filter
            if (activeDateFilter !== 'ALL') {
                const rawTime = patient['Вр.измер.'] || patient['Время взят.пр.'] || patient['Дата'];
                const dateObj = extractPatientDate(rawTime);
                if (!dateObj || dateObj.displayDate !== activeDateFilter) return false;
            }

            // Search Query Filter
            if (query) {
                const fullName = `${patient['Фамилия'] || ''} ${patient['Имя'] || ''}`.toLowerCase();
                const sampleID = (patient['ID образца.'] || '').toLowerCase();
                return fullName.includes(query) || sampleID.includes(query);
            }

            return true;
        });

        currentPatientIndex = 0;
        patientCountBadge.textContent = filteredPatients.length;
        totalPatients.textContent = filteredPatients.length;
        renderPatientList();
        renderCurrentPatient();
    }

    /* ==========================================================================
       CSV PARSER (HANDLES BOTH HEMATOLOGY & MINDRAY BIOCHEMISTRY)
       ========================================================================== */
    function parseCSVText(csvText) {
        const lines = csvText.split(/\r?\n/).filter(line => line.trim() !== '');
        if (lines.length < 2) return [];

        const headers = parseCSVLine(lines[0]);
        const results = [];

        // Detect if this CSV is from Mindray Biochemistry
        const headerStr = headers.join(' ').toLowerCase();
        const isBiochemFile = (headerStr.includes('glu') && headerStr.includes('ggt')) || 
                              headerStr.includes('тип_анализа') || 
                              (!headerStr.includes('wbc') && !headerStr.includes('rbc'));

        for (let i = 1; i < lines.length; i++) {
            const values = parseCSVLine(lines[i]);
            if (values.length < 3) continue;

            const rowObj = {};
            headers.forEach((h, index) => {
                rowObj[h.trim()] = (values[index] || '').trim();
            });

            // STRICT BACKGROUND CHECK FILTERING
            const sampleID = (rowObj['ID образца.'] || rowObj['SampleID'] || '').toLowerCase();
            const probeType = (rowObj['Тип пробы'] || '').toLowerCase();
            const patientType = (rowObj['Тип пациента'] || '').toLowerCase();

            if (sampleID === 'background' || probeType === 'background' || patientType === 'background') {
                continue;
            }

            if (isBiochemFile) {
                rowObj._isBiochem = true;
                if (!rowObj['ID образца.'] && rowObj['SampleID']) rowObj['ID образца.'] = rowObj['SampleID'];
                if (!rowObj['Фамилия'] && rowObj['LastName']) rowObj['Фамилия'] = rowObj['LastName'];
                if (!rowObj['Имя'] && rowObj['FirstName']) rowObj['Имя'] = rowObj['FirstName'];
                if (!rowObj['Дата'] && rowObj['Date']) rowObj['Дата'] = rowObj['Date'];
                if (!rowObj['Время'] && rowObj['Time']) rowObj['Время'] = rowObj['Time'];
            } else {
                if (!rowObj['Имя'] && !rowObj['Фамилия'] && (!sampleID || sampleID === '' || sampleID === '0')) {
                    if (rowObj['WBC'] === '0,00' || rowObj['WBC'] === '0') continue;
                }
            }

            results.push(rowObj);
        }
        return results;
    }

    function parseCSVLine(text) {
        const result = [];
        let cur = '';
        let inQuotes = false;

        for (let i = 0; i < text.length; i++) {
            const char = text[i];
            if (char === '"') {
                inQuotes = !inQuotes;
            } else if (char === ',' && !inQuotes) {
                result.push(cur);
                cur = '';
            } else {
                cur += char;
            }
        }
        result.push(cur);
        return result;
    }

    /* ==========================================================================
       UI RENDERING (PATIENT LIST & PREVIEW)
       ========================================================================== */
    function updateUI() {
        workspace.style.display = 'flex';
        printAllBtn.disabled = parsedPatients.length === 0;
        applyFilters();
    }

    function renderPatientList() {
        patientList.innerHTML = '';

        if (filteredPatients.length === 0) {
            patientList.innerHTML = '<li class="no-patients-item">Пацієнтів не знайдено</li>';
            return;
        }

        filteredPatients.forEach((patient, index) => {
            const li = document.createElement('li');
            li.className = `patient-item ${index === currentPatientIndex ? 'active' : ''} ${patient.hasAbnormalities ? 'item-abnormal' : 'item-normal'}`;

            const fullName = `${patient['Фамилия'] || ''} ${patient['Имя'] || ''}`.trim() || 'Пацієнт';
            const sampleID = patient['ID образца.'] || '—';
            const rawTestTime = patient['Вр.измер.'] || patient['Время взят.пр.'] || patient['Дата'] || '';
            const { dateStr, timeStr } = splitUkrainianDateTime(rawTestTime);

            let statusBadgeHTML = patient.hasAbnormalities 
                ? `<span class="patient-pill-status pill-abnormal">⚠️ Не норма (${patient.abnormalCount})</span>`
                : `<span class="patient-pill-status pill-normal">✅ Норма</span>`;

            let biochemBadgeHTML = patient._hasBiochem
                ? `<span class="patient-pill-biochem" title="Підключено показники біохімії (Glu, GGT)">🩸+🧪 CBC+Біохімія</span>`
                : '';

            li.innerHTML = `
                <div class="patient-item-header">
                    <div class="patient-item-name">${fullName}</div>
                    ${statusBadgeHTML}
                </div>
                <div class="patient-item-meta">
                    <span class="meta-id">ID: <strong>${sampleID}</strong></span>
                    <span class="meta-time">${dateStr} ${timeStr !== '—' ? timeStr : ''}</span>
                </div>
                ${biochemBadgeHTML ? `<div class="patient-item-badges">${biochemBadgeHTML}</div>` : ''}
            `;

            li.addEventListener('click', () => {
                currentPatientIndex = index;
                renderPatientList();
                renderCurrentPatient();
            });

            li.addEventListener('contextmenu', (e) => {
                e.preventDefault();
                const menuItems = [];
                if (patient._hasBiochem) {
                    menuItems.push({
                        label: `✕ Від'єднати біохімію (розділити)`,
                        action: () => {
                            currentPatientIndex = index;
                            unlinkCurrentPatientBiochem();
                        }
                    });
                }
                menuItems.push({
                    label: `🖨️ Друк бланка пацієнта`,
                    action: () => {
                        currentPatientIndex = index;
                        renderCurrentPatient();
                        printCurrentReport();
                    }
                });
                showContextMenu(e.clientX, e.clientY, menuItems);
            });

            patientList.appendChild(li);
        });
    }

    // Fallback Mock SVGs
    function getDemoSVG(type) {
        if (type === 'WBC') {
            return `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 130" width="100%" height="100%"><rect width="240" height="130" fill="%23ffffff"/><path d="M 15 115 Q 40 115 55 90 Q 75 25 90 70 Q 110 110 140 45 Q 165 20 185 85 Q 205 115 230 115" fill="none" stroke="%230284c7" stroke-width="2.2"/><line x1="15" y1="115" x2="230" y2="115" stroke="%23475569" stroke-width="1.2"/><line x1="15" y1="15" x2="15" y2="115" stroke="%23475569" stroke-width="1.2"/><text x="110" y="127" font-size="8" font-family="Arial" fill="%23475569">WBC (fl)</text></svg>`;
        }
        if (type === 'RBC') {
            return `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 130" width="100%" height="100%"><rect width="240" height="130" fill="%23ffffff"/><path d="M 15 115 Q 60 115 80 80 Q 115 15 145 75 Q 170 115 230 115" fill="none" stroke="%23dc2626" stroke-width="2.2"/><line x1="15" y1="115" x2="230" y2="115" stroke="%23475569" stroke-width="1.2"/><line x1="15" y1="15" x2="15" y2="115" stroke="%23475569" stroke-width="1.2"/><text x="110" y="127" font-size="8" font-family="Arial" fill="%23475569">RBC (fl)</text></svg>`;
        }
        if (type === 'PLT') {
            return `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 130" width="100%" height="100%"><rect width="240" height="130" fill="%23ffffff"/><path d="M 15 115 Q 35 15 65 70 Q 95 110 230 115" fill="none" stroke="%2316a34a" stroke-width="2.2"/><line x1="15" y1="115" x2="230" y2="115" stroke="%23475569" stroke-width="1.2"/><line x1="15" y1="15" x2="15" y2="115" stroke="%23475569" stroke-width="1.2"/><text x="110" y="127" font-size="8" font-family="Arial" fill="%23475569">PLT (fl)</text></svg>`;
        }
        if (type === 'DIFF') {
            return `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 130" width="100%" height="100%"><rect width="240" height="130" fill="%23ffffff"/><ellipse cx="140" cy="55" rx="35" ry="22" fill="%230284c7" opacity="0.75"/><ellipse cx="75" cy="80" rx="22" ry="16" fill="%2316a34a" opacity="0.75"/><ellipse cx="90" cy="45" rx="16" ry="14" fill="%239333ea" opacity="0.75"/><ellipse cx="185" cy="85" rx="14" ry="10" fill="%23ea580c" opacity="0.75"/><line x1="15" y1="115" x2="230" y2="115" stroke="%23475569" stroke-width="1.2"/><line x1="15" y1="15" x2="15" y2="115" stroke="%23475569" stroke-width="1.2"/><text x="95" y="127" font-size="8" font-family="Arial" fill="%23475569">DIFF Scattergram</text></svg>`;
        }
        return '';
    }

    function getPatientImages(patient) {
        return {
            wbcImg: patient.wbcImgData || getDemoSVG('WBC'),
            rbcImg: patient.rbcImgData || getDemoSVG('RBC'),
            pltImg: patient.pltImgData || getDemoSVG('PLT'),
            diffImg: patient.diffImgData || getDemoSVG('DIFF')
        };
    }

    // Evaluate parameter against clinical norm boundaries
    function evaluateParameter(paramKey, rawVal) {
        const info = PARAMETER_INFO[paramKey];
        if (!info) {
            return { valStr: rawVal, normStr: '—', flag: 'NORMAL', ukrName: paramKey, code: paramKey, unit: '' };
        }

        const numVal = parseFloat(String(rawVal).replace(',', '.'));
        const valStr = isNaN(numVal) ? rawVal : numVal.toString();
        const normStr = `${info.min} - ${info.max}`;

        let flag = 'NORMAL';
        if (!isNaN(numVal)) {
            if (numVal < info.min) flag = 'LOW';
            else if (numVal > info.max) flag = 'HIGH';
        }

        return {
            valStr: valStr,
            normStr: normStr,
            flag: flag,
            ukrName: info.ukrName,
            code: info.code,
            unit: info.unit
        };
    }

    /* ==========================================================================
       A4 MEDICAL REPORT TEMPLATE GENERATOR
       ========================================================================== */
    function generateReportHTML(patient) {
        const fullName = `${patient['Фамилия'] || ''} ${patient['Имя'] || ''}`.trim() || 'Пацієнт';
        const sampleID = patient['ID образца.'] || '—';
        const rawTestTime = patient['Вр.измер.'] || patient['Время взят.пр.'] || patient['Дата'] || '—';
        const { dateStr, timeStr } = splitUkrainianDateTime(rawTestTime);

        // 100% Persistent Base64 Images
        const { wbcImg, rbcImg, pltImg, diffImg } = getPatientImages(patient);

        // Build Table Rows (Includes Glu and GGT cleanly!)
        const paramKeys = [
            'WBC', 'Neu%', 'Lym%', 'Mon%', 'Eos%', 'Bas%',
            'Neu#', 'Lym#', 'Mon#', 'Eos#', 'Bas#',
            'RBC', 'HGB', 'HCT', 'MCV', 'MCH', 'MCHC', 'RDW-CV', 'RDW-SD',
            'PLT', 'MPV', 'PDW', 'PCT', 'P-LCR', 'P-LCC', 'CRP',
            'Glu', 'GGT'
        ];

        let tableRowsHTML = '';
        paramKeys.forEach(key => {
            const rawVal = patient[key];
            if (rawVal !== undefined && rawVal !== '' && rawVal !== '***.*' && rawVal !== '***') {
                const evalRes = evaluateParameter(key, rawVal);
                let badgeHTML = '<span class="status-badge norm">В НОРМІ</span>';
                let resultClass = 'result-norm';

                if (evalRes.flag === 'HIGH') {
                    badgeHTML = '<span class="status-badge high">ВИЩЕ НОРМИ ▲</span>';
                    resultClass = 'result-high';
                } else if (evalRes.flag === 'LOW') {
                    badgeHTML = '<span class="status-badge low">НИЖЧЕ НОРМИ ▼</span>';
                    resultClass = 'result-low';
                }

                tableRowsHTML += `
                    <tr class="${evalRes.flag !== 'NORMAL' ? 'row-abnormal' : ''}">
                        <td class="param-ukr">${evalRes.ukrName || key}</td>
                        <td class="param-code">${evalRes.code || key}</td>
                        <td class="param-val-cell ${resultClass}">${evalRes.valStr} <span class="unit-text">${evalRes.unit || ''}</span></td>
                        <td class="param-norm-cell">${evalRes.normStr || '—'}</td>
                        <td class="param-status-cell">${badgeHTML}</td>
                    </tr>
                `;
            }
        });

        return `
            <div class="report-wrapper">
                <!-- Compact 2-Column Header (Title Left, Facility Right) -->
                <div class="report-header">
                    <div class="header-left-title">
                        <h2 class="report-main-title">ЗВІТ ЛАБОРАТОРНОГО ДОСЛІДЖЕННЯ</h2>
                    </div>
                    <div class="header-right-info">
                        <div class="test-type-sub">Загальний аналіз крові (CBC + 5-DIFF) ${patient._hasBiochem ? '+ Біохімія' : ''}</div>
                        <div class="facility-name">Заклад: МСЧ АРЗ СП ГУ ДСНС України у Харківській області</div>
                    </div>
                </div>

                <!-- Unified 3-Column Patient Box (ID Left, Name Center, Time/Date Right) -->
                <div class="patient-highlight-box-3col">
                    <div class="box-col-left">
                        <strong>ID зразка:</strong> ${sampleID}
                    </div>
                    <div class="box-col-center">
                        <div class="patient-full-name">${fullName}</div>
                    </div>
                    <div class="box-col-right">
                        <div><strong>Час:</strong> ${timeStr}</div>
                        <div><strong>Дата:</strong> ${dateStr}</div>
                    </div>
                </div>

                <!-- Results Table (Col Widths: 34%, 12%, 16%, 18%, 20%) -->
                <div class="results-section">
                    <table class="results-table">
                        <thead>
                            <tr>
                                <th style="width: 34%;">Показник (назва)</th>
                                <th style="width: 12%;">Абревіатура</th>
                                <th style="width: 16%;">Результат</th>
                                <th style="width: 18%;">Норма (референс)</th>
                                <th style="width: 20%;">Статус / Відхилення</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${tableRowsHTML}
                        </tbody>
                    </table>
                </div>

                <!-- Graphics (Scattergram + Histograms) -->
                <div class="graphics-section">
                    <div class="graphics-title">Графічний розподіл клітин (Скаттерграми та гістограми)</div>
                    <div class="graphics-grid">
                        <div class="chart-card">
                            <img src="${diffImg}" alt="DIFF Scattergram">
                            <div class="chart-label">WBC DIFF 2D</div>
                        </div>
                        <div class="chart-card">
                            <img src="${wbcImg}" alt="WBC Histogram">
                            <div class="chart-label">Гістограма WBC</div>
                        </div>
                        <div class="chart-card">
                            <img src="${rbcImg}" alt="RBC Histogram">
                            <div class="chart-label">Гістограма RBC</div>
                        </div>
                        <div class="chart-card">
                            <img src="${pltImg}" alt="PLT Histogram">
                            <div class="chart-label">Гістограма PLT</div>
                        </div>
                    </div>
                </div>

                <!-- Signatures -->
                <div class="report-footer">
                    <div class="signatures-grid">
                        <div class="signature-item">
                            <span class="sig-label">Дослідження виконав:</span>
                            <span class="sig-line">___________________</span>
                        </div>
                        <div class="signature-item">
                            <span class="sig-label">Лікар-лаборант:</span>
                            <span class="sig-line">___________________</span>
                        </div>
                        <div class="signature-item text-right">
                            <span class="sig-label">Дата видачі:</span>
                            <span class="sig-line">${dateStr}</span>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    function renderCurrentPatient() {
        if (filteredPatients.length === 0 || !filteredPatients[currentPatientIndex]) {
            currentPatientTitle.textContent = 'Оберіть пацієнта для перегляду';
            singleReportContainer.innerHTML = '<div class="empty-state-card"><p>Немає даних для відображення</p></div>';
            if (unlinkBiochemBtn) unlinkBiochemBtn.style.display = 'none';
            return;
        }

        const patient = filteredPatients[currentPatientIndex];
        const fullName = `${patient['Фамилия'] || ''} ${patient['Имя'] || ''}`.trim() || 'Пацієнт';
        currentPatientTitle.textContent = `${fullName} (ID: ${patient['ID образца.'] || '—'})`;

        // Show/hide unlink button
        if (unlinkBiochemBtn) {
            unlinkBiochemBtn.style.display = patient._hasBiochem ? 'inline-flex' : 'none';
        }

        singleReportContainer.innerHTML = generateReportHTML(patient);
    }

    /* ==========================================================================
       PRINTING & PDF EXPORT LOGIC
       ========================================================================== */
    async function triggerPrint() {
        return new Promise((resolve) => {
            const beforePrint = () => {};
            const afterPrint = () => {
                window.removeEventListener('afterprint', afterPrint);
                resolve();
            };
            window.addEventListener('afterprint', afterPrint);
            setTimeout(() => {
                window.print();
                setTimeout(resolve, 1500);
            }, 300);
        });
    }

    function printCurrentReport() {
        if (filteredPatients.length === 0 || !filteredPatients[currentPatientIndex]) return;
        const currentPatient = filteredPatients[currentPatientIndex];

        printContainer.innerHTML = `
            <div class="print-page-a4">
                ${generateReportHTML(currentPatient)}
            </div>
        `;
        triggerPrint();
    }

    function printAllReports() {
        if (filteredPatients.length === 0) return;

        let batchHTML = '';
        filteredPatients.forEach((patient) => {
            batchHTML += `
                <div class="print-page-a4">
                    ${generateReportHTML(patient)}
                </div>
            `;
        });

        printContainer.innerHTML = batchHTML;
        triggerPrint();
    }

    // Expose global methods for modal/UI callbacks if needed
    window.unlinkCurrentPatientBiochem = unlinkCurrentPatientBiochem;

    // Start App on DOM Ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
