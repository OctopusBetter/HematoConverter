/* ==========================================================================
   HEMATOLOGY ANALYZER REPORT CONVERTER - APP LOGIC (app.js)
   Parses CSV, pairs PNG graphs as Base64, evaluates medical norms, renders A4 reports
   100% Ukrainian Language, Capsule UI Design System, Universal Compatibility
   ========================================================================== */

(function () {
    'use strict';

    // App State
    let parsedPatients = [];
    let filteredPatients = [];
    let uploadedFilesMap = new Map(); // UPPERCASE_FILENAME -> File Object
    let currentPatientIndex = 0;
    let availableDatesMap = new Map(); // "05.08.2026" -> "2026-08-05"
    let activeDateFilter = 'ALL';
    let activeStatusFilter = 'ALL'; // 'ALL', 'ABNORMAL', 'NORMAL'
    let db = null; // Native IndexedDB instance
    let unmatchedBiochemList = [];
    let activeModalBiochemItem = null;
    let unmatchedBiochemSection, unmatchedBiochemListEl, unmatchedCount, unmatchedHeader;
    let linkModal, modalTitle, modalBiochemDetails, closeModalBtn, modalPatientSearch, modalPatientList;
    let customContextMenu, unlinkBiochemBtn;


    // DOM Elements
    let mainFolderInput, mainFolderDropZone, mainFolderStatus, uploadSection;
    let compactFolderBar, compactFolderText, reselectFolderBtn;
    let demoBtn, printAllBtn, printCurrentBtn;
    let patientCountBadge, workspace, patientList, patientSearch;
    let totalPatients, currentPatientTitle, singleReportContainer, printContainer;
    let dateFilterSelect, datePickerInput, clearDateBtn, statusFilterSelect, clearDbBtn;

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
       NATIVE INDEXEDDB LOCAL STORAGE MANAGER (FULL DATA BASE64 PERSISTENCE)
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
            const uniqueKey = `${patient['ID образца.']}_${patient['Вр.измер.'] || patient['Время взят.пр.']}`;
            patient.uniqueKey = uniqueKey;
            store.put(patient);
        });
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
    }

    function clearDatabase() {
        if (confirm('Ви впевнені, що хочете очистити збережену історію пацієнтів?')) {
            if (db) {
                const transaction = db.transaction(['patientsStore'], 'readwrite');
                const store = transaction.objectStore('patientsStore');
                store.clear();
            }
            parsedPatients = [];
            filteredPatients = [];
            uploadedFilesMap.clear();
            updateUI();
            location.reload();
        }
    }

    // Convert File to Base64 Data URL Promise
    function fileToBase64(fileObj) {
        return new Promise((resolve) => {
            if (!fileObj) { resolve(null); return; }
            const reader = new FileReader();
            reader.onload = function (e) { resolve(e.target.result); };
            reader.onerror = function () { resolve(null); };
            reader.readAsDataURL(fileObj);
        });
    }

    // Format Date & Time: 05-08-2026 18:12:57 -> { dateStr: "05.08.2026", timeStr: "18:12:57" }
    function splitUkrainianDateTime(rawTimeStr) {
        if (!rawTimeStr) return { dateStr: '—', timeStr: '—' };
        const match = rawTimeStr.match(/(\d{2})-(\d{2})-(\d{4})\s+(\d{2}:\d{2}:\d{2})/);
        if (match) {
            return { dateStr: `${match[1]}.${match[2]}.${match[3]}`, timeStr: match[4] };
        }
        const dateOnlyMatch = rawTimeStr.match(/(\d{2})-(\d{2})-(\d{4})/);
        if (dateOnlyMatch) {
            return { dateStr: `${dateOnlyMatch[1]}.${dateOnlyMatch[2]}.${dateOnlyMatch[3]}`, timeStr: '—' };
        }
        return { dateStr: rawTimeStr, timeStr: '—' };
    }

    // Evaluate patient health status & count abnormal parameters
    function evaluatePatientHealthStatus(patient) {
        let abnormalCount = 0;
        const paramKeys = Object.keys(PARAMETER_INFO);

        paramKeys.forEach(key => {
            const rawVal = patient[key];
            if (rawVal !== undefined && rawVal !== '' && rawVal !== '***.*' && rawVal !== '***') {
                const numVal = parseFloat(rawVal.replace(',', '.'));
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

    // Sort Patients: Abnormal Patients FIRST (sorted by count desc), then Normal
    function sortPatientsByHealthStatus(patientsList) {
        return patientsList.sort((a, b) => {
            if (a.hasAbnormalities && !b.hasAbnormalities) return -1;
            if (!a.hasAbnormalities && b.hasAbnormalities) return 1;
            return b.abnormalCount - a.abnormalCount;
        });
    }

    // Initialize Event Listeners
    function init() {
        mainFolderInput = document.getElementById('mainFolderInput');
        mainFolderDropZone = document.getElementById('mainFolderDropZone');
        mainFolderStatus = document.getElementById('mainFolderStatus');
        uploadSection = document.getElementById('uploadSection');
        compactFolderBar = document.getElementById('compactFolderBar');
        compactFolderText = document.getElementById('compactFolderText');
        reselectFolderBtn = document.getElementById('reselectFolderBtn');

        demoBtn = document.getElementById('demoBtn');
        printAllBtn = document.getElementById('printAllBtn');
        printCurrentBtn = document.getElementById('printCurrentBtn');
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

        if (mainFolderInput) mainFolderInput.addEventListener('change', handleFolderSelect);

        if (mainFolderDropZone) {
            setupSilentDragAndDrop(mainFolderDropZone);
        }

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
        unlinkBiochemBtn = document.getElementById('unlinkBiochemBtn');
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

        if (unlinkBiochemBtn) unlinkBiochemBtn.addEventListener('click', unlinkCurrentPatientBiochem);
        if (unmatchedHeader) unmatchedHeader.addEventListener('click', () => unmatchedBiochemSection.classList.toggle('collapsed'));
        if (closeModalBtn) closeModalBtn.addEventListener('click', closeLinkModal);
        if (linkModal) linkModal.addEventListener('click', (e) => { if (e.target === linkModal) closeLinkModal(); });
        if (modalPatientSearch) modalPatientSearch.addEventListener('input', (e) => populateModalPatientList(e.target.value));
        document.addEventListener('click', () => { if (customContextMenu) customContextMenu.style.display = 'none'; });


        if (printAllBtn) printAllBtn.addEventListener('click', printAllReports);
        if (printCurrentBtn) printCurrentBtn.addEventListener('click', printCurrentReport);

        // Initialize Native IndexedDB Storage
        initDB();
    }

    // Silent Drag and Drop Helper
    function setupSilentDragAndDrop(zone) {
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            zone.addEventListener(eventName, preventDefaults, false);
        });

        ['dragenter', 'dragover'].forEach(eventName => {
            zone.addEventListener(eventName, () => zone.classList.add('drag-over'), false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            zone.addEventListener(eventName, () => zone.classList.remove('drag-over'), false);
        });

        zone.addEventListener('drop', async (e) => {
            const items = e.dataTransfer.items;
            if (!items) return;

            const files = [];

            async function traverseEntry(entry) {
                if (entry.isFile) {
                    return new Promise((resolve) => {
                        entry.file(f => { files.push(f); resolve(); });
                    });
                } else if (entry.isDirectory) {
                    const dirReader = entry.createReader();
                    return new Promise((resolve) => {
                        const readEntries = () => {
                            dirReader.readEntries(async (entries) => {
                                if (entries.length === 0) {
                                    resolve();
                                } else {
                                    for (const subEntry of entries) {
                                        await traverseEntry(subEntry);
                                    }
                                    readEntries();
                                }
                            });
                        };
                        readEntries();
                    });
                }
            }

            const promises = [];
            for (let i = 0; i < items.length; i++) {
                const entry = items[i].webkitGetAsEntry ? items[i].webkitGetAsEntry() : null;
                if (entry) {
                    promises.push(traverseEntry(entry));
                } else if (items[i].getAsFile) {
                    const file = items[i].getAsFile();
                    if (file) files.push(file);
                }
            }

            await Promise.all(promises);
            if (files.length > 0) {
                processFolderFiles(files);
            }
        });
    }

    function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
    }

    // Folder Handler
    function handleFolderSelect(e) {
        const files = e.target.files;
        if (files && files.length > 0) processFolderFiles(files);
    }

    // Process all files in selected directory and convert PNGs to Base64 for 100% persistence
    async function processFolderFiles(files) {
        const fileArray = Array.from(files);
        const csvFiles = fileArray.filter(f => f.name.toLowerCase().endsWith('.csv'));
        const pngFiles = fileArray.filter(f => f.name.toLowerCase().endsWith('.png'));

        pngFiles.forEach(file => {
            uploadedFilesMap.set(file.name.toUpperCase(), file);
        });

        if (csvFiles.length === 0) {
            mainFolderStatus.textContent = `Папка містить ${pngFiles.length} графіків, але CSV-файли результатів не знайдено.`;
            return;
        }

        mainFolderStatus.textContent = `Обробка та збереження ${csvFiles.length} файлів результатів та графіків...`;

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

        // Combine with existing parsed patients, avoiding duplicates
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

        const statusText = `Успішно завантажено та збережено ${parsedPatients.length} пацієнтів з графіками` + 
                           (unmatchedBiochemList.length > 0 ? ` (неприв'язаної біохімії: ${unmatchedBiochemList.length})` : '');
        mainFolderStatus.textContent = statusText;
        compactFolderText.textContent = statusText;

        // Collapse Upload Section
        uploadSection.classList.add('compact');
        mainFolderDropZone.style.display = 'none';
        compactFolderBar.style.display = 'flex';

        populateDateFilterOptions();
        updateUI();
    }

    // Attach Base64 PNG data directly to patient object
    async function attachImagesToPatient(patient) {
        const sampleID = patient['ID образца.'] || '';
        const rawTestTime = patient['Вр.измер.'] || patient['Время взят.пр.'] || '';

        let timeStampStr = '';
        if (rawTestTime) {
            const parts = rawTestTime.match(/(\d{2})-(\d{2})-(\d{4})\s+(\d{2}):(\d{2}):(\d{2})/);
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

    // Extract Date from Patient Test Time String
    function extractPatientDate(testTimeStr) {
        if (!testTimeStr) return null;
        const fullMatch = testTimeStr.match(/(\d{2})-(\d{2})-(\d{4})/);
        if (fullMatch) {
            return {
                formatted: `${fullMatch[1]}.${fullMatch[2]}.${fullMatch[3]}`,
                iso: `${fullMatch[3]}-${fullMatch[2]}-${fullMatch[1]}`
            };
        }
        return null;
    }

    // Populate Date Selector with unique dates found in dataset
    function populateDateFilterOptions() {
        availableDatesMap.clear();
        dateFilterSelect.innerHTML = '<option value="ALL">Всі наявні дати</option>';

        parsedPatients.forEach(p => {
            const dateObj = extractPatientDate(p['Вр.измер.'] || p['Время взят.пр.']);
            if (dateObj) {
                availableDatesMap.set(dateObj.formatted, dateObj.iso);
            }
        });

        for (const [formatted, iso] of availableDatesMap.entries()) {
            const opt = document.createElement('option');
            opt.value = iso;
            opt.textContent = `Дата: ${formatted}`;
            dateFilterSelect.appendChild(opt);
        }
    }

    // Filter Change Handlers
    function handleDateSelectChange(e) {
        activeDateFilter = e.target.value;
        datePickerInput.value = activeDateFilter !== 'ALL' ? activeDateFilter : '';
        applyFilters();
    }

    function handleDatePickerChange(e) {
        const val = e.target.value;
        activeDateFilter = val || 'ALL';
        dateFilterSelect.value = val || 'ALL';
        applyFilters();
    }

    function resetDateFilter() {
        activeDateFilter = 'ALL';
        dateFilterSelect.value = 'ALL';
        datePickerInput.value = '';
        applyFilters();
    }

    function handleStatusFilterChange(e) {
        activeStatusFilter = e.target.value;
        applyFilters();
    }

    // Apply Filters (Search, Date, Status Norm)
    function applyFilters() {
        const search = patientSearch.value.toLowerCase().trim();

        filteredPatients = parsedPatients.filter(patient => {
            const fullName = `${patient['Фамилия'] || ''} ${patient['Имя'] || ''}`.trim().toLowerCase();
            const sampleID = (patient['ID образца.'] || '').toLowerCase();
            const matchesSearch = !search || fullName.includes(search) || sampleID.includes(search);

            // Date Filter
            let matchesDate = true;
            if (activeDateFilter !== 'ALL') {
                const dateObj = extractPatientDate(patient['Вр.измер.'] || patient['Время взят.пр.']);
                if (!dateObj || dateObj.iso !== activeDateFilter) {
                    matchesDate = false;
                }
            }

            // Status Filter (Abnormal vs Normal)
            let matchesStatus = true;
            if (activeStatusFilter === 'ABNORMAL') {
                matchesStatus = patient.hasAbnormalities === true;
            } else if (activeStatusFilter === 'NORMAL') {
                matchesStatus = patient.hasAbnormalities === false;
            }

            return matchesSearch && matchesDate && matchesStatus;
        });

        // Always keep abnormal patients grouped at top of filtered results
        filteredPatients = sortPatientsByHealthStatus(filteredPatients);

        currentPatientIndex = 0;
        patientCountBadge.textContent = filteredPatients.length;
        totalPatients.textContent = filteredPatients.length;
        renderPatientList();
        renderCurrentPatient();
    }

    // CSV Parser Supporting Quoted CSV strings (HANDLES BOTH HEMATOLOGY & BIOCHEMISTRY)
    function parseCSVText(csvText) {
        const lines = csvText.split(/\r?\n/).filter(line => line.trim() !== '');
        if (lines.length < 2) return [];

        const headers = parseCSVLine(lines[0]);
        const results = [];

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

    // Parse single CSV line handling quotes and commas
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

    // Update Main UI State
    function updateUI() {
        if (parsedPatients.length > 0) {
            workspace.style.display = 'flex';
            printAllBtn.disabled = false;
            applyFilters();
        }
    }

    // Render Left Patient List with Abnormal Warning Badges
    function renderPatientList() {
        patientList.innerHTML = '';

        if (filteredPatients.length === 0) {
            patientList.innerHTML = '<li class="patient-item" style="color:#94a3b8;text-align:center;padding:1.5rem 1rem;">Пацієнтів за обраними критеріями не знайдено</li>';
            return;
        }

        filteredPatients.forEach((patient, idx) => {
            const fullName = `${patient['Фамилия'] || ''} ${patient['Имя'] || ''}`.trim() || 'Без імені';
            const sampleID = patient['ID образца.'] || `№${idx + 1}`;
            const { dateStr, timeStr } = splitUkrainianDateTime(patient['Вр.измер.'] || patient['Время взят.пр.'] || patient['Дата'] || '');

            let badgeHTML = '<span class="status-indicator-badge normal">✅ В нормі</span>';
            let abnormalClass = '';

            if (patient.hasAbnormalities) {
                badgeHTML = `<span class="status-indicator-badge abnormal">▲ ${patient.abnormalCount} відхилен.</span>`;
                abnormalClass = 'item-abnormal';
            }

            let biochemBadgeHTML = patient._hasBiochem 
                ? `<span class="status-indicator-badge" style="background:rgba(168,85,247,0.2);color:#d8b4fe;border:1px solid rgba(168,85,247,0.4);margin-left:4px;" title="Підключено показники біохімії (Glu, GGT)">🧪 +Біохімія</span>`
                : '';

            const li = document.createElement('li');
            li.className = `patient-item ${abnormalClass} ${idx === currentPatientIndex ? 'active' : ''}`;
            li.innerHTML = `
                <div class="patient-item-header">
                    <span class="patient-name">${fullName}</span>
                    <div style="display:flex;align-items:center;">
                        ${badgeHTML}
                        ${biochemBadgeHTML}
                    </div>
                </div>
                <div class="patient-meta">
                    <span>ID: ${sampleID}</span>
                    <span>${dateStr} ${timeStr !== '—' ? timeStr : ''}</span>
                </div>
            `;
            li.addEventListener('click', () => {
                currentPatientIndex = idx;
                document.querySelectorAll('.patient-item').forEach(el => el.classList.remove('active'));
                li.classList.add('active');
                renderCurrentPatient();
            });

            li.addEventListener('contextmenu', (e) => {
                e.preventDefault();
                const menuItems = [];
                if (patient._hasBiochem) {
                    menuItems.push({
                        label: "✕ Від'єднати біохімію (розділити)",
                        action: () => {
                            currentPatientIndex = idx;
                            unlinkCurrentPatientBiochem();
                        }
                    });
                }
                menuItems.push({
                    label: "🖨️ Друк бланка пацієнта",
                    action: () => {
                        currentPatientIndex = idx;
                        renderCurrentPatient();
                        printCurrentReport();
                    }
                });
                showContextMenu(e.clientX, e.clientY, menuItems);
            });

            patientList.appendChild(li);
        });
    }

    // Generate Demo SVG Charts if PNGs are missing
    function getDemoSVG(type) {
        if (type === 'DIFF') {
            return `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 100" style="background:%23f8fafc">
                <rect width="160" height="100" fill="%23f1f5f9" stroke="%23cbd5e1"/>
                <line x1="20" y1="90" x2="150" y2="90" stroke="%2364748b" stroke-width="1"/>
                <line x1="20" y1="10" x2="20" y2="90" stroke="%2364748b" stroke-width="1"/>
                <circle cx="45" cy="65" r="8" fill="%233b82f6" opacity="0.6"/>
                <circle cx="50" cy="60" r="12" fill="%233b82f6" opacity="0.5"/>
                <circle cx="70" cy="45" r="7" fill="%2310b981" opacity="0.6"/>
                <circle cx="95" cy="35" r="14" fill="%23ec4899" opacity="0.6"/>
                <circle cx="105" cy="40" r="10" fill="%23ec4899" opacity="0.5"/>
                <circle cx="120" cy="65" r="6" fill="%23f97316" opacity="0.6"/>
                <text x="80" y="98" font-size="7" fill="%23475569" text-anchor="middle">WBC DIFF 2D</text>
            </svg>`;
        }
        if (type === 'WBC') {
            return `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 100" style="background:%23f8fafc">
                <rect width="160" height="100" fill="%23f1f5f9" stroke="%23cbd5e1"/>
                <path d="M20,85 Q45,25 70,55 T120,40 T145,85 Z" fill="%233b82f6" opacity="0.3" stroke="%232563eb" stroke-width="1.5"/>
                <line x1="20" y1="85" x2="150" y2="85" stroke="%2364748b"/>
                <text x="80" y="96" font-size="7" fill="%23475569" text-anchor="middle">Гістограма WBC</text>
            </svg>`;
        }
        if (type === 'RBC') {
            return `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 100" style="background:%23f8fafc">
                <rect width="160" height="100" fill="%23f1f5f9" stroke="%23cbd5e1"/>
                <path d="M20,85 Q85,15 145,85 Z" fill="%23ef4444" opacity="0.3" stroke="%23dc2626" stroke-width="1.5"/>
                <line x1="20" y1="85" x2="150" y2="85" stroke="%2364748b"/>
                <text x="80" y="96" font-size="7" fill="%23475569" text-anchor="middle">Гістограма RBC</text>
            </svg>`;
        }
        if (type === 'PLT') {
            return `data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 160 100" style="background:%23f8fafc">
                <rect width="160" height="100" fill="%23f1f5f9" stroke="%23cbd5e1"/>
                <path d="M20,85 Q40,10 65,60 T145,85 Z" fill="%2310b981" opacity="0.3" stroke="%23059669" stroke-width="1.5"/>
                <line x1="20" y1="85" x2="150" y2="85" stroke="%2364748b"/>
                <text x="80" y="96" font-size="7" fill="%23475569" text-anchor="middle">Гістограма PLT</text>
            </svg>`;
        }
        return '';
    }

    // Get Patient Image Data URLs (Always 100% stable Base64)
    function getPatientImages(patient) {
        const wbcImg = patient.wbcImgData || getDemoSVG('WBC');
        const rbcImg = patient.rbcImgData || getDemoSVG('RBC');
        const pltImg = patient.pltImgData || getDemoSVG('PLT');
        const diffImg = patient.diffImgData || getDemoSVG('DIFF');
        return { wbcImg, rbcImg, pltImg, diffImg };
    }

    // Format & Evaluate Parameter Value against Norms
    function evaluateParameter(paramKey, rawVal) {
        if (!rawVal || rawVal === '***.*' || rawVal === '***') {
            return { valStr: '—', flag: '', normStr: '—' };
        }

        const numVal = parseFloat(rawVal.replace(',', '.'));
        const info = PARAMETER_INFO[paramKey];

        if (!info || isNaN(numVal)) {
            return { valStr: rawVal, flag: '', normStr: '—' };
        }

        let flag = 'NORMAL';
        if (numVal < info.min) flag = 'LOW';
        else if (numVal > info.max) flag = 'HIGH';

        const normStr = `${info.min} - ${info.max}`;
        return { valStr: rawVal, flag, normStr, unit: info.unit, ukrName: info.ukrName, code: info.code };
    }

    /* ==========================================================================
       PRIMARY FULL CLINICAL REPORT GENERATOR (YELLOW ALERTS REMOVED COMPLETELY)
       ========================================================================== */
    function generateReportHTML(patient) {
        const fullName = `${patient['Фамилия'] || ''} ${patient['Имя'] || ''}`.trim() || 'Пацієнт';
        const sampleID = patient['ID образца.'] || '—';
        const rawTestTime = patient['Вр.измер.'] || patient['Время взят.пр.'] || '—';
        const { dateStr, timeStr } = splitUkrainianDateTime(rawTestTime);

        // 100% Persistent Base64 Images
        const { wbcImg, rbcImg, pltImg, diffImg } = getPatientImages(patient);

        // Build Table Rows
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
            if (rawVal !== undefined && rawVal !== '') {
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
                        <div class="test-type-sub">Загальний аналіз крові (CBC + 5-DIFF)${patient._hasBiochem ? ' + Біохімія' : ''}</div>
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
                        <div>Фельдшер-лаборант / Лікар: <span class="signature-line"></span></div>
                        <div>Підпис / Печатка: <span class="signature-line"></span></div>
                    </div>
                </div>
            </div>
        `;
    }

    // Render Currently Selected Patient (ALWAYS 1 CLEAN SINGLE REPORT ON PREVIEW CANVAS)
    function renderCurrentPatient() {
        if (filteredPatients.length === 0) {
            singleReportContainer.innerHTML = '<div style="padding:3rem;text-align:center;color:#64748b">Оберіть пацієнта зі списку ліворуч</div>';
            currentPatientTitle.textContent = 'Оберіть пацієнта для перегляду';
            return;
        }

        if (currentPatientIndex >= filteredPatients.length) currentPatientIndex = 0;
        const patient = filteredPatients[currentPatientIndex];
        const fullName = `${patient['Фамилия'] || ''} ${patient['Имя'] || ''}`.trim() || 'Пацієнт';
        currentPatientTitle.textContent = `Перегляд бланка: ${fullName} (ID: ${patient['ID образца.'] || currentPatientIndex + 1})`;

        // Always render 1 clean full A4 report on screen
        singleReportContainer.className = 'a4-preview-page';
        singleReportContainer.innerHTML = generateReportHTML(patient);
    }

    // Trigger Print Window reliably
    async function triggerPrint() {
        const images = Array.from(printContainer.querySelectorAll('img'));
        const loadPromises = images.map(img => {
            if (img.complete && img.naturalHeight !== 0) return Promise.resolve();
            return new Promise(resolve => {
                img.onload = resolve;
                img.onerror = resolve;
            });
        });

        await Promise.all(loadPromises);
        setTimeout(() => { window.print(); }, 250);
    }

    // Print Single Selected Patient
    function printCurrentReport() {
        if (filteredPatients.length === 0) return;
        const patient = filteredPatients[currentPatientIndex];

        printContainer.innerHTML = `
            <div class="printable-page">
                ${generateReportHTML(patient)}
            </div>
        `;
        triggerPrint();
    }

    // Print All Filtered Reports (1 A4 sheet per patient)
    function printAllReports() {
        if (filteredPatients.length === 0) return;

        let allPagesHTML = '';
        filteredPatients.forEach(patient => {
            allPagesHTML += `
                <div class="printable-page">
                    ${generateReportHTML(patient)}
                </div>
            `;
        });

        printContainer.innerHTML = allPagesHTML;
        triggerPrint();
    }

    // Reliable Script Initialization
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
