#NoEnv
#SingleInstance force
#Persistent
SendMode Input

Gui, MIA:Font, S10 CDefault, Arial
Gui, MIA:Add, Button, 		Center 				section   			vCheck9Col	gCheck9Col					,LOAD
Gui, MIA:Add, ComboBox, 	Center 		w560 	ys				vЧАСТИНА									,
Gui, MIA:Add, Button, 		Center 				ys   			vIMPORT		gIMPORT							,IMPORT
Gui, MIA:Add, Button, 		Center   			ys  			 			gDeleteAllRows					,CLEAR

Gui, MIA:Add, StatusBar,																					,

Gui, MIA:Font, S10 CDefault, Arial

Gui, MIA:Add, Progress, 			h10	w760 	section xs					vMyProgress 


Gui, MIA:Add, ListView, 		h670	w760 	xs  Checked	 Grid		vOft_ListView		gDeleteSelectedRow		,ID|Прізвище|Ім``я|Дата|VisOD|VisOS|ДатаПфОгляду		;Sort |Зріст|Вага|Тиск|Температура




Gui, MIA:Add, Button, 		    		w100	section xs  Center  		gOpenBase								,OPEN BASE

Gui, MIA:Add, Button, 		    		w380 	ys	  		Center  		gПереміститиНаПоля				,⮕
Gui, MIA:Add, Button, 		    		w60		ys  		Center  		gЗберегтиСписок					,SAVE

Gui, MIA:Add, DropDownList, Left 		w105	ys 		 					vOpenFileChoice 				,МедичнийОгляд|База|Список|ЗбереженийСписок|Призначення|ПсихофізіологІмпорт
Gui, MIA:Add, Button, 		    		w60		ys  		Center  		gЗавантажитиСписок				,OPEN

GuiControl, MIA:Choose, OpenFileChoice , 3
Gui, Submit, NoHide
gosub OpenFileChoice 


;Gui, MIA:Add, CheckBox, 		    	w100	ys  		Center  		vВЛК							,ВЛК

Gui, MIA:Font, S18 CDefault, Arial






Gui, MIA:Add, Edit, 		Left 		w750 	section ys ym x+20  										,

Gui, MIA:Font, S10 CDefault, Arial
Gui, MIA:Add, GroupBox, 	R11			w420	section xs													,Пацієнт

Gui, MIA:Font, S18 CDefault, Arial

Gui, MIA:Add, CheckBox, 	Left 		w60 	xp+10 	yp+30   					vIDГалочка					,№:
Gui, MIA:Add, Edit, 		Center 		w340 	xp+60 	yp		   					vID	 						,


;Gui, MIA:Add, CheckBox, 	Center 	w100 h35	xp+200 	yp		   					vНомерКарткиКнопка	 					,


Gui, MIA:Add, Edit, 		Left 		w400 	xp-60	yp+50   					vПрізвище	 		gCheckFields		,
Gui, MIA:Add, Edit, 		Left 		w400 	xp 		yp+50   					vІмя				gCheckFields		,
Gui, MIA:Add, Edit, 		Left		w350 	xp 		yp+50						vДатанародження		gCheckFields		,dd.MM.yyyy
Gui, MIA:Add, Button, 		Center		w40 h35	xp+360 	yp	 											gSEARCH				,🔍︎



Gui, MIA:Font, S10 CDefault, Arial
Gui, MIA:Add, Button, 		Center  h40	w100	xp-360	yp+50											gПОЧАТИ				,START
Gui, MIA:Add, Button, 		Center  h40	w300	xp+100 			   	Default 		vДОДАТИ				gAddToListView		,ДОДАТИ						;Default



Gui, MIA:Add, GroupBox, 	R11			w320	section ys																	,Налаштування

Gui, MIA:Font, S16 CDefault, Arial

Gui, MIA:Add, Text, 		Left 		w100	xp+10 	yp+30 												 				,Лікар:
Gui, MIA:Add, DropDownList, Left 		w200	xp+100 		 						vЛікарChoice 		gЛікарChoice		,Офтальмолог|Невролог|Психофізіолог|Терапевт

GuiControl, MIA:Choose, ЛікарChoice, 1
gosub ЛікарChoice


;Gui, MIA:Add, Text, 		Left 		w100	xp-100 	yp+50 												 				,Дата:
;Gui, MIA:Add, Edit, 		Left 		w200	xp+100 		 						vМедоглядПроведено						,

Gui, MIA:Add, Text, 		Left 		w100	xp-100 	yp+50																,Шаблон:

Gui, MIA:Font, S14 CDefault, Arial
Gui, MIA:Add, DropDownList, Left 		w200	xp+100								vШаблонChoice 							,Профогляд Офт.|ВЛК Офт.|Прийом Невролога|ВЛК Невролога|Прийом Психофізіолога

GuiControl, MIA:Choose, ШаблонChoice, 2







Gui, MIA:Add, CheckBox, 	Left	h40	w300 	xp-100	yp+50						vПрофогляд 			Checked				,Профогляд

;Gui, MIA:Add, CheckBox, 	Left    	w200	xp+150 	yp	    					vСтворитиНовийПрофогляд					,Створити новий

Gui, MIA:Add, CheckBox, 	Left    	w300	xp		yp+50	    				vПрийом				Checked				,Провести Ургентний Прийом

Gui, MIA:Add, CheckBox, 	Left		w200 	xp		yp+30						vДивитисьДіагнози 						,Дивитись діагнози

Gui, MIA:Add, CheckBox, 	Left    	w200	xp+200 	yp	    					vЗберігатиДіагнози						,Зберігати

Gui, MIA:Add, CheckBox, 	Left		w100 	xp-200 	yp+30						vПідпис					Checked			,Підпис

;Gui, MIA:Add, CheckBox, 	Left		w100 	xp 		yp+50	Disabled			vАвтозбереження 						,Autosave

Gui, MIA:Add, CheckBox, 	Left    	w100	xp+100 	yp	    				 									vДРУК	,ДРУК

Gui, MIA:Add, CheckBox, 	Left    	w200	xp+100 	yp	    				 					Checked		vЧерезЗапис	,Головна





;Gui, MIA:Add, Text, 		Right 		w130 	xp+10 yp+30													,Прізвище:
;Gui, MIA:Add, Text, 		Right 		w130 	xs															,Ім``я:
;Gui, MIA:Add, Text, 		Right 		w130 	xs															,Дата:
;Gui, MIA:Add, Text, 		Right 		w130 	xs															,

;Gui, MIA:Add, Text, 		Right 		w300 	ys															,Дата проходження:
;Gui, MIA:Add, Edit, 		Left 		w300 	ys   				vДатаПроходження	 					,





Gui, MIA:Font, S10 CDefault, Arial







;Gui, MIA:Add, Radio, 		Right		w280 	section xp+10 yp+30		gОфтальмолог	vОфтальмолог					Checked				,Офтальмолог
;Gui, MIA:Add, Radio, 		Right		w280 	section yp+30		 	gНевролог		vНевролог 											,Невролог
;Gui, MIA:Add, Radio, 		Right		w280 	section yp+30		 	gТерапевт		vТерапевт											,Терапевт





























Gui, MIA:Font, S18 CDefault, Arial


;Лікар=%Лікар%`nДивитись Діагнози=%ДивитисьДіагнози%`nАктивна Вкладка=%АктивнаВкладка%


 ; Если файл существует
    if (FileExist(ConfigFilePath)) {
        ; Чтение значений из файла конфигурации
        IniRead, Лікар, % ConfigFilePath, Settings, Лікар
        IniRead, ДивитисьДіагнози, % ConfigFilePath, Settings, Дивитись Діагнози
        IniRead, АктивнаВкладка, % ConfigFilePath, Settings, Активна Вкладка
        
        ; Применение значений к контролам GUI
        GuiControl,, Лікар, % Лікар
        GuiControl,, ДивитисьДіагнози, % ДивитисьДіагнози
        GuiControl,, АктивнаВкладка, % АктивнаВкладка
        
 ;       MsgBox, Настройки применены.
    } else {
 ;       MsgBox, Файл конфигурации не найден.
    }



Gui, MIA:Add, Tab3,		vMyTabs			w750	section	xs-430 ys+300							, Офтальмолог|Невролог|Психофізіолог|Терапевт
Gui, MIA:Tab, Офтальмолог








;Gui, MIA:Add, Text, 		Right 		w150 	ys										,По-батькові:
;Gui, MIA:Add, Edit, 		Left 		w300 	ys   Disabled	vПоБатькові				,

;Gui, MIA:Add, Text, 		Right 		w100 	ys										,Посада:
;Gui, MIA:Add, ComboBox, 	Left 		w300 	ys  disabled	vПосада					,

;Gui, MIA:Add, Text, 		Right 		w150 	ys										,Телефон:
;Gui, MIA:Add, Edit, Number	Left 		w300 	ys   Disabled	vТелефон				,




Gui, MIA:Font, S12 CDefault, Arial




Gui, MIA:Add, Text, 		Right 	w90 		section 								,Visus OD = ;xm+400 yp+60
Gui, MIA:Add, ComboBox, 	Center 		w50 	ys				vVisusOD				,1.0|0.9|0.8|0.7|0.6|0.5|0.4|0.3|0.2|0.1
GuiControl, MIA:Choose, VisusOD, 1

Gui, MIA:Add, Button, 		Center   	w30		ys   	 		gSetVisusODto09			,0.9

Gui, MIA:Add, CheckBox, 	Center 		w30	 	ys	gWithCorrOD	vWithCorrOD	Check3		,
;Gui, MIA:Add, Text, 		Left 		w100 	ys										,

Gui, MIA:Add, Text, 		Center 		w30 	ys 				vSphOD_text				,
Gui, MIA:Add, ComboBox, 	Center 		w60 	ys				vSphOD					,+6.0|+5.75|+5.5|+5.25|+5.0|+4.75|+4.5|+4.25|+4.0|+3.75|+3.5|+3.25|+3.0|+2.75|+2.5|+2.25|+2.0|+1.75|+1.5|+1.25|+1.0|+0.75|+0.5|+0.25|0.0|-0.25|-0.5|-0.75|-1.0|-1.25|-1.5|-1.75|-2.0|-2.25|-2.5|-2.75|-3.0|-3.25|-3.5|-3.75|-4.0|-4.25|-4.5|-4.75|-5.0|-5.25|-5.5|-5.75|-6.0
GuiControl, MIA:Choose, SphOD, 25

Gui, MIA:Add, Text, 		Left 		w50 	ys				vCylOD_text				,D CYL
Gui, MIA:Add, ComboBox, 	Center 		w60 	ys				vCylOD					,+6.0|+5.75|+5.5|+5.25|+5.0|+4.75|+4.5|+4.25|+4.0|+3.75|+3.5|+3.25|+3.0|+2.75|+2.5|+2.25|+2.0|+1.75|+1.5|+1.25|+1.0|+0.75|+0.5|+0.25|0.0|-0.25|-0.5|-0.75|-1.0|-1.25|-1.5|-1.75|-2.0|-2.25|-2.5|-2.75|-3.0|-3.25|-3.5|-3.75|-4.0|-4.25|-4.5|-4.75|-5.0|-5.25|-5.5|-5.75|-6.0

GuiControl, MIA:Choose, CylOD, 25

Gui, MIA:Add, Text, 		Center 		w30 	ys					vAxOD_text			,D  (
Gui, MIA:Add, Edit, 		Center 		w50 	ys	number	Limit3	vAxOD				,

Gui, MIA:Add, Text, 		Left 		w30 	ys				vVisusCorrOD_text		,) =
Gui, MIA:Add, ComboBox, 	Center 		w50 	ys				vVisusCorrOD			,1.0|0.9|0.8|0.7|0.6|0.5|0.4|0.3|0.2|0.1
GuiControl, MIA:Choose, VisusCorrOD, 1

;Gui, MIA:Add, Button, 		Center   	w50		ys   	 		gSetVisusCorrODto		,н.к.


Gui, MIA:Add, Text, 		Right 		w90 	section xs								,Visus OS =
Gui, MIA:Add, ComboBox, 	Center 		w50 	ys				vVisusOS				,1.0|0.9|0.8|0.7|0.6|0.5|0.4|0.3|0.2|0.1
GuiControl, MIA:Choose, VisusOS, 1

Gui, MIA:Add, Button, 		Center   	w30		ys   	 		gSetVisusOSto09			,0.9

Gui, MIA:Add, CheckBox, 	Center 		w30	  	ys		gWithCorrOS	vWithCorrOS	Check3 	,
;Gui, MIA:Add, Text, 		Left 		w100 	ys										,Без Корр.

Gui, MIA:Add, Text, 		Center 		w30 	ys				vSphOS_text				,
Gui, MIA:Add, ComboBox, 	Center 		w60 	ys				vSphOS					,+6.0|+5.75|+5.5|+5.25|+5.0|+4.75|+4.5|+4.25|+4.0|+3.75|+3.5|+3.25|+3.0|+2.75|+2.5|+2.25|+2.0|+1.75|+1.5|+1.25|+1.0|+0.75|+0.5|+0.25|0.0|-0.25|-0.5|-0.75|-1.0|-1.25|-1.5|-1.75|-2.0|-2.25|-2.5|-2.75|-3.0|-3.25|-3.5|-3.75|-4.0|-4.25|-4.5|-4.75|-5.0|-5.25|-5.5|-5.75|-6.0



GuiControl, MIA:Choose, SphOS, 25

Gui, MIA:Add, Text, 		Left 		w50 	ys				vCylOS_text				,D CYL
Gui, MIA:Add, ComboBox, 	Center 		w60 	ys				vCylOS					,+6.0|+5.75|+5.5|+5.25|+5.0|+4.75|+4.5|+4.25|+4.0|+3.75|+3.5|+3.25|+3.0|+2.75|+2.5|+2.25|+2.0|+1.75|+1.5|+1.25|+1.0|+0.75|+0.5|+0.25|0.0|-0.25|-0.5|-0.75|-1.0|-1.25|-1.5|-1.75|-2.0|-2.25|-2.5|-2.75|-3.0|-3.25|-3.5|-3.75|-4.0|-4.25|-4.5|-4.75|-5.0|-5.25|-5.5|-5.75|-6.0

GuiControl, MIA:Choose, CylOS, 25

Gui, MIA:Add, Text, 		Center 		w30 	ys					vAxOS_text			,D  (
Gui, MIA:Add, Edit, 		Center 		w50 	ys	number	Limit3	vAxOS				,

Gui, MIA:Add, Text, 		Left 		w30 	ys				vVisusCorrOS_text		,) =
Gui, MIA:Add, ComboBox, 	Center 		w50 	ys				vVisusCorrOS			,1.0|0.9|0.8|0.7|0.6|0.5|0.4|0.3|0.2|0.1
GuiControl, MIA:Choose, VisusCorrOS, 1

;Gui, MIA:Add, Button, 		Center   	w50		ys   	 		gSetVisusCorrOSto		,н.к.



VisusOD := 1.0
VisusOS := 1.0

VisusCorrOS := 1.0
VisusCorrOD := 1.0

Gui, MIA:Add, Text, 		Right w90 	section xs								,Додатково:
Gui, MIA:Add, CheckBox, 	Left  w200 	 		ys 			vПаузаНаVisus		,Пауза на Visus
Gui, MIA:Add, CheckBox, 	Left  w200 	 		ys 			vПаузаНаДії			,Пауза на Дії

Gui, MIA:Font, S10 CDefault, Arial

Gui, MIA:Add, Text, 		Right w90 	 section xs  Checked					,Діагноз 1:
Gui, MIA:Add, DropDownList, Right w200 			 ys vДіагноз1 gОбновитьДиагноз1	,Здоровий|Міопія|Гіперметропія|Простий міопічний астигматизм|Астенопія|Пінгвекула|Птеригіум|Ксантелазми повік|Рогівкова дуга|Інший|
Gui, MIA:Add, DropDownList, Right w200 			 ys vСтупінь1 gОбновить1		,слабкого ступеню|середнього ступеню|високого ступеню
Gui, MIA:Add, DropDownList, Right w200 			 ys vОко1 	  gОбновить1		,обох очей|правого ока|лівого ока

Gui, MIA:Add, Text, 		Right w90 	section	xs								,Коментар 1:
Gui, MIA:Add, Edit, 		Left  w620   		ys vПершаСтрокаДіагнозу			,Придатний.

Gui, MIA:Add, CheckBox, 	Center w90 	section xs 			vСупутнійCheckBox	,Діагноз 2:
Gui, MIA:Add, DropDownList, Right w200  		ys vДіагноз2 gОбновитьДиагноз2	,Здоровий|Міопія|Гіперметропія|Складний міопічний астигматизм|Астенопія|Пінгвекула|Птеригіум|Ксантелазми повік|Рогівкова дуга|Інший|
Gui, MIA:Add, DropDownList, Right w200 			ys vСтупінь2 gОбновить2			,слабкого ступеню|середнього ступеню|високого ступеню
Gui, MIA:Add, DropDownList, Right w200 			ys vОко2 	 gОбновить2			,обох очей|правого ока|лівого ока

Gui, MIA:Add, Text, 		Right w90 	section	xs								,Коментар 2:
Gui, MIA:Add, Edit, 		Left  w620   		ys vДругаСтрокаДіагнозу			,

Gui, MIA:Add, Text, 		Right w90 	section	xs								,Причини`n звернення:
Gui, MIA:Add, CheckBox, 	Left  w620   		ys vПричиниЗвернення Checked	,30 - Повне медичне обстеження

Gui, MIA:Add, Text, 		Right w90 	section	xs								,Заключення:
Gui, MIA:Add, Edit, 		Left  w620   		ys vПолеЗаключення	R2			,Здоровий. Придатний.



Gui, MIA:Add, CheckBox, 	Right w90 	section xs	VГалочкаРекомендації Checked		,Рекоменд.:
Gui, MIA:Add, ComboBox, 	Left  w620 ys vПолеРекомендацій 					,Дотримуватися режиму зору – уникати тривалого навантаження на очі, робити перерви при роботі за екраном (правило 20-20-20: кожні 20 хвилин дивитися на 20 секунд у далечінь). Зволожувати очі – використовувати штучні сльози, якщо є відчуття сухості. Захищати очі – носити сонцезахисні окуляри з UV-фільтром на вулиці, уникати прямого впливу яскравого світла. Дотримуватися гігієни очей – не торкатися очей брудними руками, уникати потрапляння пилу та косметики.|Виконувати зорові вправи на тренування аккомодації протягом 1 тижня або до поліпшення стану.|Тетрациклін мазь очна 1`%` наносити у кон'юнктивальний мішок у вигляді смужки 1 см, 2 рази на день 1 тиждень. |Стеження за рівнем ліпідів у крові. |Окомістин краплі очні крапати в обидва ока 3 рази на день 2 тижні.|Виконувати зорові вправи: Кожні 20 хвилин дивитись вдалину на об'єкт на відстані 6 метрів протягом 20 секунд. Робити перерви кожні 1-2 години, даючи очам відпочити від зорового навантаження на 5-10 хвилин. При можливості використовувати м'яке освітлення, яке не створюватиме бликів на екрані та жорстких тіней, налаштувати оптимальну яскравість та констрасність монітора відповідно до освітлення в приміщенні, налаштувати максимально можливу роздільну здатність та частоту оновлення. Оптимальна відстань від очей до екрану - 50-70 см. Для зволоження очей можна застосовувати штучні сльози у разі відчуття сухості. Контроль над  осанкою. Періодично виконувати вправи для очей, такі як фокусування на близьких і далеких об'єктах, тренування аккомодації стереограмами. Виключити вживання шкідливих звичок та підтримувати здоровий спосіб життя. Якщо симптоми зберігаються після дотримання всіх вищеперелічених рекомендацій, додатково звернутись до офтальмолога для подальшого обстеження. |


GuiControl, MIA:Choose, ПолеРекомендацій 		, 1



Gui, MIA:Tab, Невролог

Gui, MIA:Tab, Психофізіолог

Gui, MIA:Font, S18 CDefault, Arial

Gui, MIA:Add, Text, 		Left	w190 h35 	section 													,Дата огляду:
Gui, MIA:Add, Edit, 		Center	w200 h35	ys 			vДатаПфОгляду	Limit10			gCheckFields	,




Gui, MIA:Tab, Терапевт


Gui, MIA:Add, Text, 		Right	w100 h35 	section 													,Зріст:
Gui, MIA:Add, Edit, 		Center	w100 h35	ys 			vЗріст	Limit3	Number	gCheckFields			,

Gui, MIA:Add, Text, 		Right	w100 h35 	ys 															,Вага:
Gui, MIA:Add, Edit, 		Center	w100 h35	ys 			vВага	Limit3	Number	gCheckFields			,

Gui, MIA:Add, Button, 		Right	w100 h35 	section xs 	gГенеруватиТиск									,Тиск:
Gui, MIA:Add, Edit, 		Center	w100 h35	ys 	Limit7	vТиск			Number	gCheckFields			,

Gui, MIA:Add, Text, 		Right	w100 h35 	ys 															,t°:
Gui, MIA:Add, Edit, 		Center	w100 h35	ys 	Limit4	vТемпература	Number	gCheckFields			,36.6

; Задаем диапазоны для систолического и диастолического давления
Систолическое_Мин := 110
Систолическое_Макс := 135
Диастолическое_Мин := 70
Диастолическое_Макс := 85

gosub ГенеруватиТиск





gosub CheckFields



GuiControl, MIA:Choose, Діагноз1, 1
GuiControl, MIA:Choose, Ступінь1, 1
GuiControl, MIA:Choose, Око1, 1

GuiControl, MIA:Hide, Ступінь1  ; Скрыть поле "Ступінь" по умолчанию
GuiControl, MIA:Hide, Око1

GuiControl, MIA:Choose, Діагноз2, 1
GuiControl, MIA:Choose, Ступінь2, 1
GuiControl, MIA:Choose, Око2, 1

GuiControl, MIA:Hide, Ступінь2  ; Скрыть поле "Ступінь" по умолчанию
GuiControl, MIA:Hide, Око2



GuiControl,, SphOD_text, кор

GuiControl, MIA:Hide, SphOD
GuiControl, MIA:Hide, CylOD_text
GuiControl, MIA:Hide, CylOD
GuiControl, MIA:Hide, AxOD_text
GuiControl, MIA:Hide, AxOD
GuiControl, MIA:Hide, VisusCorrOD_text
GuiControl, MIA:Hide, VisusCorrOD

GuiControl,, SphOS_text, кор

GuiControl, MIA:Hide, SphOS
GuiControl, MIA:Hide, CylOS_text
GuiControl, MIA:Hide, CylOS
GuiControl, MIA:Hide, AxOS_text
GuiControl, MIA:Hide, AxOS
GuiControl, MIA:Hide, VisusCorrOS_text
GuiControl, MIA:Hide, VisusCorrOS



















;Gui, FILL:Font, S20 CDefault, Arial
;Gui, FILL:Add, Button, section w720 Center  								,Обєктивно


Gui, PAUSE:Font, S10 CDefault, Arial

	Gui, PAUSE:Add, Button, section w1470 h50 Center gПРОПУСТИТИ							, ПРОПУСТИТИ
	Gui, PAUSE:Add, Button, section w1470 h50 Center gПАУЗА									, ПАУЗА


	Gui, PAUSE:Add, Text, section xs w200 h30 Center 										,Пошук:
	
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПрізвище_PAUSE_Button						, Прізвище
	Gui, PAUSE:Add, Button, xs w200 h40 Center gЧекбоксШукати_PAUSE_Button					, Чекбокс Шукати
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПОШУК_PAUSE_Button							, ПОШУК
	Gui, PAUSE:Add, Button, xs w200 h40 Center gНеЗнайденоПацієнтів_PAUSE_Button			, Не Знайдено Пацієнтів
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПровестиУргентнийПрийом_PAUSE_Button		, Провести Ургентний Прийом
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПочатиПрийом_PAUSE_Button					, Почати Прийом
	Gui, PAUSE:Add, Button, xs w200 h40 Center gНеЗявивсяПрофільЗавантажено_PAUSE_Button	, (Профіль Завантажено)
	Gui, PAUSE:Add, Button, xs w200 h40 Center gЕпізодиЗавантажити_PAUSE_Button				, Епізоди Завантажити
	Gui, PAUSE:Add, Button, xs w200 h40 Center gНаВесьЭкран1_PAUSE_Button					, На Весь Экран 1
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПрофоглядОфтальмолога_PAUSE_Button			, Профогляд Офтальмолога
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПрийомОфтВЛК_PAUSE_Button					, Прийом Офт ВЛК
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПрийомНевролога_PAUSE_Button				, Прийом Невролога
	
	Gui, PAUSE:Add, Text, ys w200 h30 Center 									section		,Епізоди:
	
	Gui, PAUSE:Add, Button, xs w200 h40 Center gЕпізоди_PAUSE_Button						, Епізоди	
	Gui, PAUSE:Add, Button, xs w200 h40 Center gДодатиЄпізод_PAUSE_Button					, Додати Єпізод
	Gui, PAUSE:Add, Button, xs w200 h40 Center gТипЕпізоду_PAUSE_Button						, Тип Епізоду
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПрофілактика_PAUSE_Button					, Профілактика
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПриорітет_PAUSE_Button						, Приорітет
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПлановий_PAUSE_Button						, Плановий
	
	Gui, PAUSE:Add, Text, ys w200 h30 Center 									section		,Діагнози:
		
	Gui, PAUSE:Add, Button, xs w200 h40 Center gДіагнозиДодати_PAUSE_Button					, Діагнози Додати
	Gui, PAUSE:Add, Button, xs w200 h40 Center gДіагнозНовий_PAUSE_Button					, Діагноз Новий
	Gui, PAUSE:Add, Button, xs w200 h40 Center gДіагнозОберітьЗіСписку_PAUSE_Button			, Діагноз Оберіть Зі Списку
	Gui, PAUSE:Add, Button, xs w200 h40 Center gКоментарДоДіагнозу_PAUSE_Button				, Коментар До Діагнозу
	Gui, PAUSE:Add, Button, xs w200 h40 Center gЗБЕРЕГТИ_PAUSE_Button						, ЗБЕРЕГТИ
	Gui, PAUSE:Add, Button, xs w200 h40 Center gОСНОВНИЙ_PAUSE_Button						, ОСНОВНИЙ
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПричиниЗверненняІСРС2_PAUSE_Button			, Причини Звернення ІСРС2


	
	Gui, PAUSE:Add, Text, ys w200 h30 Center 									section		,Дії:
	
	Gui, PAUSE:Add, Button, xs w200 h40 Center gДіїДодати_PAUSE_Button						, Дії Додати
	Gui, PAUSE:Add, Button, xs w200 h40 Center gДіїОберітьЗіСписку_PAUSE_Button				, Дії Оберіть Зі Списку
	Gui, PAUSE:Add, Button, xs w200 h40 Center gКонсультаціяОфтальмолога_PAUSE_Button		, Консультація Офтальмолога
	Gui, PAUSE:Add, Button, xs w200 h40 Center gКонсультаціяНевролога_PAUSE_Button			, Консультація Невролога
	Gui, PAUSE:Add, Button, xs w200 h40 Center gДіїЗБЕРЕГТИ_PAUSE_Button					, Дії ЗБЕРЕГТИ
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПолеЗаключення_PAUSE_Button					, Поле Заключення
	Gui, PAUSE:Add, Button, xs w200 h40 Center gЕпізодиЗБЕРЕГТИ_PAUSE_Button				, Епізоди ЗБЕРЕГТИ
	Gui, PAUSE:Add, Button, xs w200 h40 Center gНазваEHealthПослуги_PAUSE_Button			, Назва EHealth Послуги


	
	Gui, PAUSE:Add, Text, ys w200 h30 Center 									section		,Профогляди:
	
	Gui, PAUSE:Add, Button, xs w200 h30 Center gПрофогляди_PAUSE_Button						, Профогляди
	Gui, PAUSE:Add, Button, xs w200 h30 Center gВроботі_PAUSE_Button						, В роботі
	Gui, PAUSE:Add, Button, xs w200 h30 Center gЛанцюг_PAUSE_Button							, Ланцюг
	
	Gui, PAUSE:Add, Button, xs w200 h30 Center gСтрокаПошуку_PAUSE_Button					, Строка Пошуку
	Gui, PAUSE:Add, Button, xs w200 h30 Center gДеталіПрийому_PAUSE_Button					, Деталі Прийому
	Gui, PAUSE:Add, Button, xs w200 h30 Center gПрофВлкДляСтворення_PAUSE_Button			, Профогляди/ВЛК
	Gui, PAUSE:Add, Button, xs w200 h30 Center gЗнайденоЗаписів1_PAUSE_Button				, Знайдено Записів: 1
	Gui, PAUSE:Add, Button, xs w200 h30 Center gСтворитиПрофогляд_PAUSE_Button				, Профогляд/ВЛК +
	Gui, PAUSE:Add, Button, xs w200 h30 Center gПрофоглядВЛКПоле_PAUSE_Button				, Профогляд/ВЛК *
	Gui, PAUSE:Add, Button, xs w200 h30 Center gНаказ246_PAUSE_Button						, Наказ №246
	Gui, PAUSE:Add, Button, xs w200 h30 Center gПрофоглядЗберегти_PAUSE_Button				, Профогляд Зберегти
	Gui, PAUSE:Add, Button, xs w200 h40 Center gВзятиВроботу_PAUSE_Button					, Взяти в роботу


	
	
	Gui, PAUSE:Add, Button, xs w200 h30 Center gВзаємодіяЗаключення_PAUSE_Button			, Взаємодія Заключення
	Gui, PAUSE:Add, Button, xs w200 h30 Center gПОСИЛАННЯ_PAUSE_Button						, ПОСИЛАННЯ
	Gui, PAUSE:Add, Button, xs w200 h30 Center gВзаємодіюБуло_PAUSE_Button					, Взаємодію Було
	Gui, PAUSE:Add, Button, xs w200 h30 Center gПричиниЗвернення_PAUSE_Button				, Причини Звернення
	Gui, PAUSE:Add, Button, xs w200 h30 Center gЗагальні_PAUSE_Button						, Загальні
	Gui, PAUSE:Add, Button, xs w200 h30 Center gНемає_PAUSE_Button							, Немає
	
	Gui, PAUSE:Add, Text, ys w200 h30 Center 									section		,Обєктивно:
	
	Gui, PAUSE:Add, Button, xs w200 h40 Center gОбєктивно_PAUSE_Button						, Обєктивно
	Gui, PAUSE:Add, Button, xs w200 h40 Center gVisOD_PAUSE_Button							, Vis OD
	Gui, PAUSE:Add, Button, xs w200 h40 Center gЧерепноМозковіНерви_PAUSE_Button			, Черепно-Мозкові нерви
	Gui, PAUSE:Add, Button, xs w200 h40 Center gХарактерЗору_PAUSE_Button					, Характер Зору
	Gui, PAUSE:Add, Button, xs w200 h40 Center gХарактерЗоруВнормі_PAUSE_Button				, Характер Зору: В нормі
	Gui, PAUSE:Add, Button, xs w200 h40 Center gРогівкаОД_PAUSE_Button						, Рогівка ОД
	Gui, PAUSE:Add, Button, xs w200 h40 Center gЗавершитиПрийом_PAUSE_Button				, ЗАВЕРШИТИ ПРИЙОМ
	
	Gui, PAUSE:Add, Text, ys w200 h30 Center 									section		,Підпис:
	
	Gui, PAUSE:Add, Button, xs w200 h40 Center gНевизначено_PAUSE_Button					, Невизначено
	Gui, PAUSE:Add, Button, xs w200 h40 Center gОбробка_PAUSE_Button						, Обробка
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПІДПИСАТИ_PAUSE_Button						, ПІДПИСАТИ
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПриватнийКлюч_PAUSE_Button					, Приватний ключ
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПарольДоКлюча_PAUSE_Button					, Пароль до ключа
	Gui, PAUSE:Add, Button, xs w200 h40 Center gЗчитатиКлюч_PAUSE_Button					, ЗчитатиКлюч
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПІДТВЕРДИТИ_PAUSE_Button					, ПІДТВЕРДИТИ
	Gui, PAUSE:Add, Button, xs w200 h40 Center gОброблено_PAUSE_Button						, Оброблено
	Gui, PAUSE:Add, Button, xs w200 h40 Center gГалочкаДодатиДоДруку_PAUSE_Button			, Додати до друку
	Gui, PAUSE:Add, Button, xs w200 h40 Center gДрук_PAUSE_Button							, ДРУК
	Gui, PAUSE:Add, Button, xs w200 h40 Center gЗначокПринтера_PAUSE_Button					, Значок Принтера
	Gui, PAUSE:Add, Button, xs w200 h40 Center gПечать_PAUSE_Button							, Печать




return


OpenBase:
FilePathExcel := A_ScriptDir "\МСЧ2023.xlsx"
; Открываем Excel
Run, %FilePathExcel%
return


WithCorrOD:

    GuiControlGet, WithCorrOD,, WithCorrOD

	if (WithCorrOD) = 0
	{
	
	GuiControl,, SphOD_text, кор

	GuiControl, MIA:Hide, SphOD
	GuiControl, MIA:Hide, CylOD_text
	GuiControl, MIA:Hide, CylOD
	GuiControl, MIA:Hide, AxOD_text
	GuiControl, MIA:Hide, AxOD
	GuiControl, MIA:Hide, VisusCorrOD_text
	GuiControl, MIA:Hide, VisusCorrOD
	}

	else if (WithCorrOD) = 1
	{
	
	GuiControl,, SphOD_text, SPH

	GuiControl, MIA:Show, SphOD
	GuiControl, MIA:Show, CylOD_text
	GuiControl, MIA:Show, CylOD
	GuiControl, MIA:Show, AxOD_text
	GuiControl, MIA:Show, AxOD
	GuiControl, MIA:Show, VisusCorrOD_text
	GuiControl, MIA:Show, VisusCorrOD
	}
	else if (WithCorrOD) = -1
	{
	
	GuiControl,, SphOD_text, н.к.	

	GuiControl, MIA:Hide, SphOD
	GuiControl, MIA:Hide, CylOD_text
	GuiControl, MIA:Hide, CylOD
	GuiControl, MIA:Hide, AxOD_text
	GuiControl, MIA:Hide, AxOD
	GuiControl, MIA:Hide, VisusCorrOD_text
	GuiControl, MIA:Hide, VisusCorrOD
	}

	
return



WithCorrOS:

    GuiControlGet, WithCorrOS,, WithCorrOS

	if (WithCorrOS) = 0
	{
	
	GuiControl,, SphOS_text, кор

	GuiControl, MIA:Hide, SphOS
	GuiControl, MIA:Hide, CylOS_text
	GuiControl, MIA:Hide, CylOS
	GuiControl, MIA:Hide, AxOS_text
	GuiControl, MIA:Hide, AxOS
	GuiControl, MIA:Hide, VisusCorrOS_text
	GuiControl, MIA:Hide, VisusCorrOS
	}

	else if (WithCorrOS) = 1
	{
	
	GuiControl,, SphOS_text, SPH

	GuiControl, MIA:Show, SphOS
	GuiControl, MIA:Show, CylOS_text
	GuiControl, MIA:Show, CylOS
	GuiControl, MIA:Show, AxOS_text
	GuiControl, MIA:Show, AxOS
	GuiControl, MIA:Show, VisusCorrOS_text
	GuiControl, MIA:Show, VisusCorrOS
	}
	else if (WithCorrOS) = -1
	{
	
	GuiControl,, SphOS_text, н.к.	

	GuiControl, MIA:Hide, SphOS
	GuiControl, MIA:Hide, CylOS_text
	GuiControl, MIA:Hide, CylOS
	GuiControl, MIA:Hide, AxOS_text
	GuiControl, MIA:Hide, AxOS
	GuiControl, MIA:Hide, VisusCorrOS_text
	GuiControl, MIA:Hide, VisusCorrOS
	}

return


SEARCH:
Gui, MIA:Submit, nohide

ExcelFilePath := A_ScriptDir "\МСЧ2023.xlsx"

; Открываем Excel
xl := ComObjCreate("Excel.Application")
if !xl {
    MsgBox Excel не найден!
    return
}

wb := xl.Workbooks.Open(ExcelFilePath)
if !wb {
    MsgBox Файл Excel не найден!
    return
}

TotalRows := wb.Sheets(1).UsedRange.Rows.Count
Progress := 0

    GuiControlGet, Прізвище,, Прізвище
	StringUpper, Прізвище, Прізвище
	GuiControl,MIA:, Прізвище, %Прізвище%

SearchSuccessful := 0 ; Переменная для отслеживания успешных совпадений

Loop, % TotalRows {
        ; Рассчитываем прогресс в процентах
        ProgressPercentage := (A_Index * 100) / TotalRows
		; Обновляем значение прогресс-бара
        GuiControl,, MyProgress, %ProgressPercentage%


    ws := wb.Sheets(1)
    ws.Cells(A_Index, 1).Activate
	

	CellValue := ws.Cells(A_Index, 9).Value
	ДатанародженняValue := ws.Cells(A_Index, 11).Value
	
	
	; msgbox %CellValue%

    ; Получаем значение из колонки 5
    CellData := ws.Cells(A_Index, 5).Value

    ; Получить фамилию и имя из главных полей
	ПрізвищеІмя := Прізвище . " " . Імя


	
	;MsgBox %ПрізвищеІмя%
	
	;MsgBox %ПрізвищеІмя% %CellData%
	
; Проверяем, совпадает ли значение в колонке 5 с Прізвище Імя
	; Разбиваем CellData на слова
	StringSplit, Words, CellData, %A_Space%

	; Проверяем наличие фамилии и имени
	if (Words1 = Прізвище && Words2 = Імя) {

	SearchSuccessful := 1 ; Увеличиваем счетчик успешных совпадений
	

    ; Проверяем, что значение не пустое
    if (CellData != "") {
 
 

	; Установить дату в Edit
	GuiControl,MIA:, Датанародження, %ДатанародженняValue%


        Progress := 0
        GuiControl,, Progress, 0
		
		SoundBeep, 392
		SoundBeep, 523
		break
    }
}

}



xl.Quit()
xl := ""
wb := ""


RowCount := LV_GetCount()
Общее_время_в_секундах := RowCount * 80
Часы := Общее_время_в_секундах // 3600
Минуты := (Общее_время_в_секундах // 60) - (Часы * 60)
Секунды := Общее_время_в_секундах - (Часы * 3600) - (Минуты * 60)

FormatTime, Текущее_время, %A_Now%, HH:mm:ss
Новое_время := (Часы * 3600) + (Минуты * 60) + Секунды
FormatTime, Конечное_время, Новое_время, HH:mm:ss

SB_SetParts(300)
SB_SetText(" " . RowCount . " пацієнтів - знадобиться " . Часы . " ч " . Минуты . " м " . Секунды . " с ", 1)

	
	if (!SearchSuccessful) {

		SoundBeep, 523
		SoundBeep, 523
		SoundBeep, 523
		SB_SetText("Збігів для " . Прізвище . " " . Імя . " НЕ знайдено", 2)
	}
	else
	SB_SetText("Дату народження для " . Прізвище . " " . Імя . " знайдено у " . CellValue, 2)
return


IMPORT:
Gui, MIA:Submit, nohide

ExcelFilePath := A_ScriptDir "\МСЧ2023.xlsx"

; Открываем Excel
xl := ComObjCreate("Excel.Application")
if !xl {
    MsgBox Excel не найден!
    return
}

wb := xl.Workbooks.Open(ExcelFilePath)
if !wb {
    MsgBox Файл Excel не найден!
    return
}

TotalRows := wb.Sheets(1).UsedRange.Rows.Count
Progress := 0

    ; Получаем выбранное значение из ComboBox "ЧАСТИНА"


	; msgbox %ЧАСТИНА%

Loop, % TotalRows {
        ; Рассчитываем прогресс в процентах
        ProgressPercentage := (A_Index * 100) / TotalRows
		; Обновляем значение прогресс-бара
        GuiControl,, MyProgress, %ProgressPercentage%


    ws := wb.Sheets(1)
    ws.Cells(A_Index, 1).Activate
	

	CellValue := ws.Cells(A_Index, 9).Value
	ДатанародженняValue := ws.Cells(A_Index, 11).Value
	
	
	; msgbox %CellValue%

	
; Проверяем, совпадает ли значение в колонке 9 с выбранным значением ComboBox "ЧАСТИНА"
if (CellValue = ЧАСТИНА) {
    ; Получаем значение из колонки 5
    CellData := ws.Cells(A_Index, 5).Value
    
    ; Проверяем, что значение не пустое
    if (CellData != "") {
        ; Разделить строку на части используя пробел в качестве разделителя
        StringSplit, Names, CellData, %A_Space%
        
        ; Получить фамилию и имя
        Прізвище := Names1
        Імя := Names2
		Датанародження := ДатанародженняValue
        
        ; Добавить значения в ListView
		LV_Add("",ID, Прізвище, Імя, Датанародження,VisusOD,VisusOS,ДатаПфОгляду,Зріст,Вага,Тиск,Температура)
        LV_ModifyCol()
        Progress := A_Index
        GuiControl,, Progress, %Progress%
    }
}

}

xl.Quit()
xl := ""
wb := ""

RowCount := LV_GetCount()
Общее_время_в_секундах := RowCount * 80
Часы := Общее_время_в_секундах // 3600
Минуты := (Общее_время_в_секундах // 60) - (Часы * 60)
Секунды := Общее_время_в_секундах - (Часы * 3600) - (Минуты * 60)

FormatTime, Текущее_время, %A_Now%, HH:mm:ss
Новое_время := (Часы * 3600) + (Минуты * 60) + Секунды
FormatTime, Конечное_время, Новое_время, HH:mm:ss

SB_SetParts(300)
SB_SetText(" " . RowCount . " пацієнтів - знадобиться " . Часы . " ч " . Минуты . " м " . Секунды . " с ", 1)
return







ПАУЗА:
    If (A_IsPaused)
    {
		Gui, PAUSE:Submit
        Pause, Off
    }
    Else
    {
		Gui, PAUSE:Submit
        Pause, On
    }
return

ПРОПУСТИТИ:
goto ScriptEnd
return




Прізвище_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto Прізвище_Found_LOOP
return

ЧекбоксШукати_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto ЧекбоксШукати_Found_LOOP
return

ПОШУК_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto ПОШУК_Found_LOOP
return


НеЗнайденоПацієнтів_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto НеЗнайденоПацієнтів_Found_LOOP
return


ПровестиУргентнийПрийом_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto ПровестиУргентнийПрийом_Found_LOOP
return

ПочатиПрийом_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto ПочатиПрийом_Found_LOOP
return

НеЗявивсяПрофільЗавантажено_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto НеЗявивсяПрофільЗавантажено_Found_LOOP
return

ЕпізодиЗавантажити_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto ЕпізодиЗавантажити_Found_LOOP
return

НаВесьЭкран1_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto НаВесьЭкран1_Found_LOOP
return

ПрофоглядОфтальмолога_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto ПрофоглядОфтальмолога_Found_LOOP
return

ПрийомОфтВЛК_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПрийомОфтВЛК_Found_LOOP
return

ПрийомНевролога_PAUSE_Button:
	SoundBeep, 900
Gui, PAUSE:Submit
	goto ПрийомНевролога_Found_LOOP
return








Епізоди_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Епізоди_Found_LOOP
return

ДодатиЄпізод_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ДодатиЄпізод_Found_LOOP
return



ТипЕпізоду_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ТипЕпізоду_Found_LOOP
return

Профілактика_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Профілактика_Found_LOOP
return

Приорітет_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Приорітет_Found_LOOP
return

Плановий_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Плановий_Found_LOOP
return

ДіагнозиДодати_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ДіагнозиДодати_Found_LOOP
return

ДіагнозНовий_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ДіагнозНовий_Found_LOOP
return

ДіагнозОберітьЗіСписку_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ДіагнозОберітьЗіСписку_Found_LOOP
return


КоментарДоДіагнозу_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto КоментарДоДіагнозу_Found_LOOP
return

ЗБЕРЕГТИ_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ЗБЕРЕГТИ_Found_LOOP
return

ОСНОВНИЙ_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ОСНОВНИЙ_Found_LOOP
return



ПричиниЗверненняІСРС2_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПричиниЗверненняІСРС2_Found_LOOP
return


ДіїДодати_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ДіїДодати_Found_LOOP
return

ДіїОберітьЗіСписку_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ДіїОберітьЗіСписку_Found_LOOP
return

КонсультаціяОфтальмолога_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto КонсультаціяОфтальмолога_Found_LOOP
return

КонсультаціяНевролога_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto КонсультаціяНевролога_Found_LOOP
return

ДіїЗБЕРЕГТИ_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ДіїЗБЕРЕГТИ_Found_LOOP
return


НазваEHealthПослуги_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto НазваEHealthПослуги_Found_LOOP
return



ПолеЗаключення_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПолеЗаключення_Found_LOOP
return

ЕпізодиЗБЕРЕГТИ_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ЕпізодиЗБЕРЕГТИ_Found_LOOP
return

Профогляди_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Профогляди_Found_LOOP
return



Вроботі_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Вроботі_Found_LOOP
return

Ланцюг_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Ланцюг_Found_LOOP
return


СтрокаПошуку_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto СтрокаПошуку_Found_LOOP
return


ДеталіПрийому_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ДеталіПрийому_Found_LOOP
return


ПрофВлкДляСтворення_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПрофВлкДляСтворення_Found_LOOP
return

ЗнайденоЗаписів1_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ЗнайденоЗаписів1_Found_LOOP
return

СтворитиПрофогляд_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto СтворитиПрофогляд_Found_LOOP
return

ПрофоглядВЛКПоле_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПрофоглядВЛКПоле_Found_LOOP
return

Наказ246_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Наказ246_Found_LOOP
return

ПрофоглядЗберегти_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПрофоглядЗберегти_Found_LOOP
return

ВзятиВроботу_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ВзятиВроботу_Found_LOOP
return














ВзаємодіяЗаключення_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ВзаємодіяЗаключення_Found_LOOP
return

ПОСИЛАННЯ_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПОСИЛАННЯ_Found_LOOP
return

ВзаємодіюБуло_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ВзаємодіюБуло_Found_LOOP
return

ПричиниЗвернення_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПричиниЗвернення_Found_LOOP
return

Загальні_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Загальні_Found_LOOP
return

Немає_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Немає_Found_LOOP
return

Обєктивно_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Обєктивно_Found_LOOP
return

VisOD_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto VisOD_Found_LOOP
return










ЧерепноМозковіНерви_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ЧерепноМозковіНерви_Found_LOOP
return









ХарактерЗору_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ХарактерЗору_Found_LOOP
return

ХарактерЗоруВнормі_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ХарактерЗоруВнормі_Found_LOOP
return

РогівкаОД_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto РогівкаОД_Found_LOOP
return

ЗавершитиПрийом_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ЗавершитиПрийом_Found_LOOP
return

Невизначено_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Невизначено_Found_LOOP
return

Обробка_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Обробка_Found_LOOP
return

ПІДПИСАТИ_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПІДПИСАТИ_Found_LOOP
return

ПриватнийКлюч_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПриватнийКлюч_Found_LOOP
return

ПарольДоКлюча_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПарольДоКлюча_Found_LOOP
return

ЗчитатиКлюч_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ЗчитатиКлюч_Found_LOOP
return

ПІДТВЕРДИТИ_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ПІДТВЕРДИТИ_Found_LOOP
return

Оброблено_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Оброблено_Found_LOOP
return

ГалочкаДодатиДоДруку_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ГалочкаДодатиДоДруку_Found_LOOP
return

Друк_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Друк_Found_LOOP
return

ЗначокПринтера_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto ЗначокПринтера_Found_LOOP
return

Печать_PAUSE_Button:
	SoundBeep, 900
	Gui, PAUSE:Submit
	goto Печать_Found_LOOP
return










GuiClose:
ExitApp





insert::
Gui, МІА:Submit
Gui, PAUSE:+MaximizeBox +DPIScale
Gui, PAUSE:Show, Maximize Center, Продовжити з цієї кнопки:
return





F11:

SelectedIndex := LV_GetNext("", "F") ; Получить индекс первого выбранного элемента
if (SelectedIndex != "") {
    LV_Modify("Select", SelectedIndex) ; Выбрать элемент по его индексу
	MsgBox, %SelectedIndex%
} else {
    MsgBox, Нет выбранных элементов в ListView.
}


return



; Устанавливаем начальное значение переменной для выбора goto
current_goto := 1




GotoSwitch:
    ; Проверяем значение переменной и переходим к соответствующей метке
    switch current_goto {
        case 1:
		Msgbox 1
			ToolTip
            goto ЧекбоксШукати_Found_LOOP
        case 2:
		Msgbox 2
			ToolTip
            goto ПОШУК_Found_LOOP
        case 3:
		Msgbox 3
			ToolTip
            goto НеЗнайденоПацієнтів_Found_LOOP
        case 4:
			ToolTip
            goto ПровестиУргентнийПрийом_Found_LOOP
        case 5:
			ToolTip
            goto ПочатиПрийом_Found_LOOP
        case 6:
			ToolTip
            goto НеЗявивсяПрофільЗавантажено_Found_LOOP
        case 7:
            goto ЕпізодиЗавантажити_Found_LOOP
        case 8:
            goto НаВесьЭкран1_Found_LOOP
        case 9:
            goto ПрофоглядОфтальмолога_Found_LOOP
        case 10:
            goto ПрийомНевролога_Found_LOOP
        default:
            ; Если значение выходит за пределы доступных меток, возвращаемся к начальной
            current_goto := 1


    }
return


OpenFileChoice:
Gui, Submit, NoHide

SelectedFileChoice := OpenFileChoice

; Устанавливаем значения переменных в зависимости от выбранной зоны



if (SelectedFileChoice = "МедичнийОгляд")
{
	МедичнийОгляд := 1
    База := 0
    Список := 0
	ЗбереженийСписок := 0
    Призначення := 0
	ПсихофізіологІмпорт := 0
}




if (SelectedFileChoice = "База")
{
	МедичнийОгляд := 0
    База := 1
    Список := 0
	ЗбереженийСписок := 0
    Призначення := 0
	ПсихофізіологІмпорт := 0
}
else if (SelectedFileChoice = "Список")
{
	МедичнийОгляд := 0
    База := 0
    Список := 1
	ЗбереженийСписок := 0
    Призначення := 0
	ПсихофізіологІмпорт := 0
}
else if (SelectedFileChoice = "ЗбереженийСписок")
{
	МедичнийОгляд := 0
    База := 0
    Список := 0
	ЗбереженийСписок := 1
    Призначення := 0
	ПсихофізіологІмпорт := 0
}
else if (SelectedFileChoice = "Призначення")
{
	МедичнийОгляд := 0
    База := 0
    Список := 0
	ЗбереженийСписок := 0
    Призначення := 1
	ПсихофізіологІмпорт := 0
}
else if (SelectedFileChoice = "ПсихофізіологІмпорт")
{
	МедичнийОгляд := 0
    База := 0
    Список := 0
	ЗбереженийСписок := 0
    Призначення := 0
	ПсихофізіологІмпорт := 1
}


return


ЛікарChoice:
Gui, Submit, NoHide

SelectedЛікар := ЛікарChoice

; Устанавливаем значения переменных в зависимости от выбранной зоны
if (SelectedЛікар = "Офтальмолог")
{
		GuiControl, MIA:Choose, Офтальмолог, Choose1
		GuiControl, MIA:Choose, MyTabs, 1
    Офтальмолог := 1
    Невролог := 0
	Психофізіолог := 0
    Терапевт := 0
}
else if (SelectedЛікар = "Невролог")
{
		GuiControl, MIA:Choose, Невролог, Choose1
		GuiControl, MIA:Choose, MyTabs, 2
    Офтальмолог := 0
    Невролог := 1
	Психофізіолог := 0
    Терапевт := 0
}
else if (SelectedЛікар = "Психофізіолог")
{
		GuiControl, MIA:Choose, Психофізіолог, Choose1
		GuiControl, MIA:Choose, MyTabs, 3
    Офтальмолог := 0
    Невролог := 0
	Психофізіолог := 1
    Терапевт := 0
}
else if (SelectedЛікар = "Терапевт")
{
		GuiControl, MIA:Choose, Терапевт, Choose1
		GuiControl, MIA:Choose, MyTabs, 4
    Офтальмолог := 0
    Невролог := 0
	Психофізіолог := 0
    Терапевт := 1
}
return


;Офтальмолог:
;GuiControl, MIA:Choose, Офтальмолог, Choose1
;GuiControl, MIA:Choose, MyTabs, 1
;return

;Невролог:
;GuiControl, MIA:Choose, Невролог, Choose1
;GuiControl, MIA:Choose, MyTabs, 2
;return

;Терапевт:
;GuiControl, MIA:Choose, Терапевт, Choose1
;GuiControl, MIA:Choose, MyTabs, 3
;return


синий_LOOP:
	 Click,30 103 0
	 PixelGetColor,синий,30,103
	 If ( синий = 0xD77800 )
	 {
	 Sleep 500
	 Click,30,103
	 Sleep 500
	 }

	 else If ( синий = 0xFFFFFF )
	 {


;	 	SoundBeep, 392, 100
;		Sleep 50
;		SoundBeep, 523, 100
;		Sleep 50
;		SoundBeep, 660, 200
;		Sleep 50

		SoundBeep, 523, 100 ;ccge

		SoundBeep, 523, 100

		SoundBeep, 784, 100

		SoundBeep, 659, 100
		Sleep 500

		Sleep 500
		Reload
		Sleep 500
	 }
	 else
	 {
	 Sleep 1000
	 goto синий_LOOP
	 }
return


F6::
Function6:
F6continue := 0
gosub ЛікарChoice

SetTimer, CheckLanguage, Off

; Выбрать первый элемент в ListView

	 Sleep 500
	 Click,62,141
	 Sleep 1000

;gosub ПереміститиНаПоля



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gПереміститиКнопка_PAUSE_Button		, ПереміститиКнопка

;ПереміститиКнопка_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ПереміститиКнопка_Found_LOOP
;return

ПереміститиКнопка_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПереміститиКнопкаFoundX, ПереміститиКнопкаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПереміститиКнопка.png
	if ErrorLevel = 0
	{
		Sleep 10
		ПереміститиКнопкаFoundXPlus10 := ПереміститиКнопкаFoundX + 10
		ПереміститиКнопкаFoundYPlus10 := ПереміститиКнопкаFoundY + 10
		Click, %ПереміститиКнопкаFoundXPlus10%, %ПереміститиКнопкаFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 10
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (ПереміститиКнопка), 930, 1
		goto ПереміститиКнопка_Found_LOOP
	}

If Призначення = 1
{
	If F6continue = 1
	{
		goto BackToF9
	}
}



; ПереміститиКнопка_LOOP: 
;	 Click,358 971 0 
;	 PixelGetColor, ПереміститиКнопка,358,971
;	 If (  ПереміститиКнопка = 0xF9EEE0 ) 
;	 { 
;	 Sleep 500
;	 Click,358,971
;	 } 
;	 else 
;	 { 
;	 Sleep 500 
;	 goto  ПереміститиКнопка_LOOP 
;	 } 

Sleep 500
goto ПОЧАТИ
Sleep 500

ЗнайтиКнопка_LOOP:
	 Click,610 701 0
	 PixelGetColor,ЗнайтиКнопка,610,721
	 If ( ЗнайтиКнопка = 0xF9EEE0 )
	 {
	 Sleep 500
	 Click,610,701
	 Sleep 1000
	 goto start1
	 }
	 else
	 {
	 Sleep 1000
	 goto ЗнайтиКнопка_LOOP
	 }
	return


F1::
start:


SetTimer, CheckLanguage, 1000


;Send #d
Sleep 100



Прізвище =
Імя =
Датанародження =
VisusOD = 1.0
VisusOS = 1.0

VisusCorrOD = 1.0
VisusCorrOS = 1.0

GuiControl, MIA:Choose, Діагноз1, 1
GuiControl, MIA:Choose, Ступінь1, 1
GuiControl, MIA:Choose, Око1, 1

GuiControl, MIA:Choose, Діагноз2, 1
GuiControl, MIA:Choose, Ступінь2, 1
GuiControl, MIA:Choose, Око2, 1


GuiControl,MIA:, Прізвище, %Прізвище%
GuiControl,MIA:, Імя, %Імя%
GuiControl,MIA:, Датанародження, %Датанародження%
GuiControl,MIA:, VisusOD, 1.0
GuiControl,MIA:, VisusOS, 1.0

GuiControl,MIA:, ДатаПфОгляду, %ДатаПфОгляду%

GuiControl,MIA:, VisusCorrOD, 1.0
GuiControl,MIA:, VisusCorrOS, 1.0


GuiControl, MIA:Choose, MyTabs, 1


GuiControl, MIA:Focus, Прізвище


SysGet, ScreenWidth, 0
SysGet, ScreenHeight, 1


 








OnMessage(0x100, "KeyPressed") ; Отлавливаем сообщение WM_KEYDOWN (0x100)

;	Gui  MIA:+MaximizeBox +DPIScale +FullScreen

;Gui, MIA:Show, AutoSize Center, Новий пацієнт:

;gosub Check9Col

Gui, MIA:+MaximizeBox +DPIScale
Gui, MIA:Show, Maximize

return



Check9Col:



ExcelFilePath := A_ScriptDir "\МСЧ2023.xlsx"

; Открываем Excel
xl := ComObjCreate("Excel.Application")
if !xl {
    MsgBox Excel не найден!
    return
}

wb := xl.Workbooks.Open(ExcelFilePath)
if !wb {
    MsgBox Файл Excel не найден!
    return
}

TotalRows := wb.Sheets(1).UsedRange.Rows.Count

; Проход по колонке номер 9 и добавление уникальных значений в ComboBox
UniqueValues := {}  ; Создание ассоциативного массива для хранения уникальных значений
Loop, % TotalRows {
    ws := wb.Sheets(1)
    CellValue := ws.Cells(A_Index, 9).Value
	
    ; Добавление значения в ассоциативный массив, чтобы получить только уникальные значения
    UniqueValues[CellValue] := 1
}

; Добавление уникальных значений в ComboBox
for key, value in UniqueValues
    GuiControl,MIA:, ЧАСТИНА, % key


xl.Quit()
xl := ""
wb := ""

		SoundBeep, 392
		SoundBeep, 523

GuiControl,MIA:, ЧАСТИНА, %ExcelFilePath%

RowCount := LV_GetCount()
Общее_время_в_секундах := RowCount * 80
Часы := Общее_время_в_секундах // 3600
Минуты := (Общее_время_в_секундах // 60) - (Часы * 60)
Секунды := Общее_время_в_секундах - (Часы * 3600) - (Минуты * 60)

FormatTime, Текущее_время, %A_Now%, HH:mm:ss
Новое_время := (Часы * 3600) + (Минуты * 60) + Секунды
FormatTime, Конечное_время, Новое_время, HH:mm:ss

SB_SetParts(300)
SB_SetText(" " . RowCount . " пацієнтів - знадобиться " . Часы . " ч " . Минуты . " м " . Секунды . " с ", 1)
SB_SetText("Список частин завантажено", 2)
	
	GuiControl, MIA:Disable, Check9Col

return




CheckLanguage:
; Получить код языка клавиатуры
keyboardLayout := DllCall("GetKeyboardLayout", "UInt", 0)
keyboardLang := keyboardLayout & 0xFFFF ; Получить нижние 16 бит

; Проверка языка клавиатуры
if (keyboardLang = 0x422) ; Украинский язык
{
    ;SoundBeep, 880
    EnableFields() ; Включить поля ввода
}
else
{
    DisableFields() ; Выключить поля ввода
}

return

EnableFields() {
    GuiControl, MIA:Enable, Прізвище
    GuiControl, MIA:Enable, Імя
    GuiControl, MIA:Enable, Датанародження
}

DisableFields() {
    GuiControl, MIA:Disable, Прізвище
    GuiControl, MIA:Disable, Імя
    GuiControl, MIA:Disable, Датанародження
}


CheckFields:



;Офтальмолог := Офтальмолог
;Невролог := Невролог
;Терапевт := Терапевт

If (Офтальмолог = "1" or Невролог = "1" or Психофізіолог = "1")
{
    GuiControlGet, Прізвище,, Прізвище
    GuiControlGet, Імя,, Імя
    GuiControlGet, Датанародження,, Датанародження
	GuiControlGet, ДатаПфОгляду ,, ДатаПфОгляду

    if (Прізвище != "" and Імя != "" and Датанародження != "") {
        GuiControl, MIA:Enable, ДОДАТИ ; Активировать кнопку
    } else {
        GuiControl, MIA:Disable, ДОДАТИ ; Деактивировать кнопку
    }
}

If Терапевт = "1"
{
    GuiControlGet, Прізвище,, Прізвище
    GuiControlGet, Імя,, Імя
    GuiControlGet, Датанародження,, Датанародження
	
	GuiControlGet, Зріст,, Зріст
	GuiControlGet, Вага,, Вага
	GuiControlGet, Тиск,, Тиск
	GuiControlGet, Температура,, Температура
	
	    if (Прізвище != "" and Імя != "" and Датанародження != "" and Зріст != "" and Вага != "" and Тиск != "" and Температура != "") {
        GuiControl, MIA:Enable, ДОДАТИ ; Активировать кнопку
    } else {
        GuiControl, MIA:Disable, ДОДАТИ ; Деактивировать кнопку
    }
}



return


;SetVisusCorrODto:

;	chooseVisusCorrOD := 11
;   GuiControl, MIA:Choose, VisusCorrOD, %chooseVisusCorrOD%

;return



;SetVisusCorrOSto:

;	chooseVisusCorrOS := 11
;    GuiControl, MIA:Choose, VisusCorrOS, %chooseVisusCorrOS%

;return

SetVisusODto09:

	chooseVisusOD := 2
    GuiControl, MIA:Choose, VisusOD, %chooseVisusOD%

return

SetVisusOSto09:

	chooseVisusOS := 2
    GuiControl, MIA:Choose, VisusOS, %chooseVisusOS%

return


; Функция для генерации давления
ГенеруватиТиск:
    Random, Систолическое, % Систолическое_Мин, % Систолическое_Макс
    Random, Диастолическое, % Диастолическое_Мин, % Диастолическое_Макс
    Тиск := Систолическое "/" Диастолическое
    GuiControl, MIA: , Тиск, %Тиск%
	
	

return









ЗберегтиСписок:
Gui, Submit, NoHide

 ; Получение текста переменной %ЧАСТИНА%
    ЧАСТИНА := ЧАСТИНА
    
    ; Создание объекта COM для работы с Excel
    xl := ComObjCreate("Excel.Application")
    xl.Visible := true ; Сделать Excel видимым (можно отключить)

    ; Создание новой книги Excel
    wb := xl.Workbooks.Add()
    ws := wb.ActiveSheet




	; Копирование данных из ListView в Excel
	Loop % LV_GetCount() {
        LV_GetText(ID, A_Index, 1) 						; 1 - индекс колонки с ID
        LV_GetText(Прізвище, A_Index, 2) 				; 2 - индекс колонки с Прізвище
        LV_GetText(Імя, A_Index, 3) 					; 3 - индекс колонки с Імя
        LV_GetText(Датанародження, A_Index, 4) 			; 4 - индекс колонки с Датанародження
		LV_GetText(VisusOD, A_Index, 5) 				; 5 - индекс колонки с VisusOD
        LV_GetText(VisusOS, A_Index, 6) 				; 6 - индекс колонки с VisusOS
		LV_GetText(ДатаПфОгляду, A_Index, 7) 				; 7 - индекс колонки с ДатаПфОгляду

        ws.Cells(A_Index, 1).Value := ID 
        ws.Cells(A_Index, 2).Value := Прізвище
;		Msgbox %Прізвище%
        ws.Cells(A_Index, 3).Value := Імя
;		Msgbox %Імя%
        ws.Cells(A_Index, 4).Value := Датанародження
;		Msgbox %Датанародження%
        ws.Cells(A_Index, 5).Value := VisusOD
		ws.Cells(A_Index, 6).Value := VisusOS
		ws.Cells(A_Index, 7).Value := ДатаПфОгляду
    }


; Запрашиваем выбор папки
;FileSelectFolder, SelectedFolder, , 3, Выберите папку для сохранения книги

; Проверяем, была ли выбрана папка
;if (SelectedFolder = "")
;{
;    MsgBox, Вы не выбрали папку. Сохранение отменено.
 ;   return
;}

; Полный путь для сохранения файла
;FullSavePath := SelectedFolder ".xlsx"

; Сохранение книги Excel
;wb.SaveAs(FullSavePath)

    ; Сохранение книги Excel
    wb.SaveAs(A_ScriptDir "\ЧАСТИНИ\Новий медогляд 2024\" ЧАСТИНА ".xlsx")

    ; Закрытие книги и Excel
    wb.Close(true)
    xl.Quit()

    ; Освобождение ресурсов
    wb := ""
    xl := ""
	

	
RowCount := LV_GetCount()
Общее_время_в_секундах := RowCount * 80
Часы := Общее_время_в_секундах // 3600
Минуты := (Общее_время_в_секундах // 60) - (Часы * 60)
Секунды := Общее_время_в_секундах - (Часы * 3600) - (Минуты * 60)

FormatTime, Текущее_время, %A_Now%, HH:mm:ss
Новое_время := (Часы * 3600) + (Минуты * 60) + Секунды
FormatTime, Конечное_время, Новое_время, HH:mm:ss

SB_SetParts(300)
SB_SetText(" " . RowCount . " пацієнтів - знадобиться " . Часы . " ч " . Минуты . " м " . Секунды . " с ", 1)
SB_SetText("Список " . ЧАСТИНА . " збережено",2)
return




ЗавантажитиСписок:
gosub OpenFileChoice

Gui, MIA:Submit, nohide
FileSelectFile, ExcelFilePath, 1, , Выберите файл Excel, Excel Files (*.xlsx; *.xls)
if ErrorLevel
    return

; Открываем Excel
xl := ComObjCreate("Excel.Application")
if !xl {
    MsgBox Excel не найден!
    return
}

wb := xl.Workbooks.Open(ExcelFilePath)
if !wb {
    MsgBox Файл Excel не найден!
    return
}








; Получаем текущую дату в нужном формате для имени листа
FormatTime, CurrentDate,, dd.MM


; Проверяем, существует ли лист с таким именем
sheetExists := false
for index, sheet in ComObjEn(wb.Sheets)
{
    if (sheet.Name = CurrentDate)
    {
        sheetExists := true
        break
    }
}

; Запрашиваем номер листа или имя, если необходимо
InputBox, sheetNumberOrName, Выбор листа, Введите номер листа или его имя:, , 200, 100
if ErrorLevel {
    MsgBox, Пользователь отменил ввод.
    xl.Quit()
    return
}

; Определяем, является ли введенное значение числом
isNumber := RegExMatch(sheetNumberOrName, "^\d+$")

; Проверяем, существует ли лист с таким именем или номером
sheetExists := false
if (isNumber) {
    sheetIndex := sheetNumberOrName + 0  ; Преобразуем строку в число
    if (sheetIndex >= 1 && sheetIndex <= wb.Sheets.Count) {
        ws := wb.Sheets(sheetIndex)
        sheetExists := true
    }
} else {
    for index, sheet in ComObjEn(wb.Sheets) {
        if (sheet.Name = sheetNumberOrName) {
            ws := sheet
            sheetExists := true
            break
        }
    }
}

; Если лист не найден, используем лист по умолчанию
if (!sheetExists) {
    MsgBox, Указанный лист не найден. Будет использован первый лист.
    ws := wb.Sheets(1)
}

; Продолжаем с выбранным листом









TotalRows := ws.UsedRange.Rows.Count
Progress := 0

Loop, % TotalRows {
    ; Рассчитываем прогресс в процентах
    ProgressPercentage := (A_Index * 100) / TotalRows
    ; Обновляем значение прогресс-бара
    GuiControl,, MyProgress, %ProgressPercentage%

    ws.Cells(A_Index, 1).Activate

If МедичнийОгляд = 1
{
    IDcellValue := ws.Cells(A_Index, 1).Value  ; № п/п
    ID := SubStr(IDcellValue, 1, 7)
    CellData := ws.Cells(A_Index, 2).Value  ; Прізвище ім’я по-батькові
    Датанародження := ws.Cells(A_Index, 3).Value  ; Число місяць, предполагаем, что это дата
    if (CellData != "") {
        StringSplit, Names, CellData, %A_Space%
        Прізвище := Names1
        StringUpper, Прізвище, Прізвище
        Імя := Names2  ; Предположим, что второй элемент это имя
    }
}


    If База = 1
    {
        IDcellValue := ws.Cells(A_Index, 1).Value
        ID := SubStr(IDcellValue, 1, 7)
        Прізвище := ws.Cells(A_Index, 2).Value
        Імя := ws.Cells(A_Index, 3).Value
        Датанародження := ws.Cells(A_Index, 4).Value
        VisusOD := ws.Cells(A_Index, 5).Value 
        VisusOS := ws.Cells(A_Index, 6).Value 
        ДатаПфОгляду := ws.Cells(A_Index, 7).Value
    }

    If ПсихофізіологІмпорт = 1
    {
        IDcellValue := ws.Cells(A_Index, 4).Value
        ID := SubStr(IDcellValue, 1, 8)
        CellData := ws.Cells(A_Index, 1).Value
        if (CellData != "") {
            StringSplit, Names, CellData, %A_Space%
            Прізвище := Names1
            StringUpper, Прізвище, Прізвище
            Імя := Names2
        }
        Датанародження := ws.Cells(A_Index, 8).Value
        ДатаПфОгляду := ws.Cells(A_Index, 3).Value
    }

    If Список = 1
    {
        IDcellValue := ws.Cells(A_Index, 2).Value
        ID := SubStr(IDcellValue, 1, 7)
        CellData := ws.Cells(A_Index, 3).Value
        Датанародження := ws.Cells(A_Index, 4).Value
        if (CellData != "") {
            StringSplit, Names, CellData, %A_Space%
            Прізвище := Names1
            StringUpper, Прізвище, Прізвище
            Імя := Names2
        }
    }

    If ЗбереженийСписок = 1
    {
        IDcellValue := ws.Cells(A_Index, 1).Value
        ID := SubStr(IDcellValue, 1, 7)
        Прізвище := ws.Cells(A_Index, 2).Value
        Імя := ws.Cells(A_Index, 3).Value
        Датанародження := ws.Cells(A_Index, 4).Value
        VisusOD := ws.Cells(A_Index, 5).Value 
        VisusOS := ws.Cells(A_Index, 6).Value 
        ДатаПфОгляду := ws.Cells(A_Index, 7).Value
    }

    If Призначення = 1
    {
        IDcellValue := ws.Cells(A_Index, 1).Value
        ID := SubStr(IDcellValue, 1, 7)
        CellData := ws.Cells(A_Index, 9).Value
        if (CellData != "") {
            StringSplit, Names, CellData, %A_Space%
            Прізвище := Names1
            StringUpper, Прізвище, Прізвище
            Імя := Names2
        }
    }

    if (Прізвище != "") {
        LV_Add("", ID, Прізвище, Імя, Датанародження, VisusOD, VisusOS, ДатаПфОгляду)
        LV_ModifyCol()
        Progress := A_Index
        GuiControl,, Progress, %Progress%
    }
}

xl.Quit()
xl := ""
wb := ""

GuiControl, MIA:, ЧАСТИНА, %ExcelFilePath%
RowCount := LV_GetCount()
Общее_время_в_секундах := RowCount * 80
Часы := Общее_время_в_секундах // 3600
Минуты := (Общее_время_в_секундах // 60) - (Часы * 60)
Секунды := Общее_время_в_секундах - (Часы * 3600) - (Минуты * 60)
FormatTime, Текущее_время, %A_Now%, HH:mm:ss
Новое_время := (Часы * 3600) + (Минуты * 60) + Секунды
FormatTime, Конечное_время, Новое_время, HH:mm:ss
SB_SetParts(300)
SB_SetText(" " . RowCount . " пацієнтів - знадобиться " . Часы . " ч " . Минуты . " м " . Секунды . " с ", 1)
SB_SetText("Список імпортовано из файла: " . ExcelFilePath . "", 2)

return







ПереміститиНаПоля:


; Получаем количество строк в ListView
; RowCount := LV_GetCount()

; Проверяем количество строк
if (RowCount > 0) {
    ; Если есть строки, выполняем этот блок кода





				; Выделить строку в ListView
				; LV_Modify("Select", SelectedIndex)
 
		;LV_Modify(1, "Select") 							;	этим пожно выбирать только первый элемент в списке без клика по нему
		
		; Получить индекс первой строки ListView
		SelectedIndex := LV_GetNext()

        ; Получить данные из выбранной строки ListView
        LV_GetText(ID, SelectedIndex, 1) 				; 1 - индекс колонки с ID
        LV_GetText(Прізвище, SelectedIndex, 2) 				
        LV_GetText(Імя, SelectedIndex, 3) 					
        LV_GetText(Датанародження, SelectedIndex, 4) 		
        LV_GetText(VisusOD, SelectedIndex, 5) 				
        LV_GetText(VisusOS, SelectedIndex, 6)
		LV_GetText(ДатаПфОгляду, SelectedIndex, 7)
		LV_GetText(Зріст, SelectedIndex, 8) 				
		LV_GetText(Вага, SelectedIndex, 9) 					
		LV_GetText(Тиск, SelectedIndex, 10) 					
		LV_GetText(Температура, SelectedIndex, 11) 			



	; Установить значения в Edit
	GuiControl,MIA:, ID, %ID%
	GuiControl,MIA:, Прізвище, %Прізвище%
	GuiControl,MIA:, Імя, %Імя%
	GuiControl,MIA:, Датанародження, %Датанародження%
	
	
	GuiControl,MIA:, ДатаПфОгляду, %ДатаПфОгляду%
	
	
			Sleep 1000

	VisusODValue := VisusOD
	VisusOSValue := VisusOS

	VisusODValue := StrReplace(VisusODValue, """", "")
	VisusOSValue := StrReplace(VisusOSValue, """", "")


	chooseVisusOD := ChooseVisusOD(VisusODValue)
	chooseVisusOS := ChooseVisusOS(VisusOSValue)


	GuiControl,MIA:Choose, VisusOD, %chooseVisusOD%
	GuiControl,MIA:Choose, VisusOS, %chooseVisusOS%

	GuiControl,MIA:, Зріст, %Зріст%
	GuiControl,MIA:, Вага, %Вага%
	GuiControl,MIA:, Тиск, %Тиск%
	GuiControl,MIA:, Температура, %Температура%

	Sleep 100

        LV_Delete(SelectedIndex)

    
} else {
    ; Если строк нет, выполняем этот блок кода

	
		MsgBox, , ,ГОТОВО (список порожній), 1
		
		SoundBeep, 523, 100 ;ccge
	
		SoundBeep, 523, 100
	
		SoundBeep, 784, 100
		
		SoundBeep, 659, 100
		
		Sleep 100

		Reload
		
		Sleep 100
		
		Send {F1}
		
		Sleep 50
    
	}
	
RowCount := LV_GetCount()
Общее_время_в_секундах := RowCount * 80
Часы := Общее_время_в_секундах // 3600
Минуты := (Общее_время_в_секундах // 60) - (Часы * 60)
Секунды := Общее_время_в_секундах - (Часы * 3600) - (Минуты * 60)

FormatTime, Текущее_время, %A_Now%, HH:mm:ss
Новое_время := (Часы * 3600) + (Минуты * 60) + Секунды
FormatTime, Конечное_время, Новое_время, HH:mm:ss

SB_SetParts(300)
SB_SetText(" " . RowCount . " пацієнтів - знадобиться " . Часы . " ч " . Минуты . " м " . Секунды . " с ", 1)
SB_SetText(Прізвище . " " . Імя . " " . Датанародження " переміщено зі списку на поля", 2)
return




ChooseVisusOD(VisusODValue) {
    ; Функция для определения номера выбора в зависимости от текстового значения
    switch VisusODValue
    {
        case "1.0":
            return 1
        case "0.9":
            return 2
        case "0.8":
            return 3
        case "0.7":
            return 4
        case "0.6":
            return 5
        case "0.5":
            return 6
        case "0.4":
            return 7
        case "0.3":
            return 8
        case "0.2":
            return 9
        case "0.1":
            return 10
        default:
            return 0 ; Вернуть 0 для неизвестных значений
    }
}

ChooseVisusOS(VisusOSValue) {
    ; Функция для определения номера выбора в зависимости от текстового значения
    switch VisusOSValue
    {
        case "1.0":
            return 1
        case "0.9":
            return 2
        case "0.8":
            return 3
        case "0.7":
            return 4
        case "0.6":
            return 5
        case "0.5":
            return 6
        case "0.4":
            return 7
        case "0.3":
            return 8
        case "0.2":
            return 9
        case "0.1":
            return 10
        default:
            return 0 ; Вернуть 0 для неизвестных значений
    }
}



AddToListView:

Gui, MIA:Submit, NoHide ; Получить значения из полей ввода

    GuiControlGet, Прізвище,, Прізвище
	StringUpper, Прізвище, Прізвище
	GuiControl,MIA:, Прізвище, %Прізвище%

    ; Добавить значения в ListView
    LV_Add("", ID, Прізвище, Імя, Датанародження,VisusOD,VisusOS,ДатаПфОгляду,Зріст,Вага,Тиск,Температура)
	LV_ModifyCol()

    ; Очистить поля ввода
	GuiControl,MIA:, ID
    GuiControl,MIA:, Прізвище
    GuiControl,MIA:, Імя
    GuiControl,MIA:, Датанародження
	GuiControl,MIA:, ДатаПфОгляду
	GuiControl,MIA:, Зріст
	GuiControl,MIA:, Вага
	GuiControl,MIA:, Тиск
	GuiControl,MIA:, Температура, 36,6

	GuiControl,MIA:Choose, VisusOD, 1
	GuiControl,MIA:Choose, VisusOS, 1
	

GuiControl, MIA:Focus, Прізвище

RowCount := LV_GetCount()
Общее_время_в_секундах := RowCount * 80
Часы := Общее_время_в_секундах // 3600
Минуты := (Общее_время_в_секундах // 60) - (Часы * 60)
Секунды := Общее_время_в_секундах - (Часы * 3600) - (Минуты * 60)

FormatTime, Текущее_время, %A_Now%, HH:mm:ss
Новое_время := (Часы * 3600) + (Минуты * 60) + Секунды
FormatTime, Конечное_время, Новое_время, HH:mm:ss

SB_SetParts(300)
SB_SetText(" " . RowCount . " пацієнтів - знадобиться " . Часы . " ч " . Минуты . " м " . Секунды . " с ", 1)
SB_SetText(Прізвище . " " . Імя . " " . Датанародження " додано до списку", 2)

gosub ГенеруватиТиск


Return


DeleteAllRows:
LV_Delete()

RowCount := LV_GetCount()
Общее_время_в_секундах := RowCount * 80
Часы := Общее_время_в_секундах // 3600
Минуты := (Общее_время_в_секундах // 60) - (Часы * 60)
Секунды := Общее_время_в_секундах - (Часы * 3600) - (Минуты * 60)

FormatTime, Текущее_время, %A_Now%, HH:mm:ss
Новое_время := (Часы * 3600) + (Минуты * 60) + Секунды
FormatTime, Конечное_время, Новое_время, HH:mm:ss

SB_SetParts(300)
SB_SetText(" " . RowCount . " пацієнтів",1)
SB_SetText("Список очищено", 2)
return

DeleteSelectedRow:
    SelectedIndex := LV_GetNext("", "F")
    if (SelectedIndex) {
        LV_Delete(SelectedIndex)
    }
	
	
	
RowCount := LV_GetCount()
Общее_время_в_секундах := RowCount * 80
Часы := Общее_время_в_секундах // 3600
Минуты := (Общее_время_в_секундах // 60) - (Часы * 60)
Секунды := Общее_время_в_секундах - (Часы * 3600) - (Минуты * 60)

FormatTime, Текущее_время, %A_Now%, HH:mm:ss
Новое_время := (Часы * 3600) + (Минуты * 60) + Секунды
FormatTime, Конечное_время, Новое_время, HH:mm:ss

SB_SetParts(300)
SB_SetText(" " . RowCount . " пацієнтів - знадобиться " . Часы . " ч " . Минуты . " м " . Секунды . " с ", 1)
SB_SetText("Пункт " . SelectedIndex " видалено зі списку",2)

return


KeyPressed(wParam, lParam, msg, hwnd) {
    if (wParam = 0x2E) ; Код клавиши Delete
        SendMessage, 0x111, 46,,, ahk_id %Oft_ListView% ; Отправить команду LV_DELETE для удаления строки
}


Обновить1:
Gui,MIA:Submit,nohide

  if (Діагноз1 = "Здоровий") {

		Ступінь1 := ""
		Око1 := ""
		GuiControl, MIA:Choose, Ступінь1, 0
		GuiControl, MIA:Choose, Око1, 0

		GuiControl, MIA:Hide, Ступінь1  ; Скрыть поле "Ступінь"
		GuiControl, MIA:Hide, Око1

    }

    else if (Діагноз1 = "Міопія" || Діагноз1 = "Гіперметропія" || Діагноз1 = "Простий міопічний астигматизм" || Діагноз1 = "Птеригіум" || Діагноз1 = "Пінгвекула" || Діагноз1 = "Ксантелазми повік" || Діагноз1 = "Астенопія") {
        GuiControl, MIA:Show, Ступінь1  ; Показать поле "Ступінь"
		GuiControl, MIA:Show, Око1

    }


	else {
	Ступінь1 :=
	Око1 :=
        GuiControl, MIA:Hide, Ступінь1  ; Скрыть поле "Ступінь"
		GuiControl, MIA:Hide, Око1

    }

;сравнение, в каком глазу больше значение или отдельно такое правого глаза, такое левого глаза

if (Діагноз1 != "Здоровий") {
    switch (Око1) {
        case "обох очей":
            РефракціяДіагнозу1 := SphOD " дптр правого ока, до " SphOS " дптр лівого ока."
        case "правого ока":
            РефракціяДіагнозу1 := SphOD " дптр " Око1 ""
        case "лівого ока":
            РефракціяДіагнозу1 := SphOS " дптр " Око1 ""
		default:
		РефракціяДіагнозу1 := ""
}
}

if (Діагноз2 != "Здоровий") {
    switch (Око2) {
        case "обох очей":
            РефракціяДіагнозу2 := CylOD " дптр правого ока, до " CylOS " дптр лівого ока."
        case "правого ока":
            РефракціяДіагнозу2 := CylOD " дптр " Око2 ""
        case "лівого ока":
            РефракціяДіагнозу2 := CylOS " дптр " Око2 ""
		default:
		РефракціяДіагнозу2 := ""
}
}


	ПершаСтрокаДіагнозу := (Діагноз1 = "Здоровий") ? "Здоровий" : Діагноз1 " " Ступінь1 " до " РефракціяДіагнозу1
	ДругаСтрокаДіагнозу := (Діагноз2 = "Здоровий") ? "" : "" Діагноз2 " " Ступінь2 " до " РефракціяДіагнозу2

;	ПолеЗаключення :=  ПершаСтрокаДіагнозу "`n" ДругаСтрокаДіагнозу
	GuiControl, MIA:, ПолеЗаключення, %ПолеЗаключення%
	GuiControl, MIA:, ПершаСтрокаДіагнозу, %ПершаСтрокаДіагнозу%
	GuiControl, MIA:, ДругаСтрокаДіагнозу, %ДругаСтрокаДіагнозу%

return


ОбновитьДиагноз1:
Gui,MIA:Submit,nohide



    GuiControl, MIA:Choose, Ступінь1, 1  ; Сбросить выбор "Ступінь" к первому элементу
    GuiControl, MIA:Choose, Око1, 1


	if (Діагноз1 = "Здоровий") {

		Ступінь1 := ""
		Око1 := ""
		GuiControl, MIA:Choose, Ступінь1, 0
		GuiControl, MIA:Choose, Око1, 0

		GuiControl, MIA:Hide, Ступінь1  ; Скрыть поле "Ступінь"
		GuiControl, MIA:Hide, Око1

    }

	else if (Діагноз1 = "Міопія" || Діагноз1 = "Гіперметропія" || Діагноз1 = "Простий міопічний астигматизм" || Діагноз1 = "Птеригіум" || Діагноз1 = "Пінгвекула" || Діагноз1 = "Ксантелазми повік") {
        GuiControl, MIA:Show, Ступінь1  ; Показать поле "Ступінь"
		GuiControl, MIA:Show, Око1

    }

	else {
	Ступінь1 :=
	Око1 :=
        GuiControl, MIA:Hide, Ступінь1  ; Скрыть поле "Ступінь"
		GuiControl, MIA:Hide, Око1

    }

;сравнение, в каком глазу больше значение или отдельно такое правого глаза, такое левого глаза

if (Діагноз1 != "Здоровий") {
    switch (Око1) {
        case "обох очей":
            РефракціяДіагнозу1 := SphOD
        case "правого ока":
            РефракціяДіагнозу1 := SphOD
        case "лівого ока":
            РефракціяДіагнозу1 := SphOS
		default:
		РефракціяДіагнозу1 := ""
}
}

if (Діагноз2 != "Здоровий") {
    switch (Око2) {
        case "обох очей":
            РефракціяДіагнозу2 := CylOD
        case "правого ока":
            РефракціяДіагнозу2 := CylOD
        case "лівого ока":
            РефракціяДіагнозу2 := CylOS
		default:
		РефракціяДіагнозу2 := ""
}
}

	ПершаСтрокаДіагнозу := (Діагноз1 = "Здоровий") ? "Здоровий" : Діагноз1 " " Ступінь1 " до " РефракціяДіагнозу1
	ДругаСтрокаДіагнозу := (Діагноз2 = "Здоровий") ? "" : "" Діагноз2 " " Ступінь2 " до " РефракціяДіагнозу2

;	ПолеЗаключення :=  ПершаСтрокаДіагнозу "`n" ДругаСтрокаДіагнозу
	GuiControl, MIA:, ПолеЗаключення, %ПолеЗаключення%
	GuiControl, MIA:, ПершаСтрокаДіагнозу, %ПершаСтрокаДіагнозу%
	GuiControl, MIA:, ДругаСтрокаДіагнозу, %ДругаСтрокаДіагнозу%
	
return



Обновить2:
Gui,MIA:Submit,nohide



    if (Діагноз2 = "Міопія" || Діагноз2 = "Гіперметропія" || Діагноз2 = "Складний міопічний астигматизм" || Діагноз2 = "Птеригіум" || Діагноз2 = "Пінгвекула" || Діагноз2 = "Ксантелазми повік") {
        GuiControl, MIA:Show, Ступінь2  ; Показать поле "Ступінь"
		GuiControl, MIA:Show, Око2

    }

		else if (Діагноз2 = "Здоровий") {

		Ступінь2 := ""
		Око2 := ""

		GuiControl, MIA:Choose, Ступінь2, 0
		GuiControl, MIA:Choose, Око2, 0

		GuiControl, MIA:Hide, Ступінь2  ; Скрыть поле "Ступінь"
		GuiControl, MIA:Hide, Око2

    }

	else {
	Ступінь2 :=
	Око2 :=
        GuiControl, MIA:Hide, Ступінь2  ; Скрыть поле "Ступінь"
		GuiControl, MIA:Hide, Око2

    }


;сравнение, в каком глазу больше значение или отдельно такое правого глаза, такое левого глаза

if (Діагноз1 != "Здоровий") {
    switch (Око1) {
        case "обох очей":
            РефракціяДіагнозу1 := SphOD
        case "правого ока":
            РефракціяДіагнозу1 := SphOD
        case "лівого ока":
            РефракціяДіагнозу1 := SphOS
		default:
		РефракціяДіагнозу1 := ""
}
}

if (Діагноз2 != "Здоровий") {
    switch (Око2) {
        case "обох очей":
            РефракціяДіагнозу2 := CylOD
        case "правого ока":
            РефракціяДіагнозу2 := CylOD
        case "лівого ока":
            РефракціяДіагнозу2 := CylOS
		default:
		РефракціяДіагнозу2 := ""
}
}

	ПершаСтрокаДіагнозу := (Діагноз1 = "Здоровий") ? "Здоровий" : Діагноз1 " " Ступінь1 " до " РефракціяДіагнозу1
	ДругаСтрокаДіагнозу := (Діагноз2 = "Здоровий") ? "" : "" Діагноз2 " " Ступінь2 " до " РефракціяДіагнозу2

;	ПолеЗаключення :=  ПершаСтрокаДіагнозу "`n" ДругаСтрокаДіагнозу
	GuiControl, MIA:, ПолеЗаключення, %ПолеЗаключення%
	GuiControl, MIA:, ПершаСтрокаДіагнозу, %ПершаСтрокаДіагнозу%
	GuiControl, MIA:, ДругаСтрокаДіагнозу, %ДругаСтрокаДіагнозу%

return



ОбновитьДиагноз2:
Gui,MIA:Submit,nohide



    GuiControl, MIA:Choose, Ступінь2, 1  ; Сбросить выбор "Ступінь" к первому элементу
    GuiControl, MIA:Choose, Око2, 1

if (Діагноз2 = "Здоровий") {

		Ступінь2 := ""
		Око2 := ""

		GuiControl, MIA:Choose, Ступінь2, 0
		GuiControl, MIA:Choose, Око2, 0


		GuiControl, MIA:Hide, Ступінь2  ; Скрыть поле "Ступінь"
		GuiControl, MIA:Hide, Око2

    }

    else if (Діагноз2 = "Міопія" || Діагноз2 = "Гіперметропія" || Діагноз2 = "Складний міопічний астигматизм" || Діагноз2 = "Птеригіум" || Діагноз2 = "Пінгвекула" || Діагноз2 = "Ксантелазми повік") {
        GuiControl, MIA:Show, Ступінь2  ; Показать поле "Ступінь"
		GuiControl, MIA:Show, Око2

    }

	else {
	Ступінь2 :=
	Око2 :=
        GuiControl, MIA:Hide, Ступінь2  ; Скрыть поле "Ступінь"
		GuiControl, MIA:Hide, Око2

    }


;сравнение, в каком глазу больше значение или отдельно такое правого глаза, такое левого глаза

if (Діагноз1 != "Здоровий") {
    switch (Око1) {
        case "обох очей":
            РефракціяДіагнозу1 := SphOD
        case "правого ока":
            РефракціяДіагнозу1 := SphOD
        case "лівого ока":
            РефракціяДіагнозу1 := SphOS
		default:
		РефракціяДіагнозу1 := ""
}
}

if (Діагноз2 != "Здоровий") {
    switch (Око2) {
        case "обох очей":
            РефракціяДіагнозу2 := CylOD
        case "правого ока":
            РефракціяДіагнозу2 := CylOD
        case "лівого ока":
            РефракціяДіагнозу2 := CylOS
		default:
		РефракціяДіагнозу2 := ""
}
}

	ПершаСтрокаДіагнозу := (Діагноз1 = "Здоровий") ? "Здоровий" : Діагноз1 " " Ступінь1 " до " РефракціяДіагнозу1
	ДругаСтрокаДіагнозу := (Діагноз2 = "Здоровий") ? "" : "" Діагноз2 " " Ступінь2 " до " РефракціяДіагнозу2

;	ПолеЗаключення :=  ПершаСтрокаДіагнозу "`n" ДругаСтрокаДіагнозу
	GuiControl, MIA:, ПолеЗаключення, %ПолеЗаключення%
	GuiControl, MIA:, ПершаСтрокаДіагнозу, %ПершаСтрокаДіагнозу%
	GuiControl, MIA:, ДругаСтрокаДіагнозу, %ДругаСтрокаДіагнозу%

return


















ПОЧАТИ:
Gui, MIA:Submit





start1:


If ЧерезЗапис = 1
{
goto АктивнийПрофоглядНеЗнайдено
}











;FormatTime, Датанародження , %FormattedDate%, ddMMyyyy
;Датанародження = %Датанародження%



If Призначення = 1
{
	AppointmentID := ID
	Run, msedge.exe "https://doctor.health.mia.software/appointment/%AppointmentID%/"
	Sleep 10
	goto НеЗявивсяПрофільЗавантажено_Found_LOOP
}
else
{


	Run, msedge.exe "https://doctor.health.mia.software/appointment/appointment-creation-patient-search/"
	Sleep 10
}



If Офтальмолог1 = 1
{






Run, msedge.exe "https://doctor.health.mia.software/appointment/appointment-creation-patient-search/"
	Sleep 10
	
	
}

If Невролог1 = 1
{

Run, msedge.exe "https://doctor.health.mia.software/login/pass/"
	 Sleep 2000


УВІЙТИ_LOOP:
	 Click,534 618 0
	 PixelGetColor,УВІЙТИ,534,618
	 If ( УВІЙТИ = 0xA1AE18 )
	 {
	 Sleep 2000
	 Click,534,618
;	 goto Next1
	 }

	 If ( УВІЙТИ = 0xFFFFFF )
	 {

	 Sleep 500
		Run, msedge.exe "https://doctor.health.mia.software/appointment/appointment-creation-patient-search/"
;		Sleep 500
;		Send ^+{TAB}
;		Sleep 500
;		Send ^w
	 }

	 else
	 {
	 Sleep 1000
	 goto УВІЙТИ_LOOP
	 }

}


Прізвище_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПрізвищеFoundX, ПрізвищеFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\Прізвище.png
	if ErrorLevel = 0
	{
		Sleep 1000
		ПрізвищеFoundXPlus10 := ПрізвищеFoundX + 50
		ПрізвищеFoundYPlus10 := ПрізвищеFoundY + 50
		Click, %ПрізвищеFoundXPlus10%, %ПрізвищеFoundYPlus10%
		Sleep 100
		Send %Прізвище%
		Sleep 100
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Поточне поле: (Прізвище), 930, 1
		goto Прізвище_Found_LOOP
	}

ІмяПоле_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ІмяПолеFoundX, ІмяПолеFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ІмяПоле.png
	if ErrorLevel = 0
	{
		Sleep 100
		ІмяПолеFoundXPlus10 := ІмяПолеFoundX + 50
		ІмяПолеFoundYPlus10 := ІмяПолеFoundY + 50
		Click, %ІмяПолеFoundXPlus10%, %ІмяПолеFoundYPlus10%
		ToolTip
		Sleep 100
		Send %Імя%
		Sleep 100
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Поточне поле: (Імя), 930, 1
		goto ІмяПоле_Found_LOOP
	}

ДатаНародженняПоле_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДатаНародженняПолеFoundX, ДатаНародженняПолеFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ДатаНародженняПоле.png
	if ErrorLevel = 0
	{
		Sleep 100
		ДатаНародженняПолеFoundXPlus10 := ДатаНародженняПолеFoundX + 50
		ДатаНародженняПолеFoundYPlus10 := ДатаНародженняПолеFoundY + 50
		Click, %ДатаНародженняПолеFoundXPlus10%, %ДатаНародженняПолеFoundYPlus10%
		ToolTip
		Sleep 100
		Send %Датанародження%
		Sleep 100
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Дата Народження), 930, 1
		goto ДатаНародженняПоле_Found_LOOP
	}

goto ПропускГалочки

ЧекбоксШукати_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЧекбоксШукатиFoundX, ЧекбоксШукатиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ЧекбоксШукати.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЧекбоксШукатиFoundXPlus10 := ЧекбоксШукатиFoundX + 20
		ЧекбоксШукатиFoundYPlus10 := ЧекбоксШукатиFoundY + 20
		Click, %ЧекбоксШукатиFoundXPlus10%, %ЧекбоксШукатиFoundYPlus10%
		Sleep 500
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Чекбокс Шукати), 930, 1
		goto ЧекбоксШукати_Found_LOOP
	}

Галочка_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ГалочкаFoundX, ГалочкаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Галочка.png
	if ErrorLevel = 0
	{
		Sleep 100
		ГалочкаFoundXPlus10 := ГалочкаFoundX + 10
		ГалочкаFoundYPlus10 := ГалочкаFoundY + 10
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Галочка Є), 930, 1
		goto ЧекбоксШукати_Found_LOOP
	}

ПропускГалочки:

ПОШУК_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПОШУКFoundX, ПОШУКFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПОШУК.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПОШУКFoundXPlus10 := ПОШУКFoundX + 10
		ПОШУКFoundYPlus10 := ПОШУКFoundY + 10
		Click, %ПОШУКFoundXPlus10%, %ПОШУКFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, (ПОШУК) Пацієнта: %Прізвище% %Імя% %Датанародження%, 930, 1
		goto ПОШУК_Found_LOOP
	}



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gТелефон_PAUSE_Button		, Телефон

;Телефон_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto Телефон_Found_LOOP
;return


Телефон_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ТелефонFoundX, ТелефонFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\Телефон.png
	if ErrorLevel = 0
	{
		Sleep 100
		ТелефонFoundXPlus10 := ТелефонFoundX + 1
		ТелефонFoundYPlus10 := ТелефонFoundY + 1
		Click, %ТелефонFoundXPlus10%, %ТелефонFoundYPlus10%
		ToolTip
		Send {PgDn}
		Sleep 100
		Send {PgDn}
		Sleep 1000
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Сторінку завантажено після пошуку (Телефон)), 930, 1
		goto Телефон_Found_LOOP
	}

НеЗнайденоПацієнтів_Found_LOOP: 

	CoordMode, Pixel, Screen 
	ImageSearch, НеЗнайденоПацієнтівFoundX, НеЗнайденоПацієнтівFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\НеЗнайденопацієнтів.png
	if ErrorLevel = 0
	{
		Sleep 100
		НеЗнайденоПацієнтівFoundXPlus10 := НеЗнайденоПацієнтівFoundX + 10
		НеЗнайденоПацієнтівFoundYPlus10 := НеЗнайденоПацієнтівFoundY + 10
		ToolTip
	 		SoundBeep, 660, 100
			Sleep 100
	 		SoundBeep, 660, 100
			Sleep 100
	 		SoundBeep, 523, 100
			Sleep 100
	 	 	SoundBeep, 392, 200

	Msgbox Не знайдено, продовжити?
	Sleep 1000
	
	; Получаем разрешение экрана
	ScreenWidth := 1920
	ScreenHeight := 1080

	; Вычисляем координаты центра экрана
	CenterX := ScreenWidth // 2
	CenterY := ScreenHeight // 2

	; Перемещаем курсор в центр экрана и выполняем клик
	MouseMove, CenterX, CenterY
	Click, CenterX, CenterY
	Sleep 100

	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Не знайдено пацієнтів), 930, 1
		Sleep 100
		ToolTip
	}

ПровестиУргентнийПрийом_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПровестиУргентнийПрийомFoundX, ПровестиУргентнийПрийомFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПровестиУргентнийПрийом.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПровестиУргентнийПрийомFoundXPlus10 := ПровестиУргентнийПрийомFoundX + 20
		ПровестиУргентнийПрийомFoundYPlus10 := ПровестиУргентнийПрийомFoundY + 20
		Click, %ПровестиУргентнийПрийомFoundXPlus10%, %ПровестиУргентнийПрийомFoundYPlus10%
		ToolTip 
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Провести ургентний прийом), 930, 1
		goto ПровестиУргентнийПрийом_Found_LOOP
	}

ПропускПровестиУргентнийПрийом:

НеЗявивсяПрофільЗавантажено_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, НеЗявивсяПрофільЗавантаженоFoundX, НеЗявивсяПрофільЗавантаженоFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\НеЗявивсяПрофільЗавантажено.png
	if ErrorLevel = 0
	{
		Sleep 100
		НеЗявивсяПрофільЗавантаженоFoundXPlus10 := НеЗявивсяПрофільЗавантаженоFoundX + 10
		НеЗявивсяПрофільЗавантаженоFoundYPlus10 := НеЗявивсяПрофільЗавантаженоFoundY + 10
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Деталі прийому), 930, 1
		goto НеЗявивсяПрофільЗавантажено_Found_LOOP
	}


ЕпізодиЗавантажити_Found_LOOP: 

If ДивитисьДіагнози = 1
{

goto ЕпізодиЗіЗначком_Found_LOOP

		Sleep 10
		Send {PgDn}
		Sleep 10
		Send {PgDn}
		Sleep 10
		Send {PgDn}
		Sleep 10


ІсторіяЗначок_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ІсторіяЗначокFoundX, ІсторіяЗначокFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ІсторіяЗначок.png
	if ErrorLevel = 0
	{
		Sleep 500
		ІсторіяЗначокFoundXPlus10 := ІсторіяЗначокFoundX + 10
		ІсторіяЗначокFoundYPlus10 := ІсторіяЗначокFoundY + 10
		Click, %ІсторіяЗначокFoundXPlus10%, %ІсторіяЗначокFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Історія Значок), 930, 1
		goto ІсторіяЗначок_Found_LOOP
	}

goto goafterhistory

;	Gui, PAUSE:Add, Button, xs w200 h40 Center gЕпізодиЗіЗначком_PAUSE_Button		, ЕпізодиЗіЗначком

;ЕпізодиЗіЗначком_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ЕпізодиЗіЗначком_Found_LOOP
;return

ЕпізодиЗіЗначком_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЕпізодиЗіЗначкомFoundX, ЕпізодиЗіЗначкомFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ЕпізодиЗіЗначком.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЕпізодиЗіЗначкомFoundXPlus10 := ЕпізодиЗіЗначкомFoundX + 10
		ЕпізодиЗіЗначкомFoundYPlus10 := ЕпізодиЗіЗначкомFoundY + 10
		Click, %ЕпізодиЗіЗначкомFoundXPlus10%, %ЕпізодиЗіЗначкомFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Епізоди Зі Значком), 930, 1
		goto ЕпізодиЗіЗначком_Found_LOOP
	}

		Sleep 100
		Send {PgDn}
		Sleep 100
		Send {PgDn}
		Sleep 100




	CoordMode, Pixel, Screen 
	ImageSearch, ЕпізодиЗавантажитиFoundX, ЕпізодиЗавантажитиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ЕпізодиЗавантажити.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЕпізодиЗавантажитиFoundYPlus10 := ЕпізодиЗавантажитиFoundY + 10
		Click, %ЕпізодиЗавантажитиFoundXPlus10%, %ЕпізодиЗавантажитиFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Епізоди Завантажити), 930, 1
		goto ЕпізодиЗавантажити_Found_LOOP
	}

}


НаВесьЭкран1_Found_LOOP: 

If ДивитисьДіагнози = 1
{


	CoordMode, Pixel, Screen 
	ImageSearch, НаВесьЭкран1FoundX, НаВесьЭкран1FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\НаВесьЭкран1.png
	if ErrorLevel = 0
	{
		Sleep 500
		НаВесьЭкран1FoundXPlus10 := НаВесьЭкран1FoundX + 10
		НаВесьЭкран1FoundYPlus10 := НаВесьЭкран1FoundY + 10
		Click, %НаВесьЭкран1FoundXPlus10%, %НаВесьЭкран1FoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (На Весь Экран 1), 930, 1
		goto НаВесьЭкран1_Found_LOOP
	}

}


goafterhistory:

If ДивитисьДіагнози = 1
{

SoundBeep, 523
Sleep 100
SoundBeep, 392
SoundBeep, 440
SoundBeep, 523

MsgBox, 4,, Продовжити?
IfMsgBox Yes
{
Sleep 1000

; Разрешение экрана Full HD (1920x1080)
ScreenWidth := 1920
ScreenHeight := 1080

; Вычисляем координаты центра экрана
CenterX := ScreenWidth // 2
CenterY := ScreenHeight // 2

; Перемещаем курсор в центр экрана и выполняем клик
MouseMove, CenterX, CenterY
Click, CenterX, CenterY




		SoundBeep, 392
		SoundBeep, 523
		Sleep 100
		Send {PgUp}
		Sleep 10
		Send {PgUp}
		Sleep 10
		Send {PgUp}
		Sleep 10


;goto ПочатиПрийом_Found_LOOP

    goto next

}
else
	Sleep 1000
	goto start
	
	;бар пропущений через наявність діагнозу

next:

		Sleep 500
		Send {PgDn}
		Sleep 500
		Send {PgDn}
		Sleep 500

}

НаВесьЕкран2_Found_LOOP: 

If ДивитисьДіагнози = 1
{


	CoordMode, Pixel, Screen 
	ImageSearch, НаВесьЕкран2FoundX, НаВесьЕкран2FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\НаВесьЕкран2.png
	if ErrorLevel = 0
	{
		Sleep 500
		НаВесьЕкран2FoundXPlus10 := НаВесьЕкран2FoundX + 10
		НаВесьЕкран2FoundYPlus10 := НаВесьЕкран2FoundY + 10
		Click, %НаВесьЕкран2FoundXPlus10%, %НаВесьЕкран2FoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (На Весь Екран 2), 930, 1
		goto НаВесьЕкран2_Found_LOOP
	}


		Sleep 100
		Send {PgUp}
		Sleep 100
		Send {PgUp}
		Sleep 100
		Send {PgUp}
		Sleep 2000

}


ПочатиПрийом_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПочатиПрийомFoundX, ПочатиПрийомFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПочатиПрийом.png
	if ErrorLevel = 0
	{
		Sleep 1000
		ПочатиПрийомFoundXPlus10 := ПочатиПрийомFoundX + 20
		ПочатиПрийомFoundYPlus10 := ПочатиПрийомFoundY + 20
		Click, %ПочатиПрийомFoundXPlus10%, %ПочатиПрийомFoundYPlus10%
		Sleep 100
;		Click, %ПочатиПрийомFoundXPlus10%, %ПочатиПрийомFoundYPlus10%
;		Sleep 100
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (ПОЧАТИ ПРИЙОМ), 930, 1
		goto ПочатиПрийом_Found_LOOP
	}



Шаблон:

If Психофізіолог = 1
{
goto Епізоди_Found_LOOP
}

SelectedШаблон := ШаблонChoice

if (SelectedШаблон = "Профогляд Офт.")
{
goto ПрофоглядОфтальмолога_Found_LOOP
}
else if (SelectedШаблон = "ВЛК Офт.")
{
goto ПрийомОфтВЛК_Found_LOOP
}
else if (SelectedШаблон = "Прийом Невролога")
{
goto ПрийомНевролога_Found_LOOP
}
else if (SelectedШаблон = "ВЛК Невролога")
{
;goto ШаблонВЛК
}


ПрофоглядОфтальмолога_Found_LOOP: 

If Офтальмолог = 1
{

	CoordMode, Pixel, Screen 
	ImageSearch, ПрофоглядОфтальмологаFoundX, ПрофоглядОфтальмологаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПрофоглядОфтальмолога.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПрофоглядОфтальмологаFoundXPlus10 := ПрофоглядОфтальмологаFoundX + 50
		ПрофоглядОфтальмологаFoundYPlus10 := ПрофоглядОфтальмологаFoundY + 10
		Click, %ПрофоглядОфтальмологаFoundXPlus10%, %ПрофоглядОфтальмологаFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Профогляд Офтальмолога), 930, 1
		goto ПрофоглядОфтальмолога_Found_LOOP
	}

}

ПрийомОфтВЛК_Found_LOOP: 

If Офтальмолог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, ПрийомОфтВЛКFoundX, ПрийомОфтВЛКFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПрийомОфтВЛК.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПрийомОфтВЛКFoundXPlus10 := ПрийомОфтВЛКFoundX + 30
		ПрийомОфтВЛКFoundYPlus10 := ПрийомОфтВЛКFoundY + 30
		Click, %ПрийомОфтВЛКFoundXPlus10%, %ПрийомОфтВЛКFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Прийом лікаря-офтальмолога ((ВЛК)), 930, 1
		goto ПрийомОфтВЛК_Found_LOOP
	}
}

ПрийомНевролога_Found_LOOP: 
If Невролог = 1
{

	CoordMode, Pixel, Screen 
	ImageSearch, ПрийомНеврологаFoundX, ПрийомНеврологаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПрийомНевролога.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПрийомНеврологаFoundXPlus10 := ПрийомНеврологаFoundX + 50
		ПрийомНеврологаFoundYPlus10 := ПрийомНеврологаFoundY + 10
		Click, %ПрийомНеврологаFoundXPlus10%, %ПрийомНеврологаFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Профогляд лікаря-Невролога), 930, 1
		goto ПрийомНевролога_Found_LOOP
	}

}




ПрийомЛікаряТерапевта_Found_LOOP: 
If Терапевт = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, ПрийомЛікаряТерапевтаFoundX, ПрийомЛікаряТерапевтаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПрийомЛікаряТерапевта.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПрийомЛікаряТерапевтаFoundXPlus10 := ПрийомЛікаряТерапевтаFoundX + 50
		ПрийомЛікаряТерапевтаFoundYPlus10 := ПрийомЛікаряТерапевтаFoundY + 10
		Click, %ПрийомЛікаряТерапевтаFoundXPlus10%, %ПрийомЛікаряТерапевтаFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Прийом Лікаря-Терапевта), 930, 1
		goto ПрийомЛікаряТерапевта_Found_LOOP
	}
}



Епізоди_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЕпізодиFoundX, ЕпізодиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Епізоди.png
	if ErrorLevel = 0
	{
		Sleep 1000
		ЕпізодиFoundXPlus10 := ЕпізодиFoundX + 10
		ЕпізодиFoundYPlus10 := ЕпізодиFoundY + 10
		Click, %ЕпізодиFoundXPlus10%, %ЕпізодиFoundYPlus10%
		Sleep 100
		Click, %ЕпізодиFoundXPlus10%, %ЕпізодиFoundYPlus10%
		Sleep 100
		Click, %ЕпізодиFoundXPlus10%, %ЕпізодиFoundYPlus10%
		Sleep 100
		Click, %ЕпізодиFoundXPlus10%, %ЕпізодиFoundYPlus10%
		Sleep 100
		ToolTip
		goto ЕпізодиЗавантажено_Found_LOOP
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Епізоди), 930, 1
		goto Епізоди2_Found_LOOP
	}



Епізоди2_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, Епізоди2FoundX, Епізоди2FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Епізоди2.png
	if ErrorLevel = 0
	{
		Sleep 100
		Епізоди2FoundXPlus10 := Епізоди2FoundX + 10
		Епізоди2FoundYPlus10 := Епізоди2FoundY + 10
		Click, %Епізоди2FoundXPlus10%, %Епізоди2FoundYPlus10%
		Sleep 100
		Click, %Епізоди2FoundXPlus10%, %Епізоди2FoundYPlus10%
		Sleep 100
		ToolTip
		goto ЕпізодиЗавантажено_Found_LOOP
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Епізоди), 930, 1
		goto Епізоди_Found_LOOP
	}



ЕпізодиЗавантажено_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЕпізодиЗавантаженоFoundX, ЕпізодиЗавантаженоFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ЕпізодиЗавантажено.png
	if ErrorLevel = 0
	{
		Sleep 100
		ЕпізодиЗавантаженоFoundXPlus10 := ЕпізодиЗавантаженоFoundX + 10
		ЕпізодиЗавантаженоFoundYPlus10 := ЕпізодиЗавантаженоFoundY + 10
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Епізоди завантажено), 930, 1
		Click, %ЕпізодиFoundXPlus10%, %ЕпізодиFoundYPlus10%
		Sleep 100
		Click, %Епізоди2FoundXPlus10%, %Епізоди2FoundYPlus10%
		Sleep 1000
		goto ЕпізодиЗавантажено_Found_LOOP
	}



ДодатиЄпізод_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДодатиЄпізодFoundX, ДодатиЄпізодFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ДодатиЄпізод.png
	if ErrorLevel = 0
	{
		Sleep 100
		ДодатиЄпізодFoundXPlus10 := ДодатиЄпізодFoundX + 20
		ДодатиЄпізодFoundYPlus10 := ДодатиЄпізодFoundY + 20
		Click, %ДодатиЄпізодFoundXPlus10%, %ДодатиЄпізодFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Додати Єпізод), 930, 1
		goto ДодатиЄпізод_Found_LOOP
	}



													;Епізоди



; Инициализация счетчика
LoopCount := 0

ТипЕпізоду_Found_LOOP: 
    CoordMode, Pixel, Screen 
    ImageSearch, ТипЕпізодуFoundX, ТипЕпізодуFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ТипЕпізоду.png
    if ErrorLevel = 0
    {
        Sleep 1000
        ТипЕпізодуFoundXPlus10 := ТипЕпізодуFoundX + 10
        ТипЕпізодуFoundYPlus10 := ТипЕпізодуFoundY + 10
        Click, %ТипЕпізодуFoundXPlus10%, %ТипЕпізодуFoundYPlus10%
		Sleep 500
        ToolTip
    }
    else
    {
        ; Увеличиваем счетчик на 1
        LoopCount := LoopCount + 1
        
        ; Если счетчик достиг 10 итераций, нажимаем F5 и сбрасываем счетчик
        if (LoopCount >= 10)
        {
   ;         Send, {F5}
            LoopCount := 0 ; Сбрасываем счетчик
        }
        else
        {
            Sleep 1000
            CoordMode, ToolTip, Screen
            ToolTip, Чекаю появу: (Тип Епізоду), 930, 1
            goto ТипЕпізоду_Found_LOOP
        }
    }





Профілактика_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПрофілактикаFoundX, ПрофілактикаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПрофілактикаОфтальмолог.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПрофілактикаFoundXPlus10 := ПрофілактикаFoundX + 10
		ПрофілактикаFoundYPlus10 := ПрофілактикаFoundY + 10
		Click, %ПрофілактикаFoundXPlus10%, %ПрофілактикаFoundYPlus10%
		Sleep 500
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Профілактика), 930, 1
		goto Профілактика_Found_LOOP
	}


goto ПропускПриорітета

Приорітет_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПриорітетFoundX, ПриорітетFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Приорітет.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПриорітетFoundXPlus10 := ПриорітетFoundX + 300
		ПриорітетFoundYPlus10 := ПриорітетFoundY + 10
		Click, %ПриорітетFoundXPlus10%, %ПриорітетFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Приорітет), 930, 1
		goto Приорітет_Found_LOOP
	}





Плановий_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПлановийFoundX, ПлановийFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Плановий.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПлановийFoundXPlus10 := ПлановийFoundX + 10
		ПлановийFoundYPlus10 := ПлановийFoundY + 10
		Click, %ПлановийFoundXPlus10%, %ПлановийFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Плановий), 930, 1
		goto Плановий_Found_LOOP
	}

ПропускПриорітета:

Sleep 500
Send {PgDn}
Sleep 2000



ДіагнозиДодати_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДіагнозиДодатиFoundX, ДіагнозиДодатиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ДіагнозиДодати.png
	if ErrorLevel = 0
	{
		Sleep 100
		ДіагнозиДодатиFoundXPlus10 := ДіагнозиДодатиFoundX + 1100
		ДіагнозиДодатиFoundYPlus10 := ДіагнозиДодатиFoundY + 10
		Click, %ДіагнозиДодатиFoundXPlus10%, %ДіагнозиДодатиFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Діагнози: ДОДАТИ), 930, 1
		goto ДіагнозиДодати_Found_LOOP
	}



ДіагнозНовий_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДіагнозНовийFoundX, ДіагнозНовийFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ДіагнозНовий.png
	if ErrorLevel = 0
	{
		Sleep 100
		ДіагнозНовийFoundXPlus10 := ДіагнозНовийFoundX + 30
		ДіагнозНовийFoundYPlus10 := ДіагнозНовийFoundY + 30
		Click, %ДіагнозНовийFoundXPlus10%, %ДіагнозНовийFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Діагноз: НОВИЙ), 930, 1
		goto ДіагнозНовий_Found_LOOP
	}




													; Діагнози




ДіагнозОберітьЗіСписку_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДіагнозОберітьЗіСпискуFoundX, ДіагнозОберітьЗіСпискуFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ДіагнозОберітьЗіСписку.png
	if ErrorLevel = 0
	{
		Sleep 100
		ДіагнозОберітьЗіСпискуFoundXPlus10 := ДіагнозОберітьЗіСпискуFoundX + 200
		ДіагнозОберітьЗіСпискуFoundYPlus10 := ДіагнозОберітьЗіСпискуFoundY + 20
		Click, %ДіагнозОберітьЗіСпискуFoundXPlus10%, %ДіагнозОберітьЗіСпискуFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Діагноз: Оберіть зі списку), 930, 1
		goto ДіагнозОберітьЗіСписку_Found_LOOP
	}


if (Діагноз1 != "Здоровий") {
    switch (Око1) {
        case "обох очей":
            ОКО := "OU"
        case "правого ока":
            ОКО := "OD"
        case "лівого ока":
            ОКО := "OS"
		default:
		ОКО := ""
}
}


switch (Діагноз1) {
    case "Здоровий":
        ДіагнозДляМіа := "Загальний медичний огляд"
		Send %ДіагнозДляМіа%
		
		КоментарДоДіагнозу := ""

	ЗагальнийМедичнийОглядFound_LOOP:
	 CoordMode, Pixel, Screen
	 ImageSearch, ЗагальнийМедичнийОглядFoundX, ЗагальнийМедичнийОглядFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Діагнози\Діагноз_ЗагальнийМедичнийОгляд.png
	 if ErrorLevel = 0
	 {
		 Sleep 1000
		 ЗагальнийМедичнийОглядFoundXPlus10 := ЗагальнийМедичнийОглядFoundX + 10
		 ЗагальнийМедичнийОглядFoundYPlus10 := ЗагальнийМедичнийОглядFoundY + 10
		 Click, %ЗагальнийМедичнийОглядFoundXPlus10%, %ЗагальнийМедичнийОглядFoundYPlus10%
		 Sleep 100
		 ;Msgbox, Діагноз вірний?
	 }
	 else
	 {
	 	 Sleep 100
		 goto ЗагальнийМедичнийОглядFound_LOOP
	 }


    case "Міопія":
        ДіагнозДляМіа := "Міопія"
		Send %ДіагнозДляМіа%
		
		КоментарДоДіагнозу := ОКО
		

		МіопіяFound_LOOP:
		 CoordMode, Pixel, Screen
		 ImageSearch, МіопіяFoundX, МіопіяFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Діагнози\Діагноз_Міопія.png
		 if ErrorLevel = 0
		 {
			Sleep 1000
			МіопіяFoundXPlus10 := МіопіяFoundX + 10
			МіопіяFoundYPlus10 := МіопіяFoundY + 10
			Click, %МіопіяFoundXPlus10%, %МіопіяFoundYPlus10%
			;Msgbox, Діагноз вірний?
		 }
		 else
		 {
			 Sleep 100
			 goto МіопіяFound_LOOP
		 }


    case "Гіперметропія":
        ДіагнозДляМіа := "Гіперметропія"
		Send %ДіагнозДляМіа%
		
		КоментарДоДіагнозу := ОКО

		Діагноз_ГіперметропіяFound_LOOP:

		CoordMode, Pixel, Screen
		 ImageSearch, Діагноз_ГіперметропіяFoundX, Діагноз_ГіперметропіяFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Діагнози\Діагноз_Гіперметропія.png
		 if ErrorLevel = 0
		 {
		 	 Sleep 1000
			 Діагноз_ГіперметропіяFoundXPlus10 := Діагноз_ГіперметропіяFoundX + 10
			 Діагноз_ГіперметропіяFoundYPlus10 := Діагноз_ГіперметропіяFoundY + 10
			 Click, %Діагноз_ГіперметропіяFoundXPlus10%, %Діагноз_ГіперметропіяFoundYPlus10%
			 Sleep 100
			 ;Msgbox, Діагноз вірний?
		 }
		 else
		 {
			 Sleep 100
			 goto Діагноз_ГіперметропіяFound_LOOP
		 }


    case "Простий міопічний астигматизм":
        ДіагнозДляМіа := "Астигматизм"
		Send %ДіагнозДляМіа%
			
		КоментарДоДіагнозу := ОКО

		Діагноз_АстигматизмFound_LOOP:
		 CoordMode, Pixel, Screen
		 ImageSearch, Діагноз_АстигматизмFoundX, Діагноз_АстигматизмFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Діагнози\Діагноз_Астигматизм.png
		 if ErrorLevel = 0
		 {
			 Sleep 1000
			 Діагноз_АстигматизмFoundXPlus10 := Діагноз_АстигматизмFoundX + 10
			 Діагноз_АстигматизмFoundYPlus10 := Діагноз_АстигматизмFoundY + 10
			 Click, %Діагноз_АстигматизмFoundXPlus10%, %Діагноз_АстигматизмFoundYPlus10%
			 Sleep 100
			 ;Msgbox, Діагноз вірний?
		 }
		 else
		 {
			 Sleep 100
			 goto Діагноз_АстигматизмFound_LOOP
		 }





    case "Астенопія":
        ДіагнозДляМіа := "єктивні розлади зору"
		Send %ДіагнозДляМіа%

		КоментарДоДіагнозу := "Астенопія"

					Діагноз_СпазмАкомодаціїFound_LOOP:
		 CoordMode, Pixel, Screen
		 ImageSearch, Діагноз_СпазмАкомодаціїFoundX, Діагноз_СпазмАкомодаціїFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Діагнози\Діагноз_СпазмАкомодації.png
		 if ErrorLevel = 0
		 {
			 Sleep 1000
			 Діагноз_СпазмАкомодаціїFoundXPlus10 := Діагноз_СпазмАкомодаціїFoundX + 10
			 Діагноз_СпазмАкомодаціїFoundYPlus10 := Діагноз_СпазмАкомодаціїFoundY + 10
			 Click, %Діагноз_СпазмАкомодаціїFoundXPlus10%, %Діагноз_СпазмАкомодаціїFoundYPlus10%
			 Sleep 100
			 ;Msgbox, Діагноз вірний?
		 }
		 else
		 {
			Sleep 100
			goto Діагноз_СпазмАкомодаціїFound_LOOP
		 }


    case "Пінгвекула":
        ДіагнозДляМіа := "юнктивальні переродження та відкладення"
			Send %ДіагнозДляМіа%
			
		КоментарДоДіагнозу := "Пінгвекула " . ОКО

		Діагноз_ПінгвекулаFound_LOOP:
		 CoordMode, Pixel, Screen
		 ImageSearch, Діагноз_ПінгвекулаFoundX, Діагноз_ПінгвекулаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Діагнози\Діагноз_Пінгвекула.png
		 if ErrorLevel = 0
		 {
			 Sleep 1000
			 Діагноз_ПінгвекулаFoundXPlus10 := Діагноз_ПінгвекулаFoundX + 10
			 Діагноз_ПінгвекулаFoundYPlus10 := Діагноз_ПінгвекулаFoundY + 10
			 Click, %Діагноз_ПінгвекулаFoundXPlus10%, %Діагноз_ПінгвекулаFoundYPlus10%
			 Sleep 100
			 ;Msgbox, Діагноз вірний?
		 }
		 else
		 {
			 Sleep 100
			 goto Діагноз_ПінгвекулаFound_LOOP
		 }



	case "Птеригіум":
       ДіагнозДляМіа := "Птеригій"
			Send %ДіагнозДляМіа%
			
		КоментарДоДіагнозу := ОКО

		Діагноз_ПтеригійFound_LOOP:
		 CoordMode, Pixel, Screen
		 ImageSearch, Діагноз_ПтеригійFoundX, Діагноз_ПтеригійFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Діагнози\Діагноз_Птеригій.png
		 if ErrorLevel = 0
		 {
			 Sleep 1000
			 Діагноз_ПтеригійFoundXPlus10 := Діагноз_ПтеригійFoundX + 10
			 Діагноз_ПтеригійFoundYPlus10 := Діагноз_ПтеригійFoundY + 10
			 Click, %Діагноз_ПтеригійFoundXPlus10%, %Діагноз_ПтеригійFoundYPlus10%
			 Sleep 100
			 ;Msgbox, Діагноз вірний?
		 }
		 else
		 {
			 Sleep 100
			 goto Діагноз_ПтеригійFound_LOOP
		 }


    case "Ксантелазми повік":
        ДіагнозДляМіа := "ксантелазма повіки"
			Send %ДіагнозДляМіа%
			
		КоментарДоДіагнозу := ОКО


		 Діагноз_КсантелазмиПовікFound_LOOP:
		 CoordMode, Pixel, Screen
		 ImageSearch, Діагноз_КсантелазмиПовікFoundX, Діагноз_КсантелазмиПовікFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 G:\Мой диск\Медико Санітарна Частина\MIA Automation\MIA\Діагнози\Діагноз_КсантелазмиПовік.png
		 if ErrorLevel = 0
		 {
			 Sleep 1000
			 Діагноз_КсантелазмиПовікFoundXPlus10 := Діагноз_КсантелазмиПовікFoundX + 10
			 Діагноз_КсантелазмиПовікFoundYPlus10 := Діагноз_КсантелазмиПовікFoundY + 10
			 Click, %Діагноз_КсантелазмиПовікFoundXPlus10%, %Діагноз_КсантелазмиПовікFoundYPlus10%
			 Sleep 100
			 ;Msgbox, Діагноз вірний?
		 }
		 else
		 {
			 Sleep 100
			 goto Діагноз_КсантелазмиПовікFound_LOOP
		 }




	case "Рогівкова дуга":
        ДіагнозДляМіа := "Дегенерація рогівки"
			Send %ДіагнозДляМіа%
			
		КоментарДоДіагнозу := "Arcus senilis corneae (Рогівкова дуга)"

		 Діагнози_РогівковаДугаFound_LOOP: 
		 CoordMode, Pixel, Screen 
		 ImageSearch, Діагнози_РогівковаДугаFoundX, Діагнози_РогівковаДугаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 G:\Мой диск\Медико Санітарна Частина\MIA Automation\MIA\Діагнози\Діагнози_РогівковаДуга.png 
		 if ErrorLevel = 0 
		 { 
			 Sleep 1000 
			 Діагнози_РогівковаДугаFoundXPlus10 := Діагнози_РогівковаДугаFoundX + 10 
			 Діагнози_РогівковаДугаFoundYPlus10 := Діагнози_РогівковаДугаFoundY + 10 
			 Click, %Діагнози_РогівковаДугаFoundXPlus10%, %Діагнози_РогівковаДугаFoundYPlus10% 
			 Sleep 100
			 ;Msgbox, Діагноз вірний?
		 } 
		 else 
		 { 
			 Sleep 100 
			 goto Діагнози_РогівковаДугаFound_LOOP 
		 } 


    default:
       ДіагнозДляМіа := "Загальний медичний огляд"
			Send %ДіагнозДляМіа%




}


		Sleep 100

if (Діагноз1 != "Здоровий") {

	СтупіньТяжкості_LOOP:
	 Click,1251 366 0
	 PixelGetColor,СтупіньТяжкості,1251,366
	 If ( СтупіньТяжкості = 0xFFFFFF )
	 {
	 Sleep 500
	 Click,1251,366
	 }
	 else
	 {
	 Sleep 500
	 goto СтупіньТяжкості_LOOP
	 }

Switch, Ступінь1 {
    Case "слабкого ступеню":

	СтупіньТяжкості_ЛегкийFound_LOOP:
	CoordMode, Pixel, Screen
	 ImageSearch, СтупіньТяжкості_ЛегкийFoundX, СтупіньТяжкості_ЛегкийFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Ступені тяжкості\СтупіньТяжкості_Легкий.png
	 if ErrorLevel = 0
	 {
			Sleep 100
		 СтупіньТяжкості_ЛегкийFoundXPlus10 := СтупіньТяжкості_ЛегкийFoundX + 10
		 СтупіньТяжкості_ЛегкийFoundYPlus10 := СтупіньТяжкості_ЛегкийFoundY + 10
		 Click, %СтупіньТяжкості_ЛегкийFoundXPlus10%, %СтупіньТяжкості_ЛегкийFoundYPlus10%
	 }
	 else
	 {
	 	 Sleep 100
		 goto СтупіньТяжкості_ЛегкийFound_LOOP
	 }
    Case "середнього ступеню":

	СтупіньТяжкості_СередньоїВажкостіFound_LOOP:
	CoordMode, Pixel, Screen
	 ImageSearch, СтупіньТяжкості_СередньоїВажкостіFoundX, СтупіньТяжкості_СередньоїВажкостіFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Ступені тяжкості\СтупіньТяжкості_СередньоїВажкості.png
	 if ErrorLevel = 0
	 {
		Sleep 100
		 СтупіньТяжкості_СередньоїВажкостіFoundXPlus10 := СтупіньТяжкості_СередньоїВажкостіFoundX + 10
		 СтупіньТяжкості_СередньоїВажкостіFoundYPlus10 := СтупіньТяжкості_СередньоїВажкостіFoundY + 10
		 Click, %СтупіньТяжкості_СередньоїВажкостіFoundXPlus10%, %СтупіньТяжкості_СередньоїВажкостіFoundYPlus10%
	 }
	 else
	 {
	 	 Sleep 100
		 goto СтупіньТяжкості_СередньоїВажкостіFound_LOOP
	 }
    Case "високого ступеню":

	СтупіньТяжкості_ВажкийFound_LOOP:
	CoordMode, Pixel, Screen
	 ImageSearch, СтупіньТяжкості_ВажкийFoundX, СтупіньТяжкості_ВажкийFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Ступені тяжкості\СтупіньТяжкості_Важкий.png
	 if ErrorLevel = 0
	 {
		Sleep 100
		 СтупіньТяжкості_ВажкийFoundXPlus10 := СтупіньТяжкості_ВажкийFoundX + 10
		 СтупіньТяжкості_ВажкийFoundYPlus10 := СтупіньТяжкості_ВажкийFoundY + 10
		 Click, %СтупіньТяжкості_ВажкийFoundXPlus10%, %СтупіньТяжкості_ВажкийFoundYPlus10%
	 }
	 else
	 {
	 	 Sleep 100
		 goto СтупіньТяжкості_ВажкийFound_LOOP
	 }


    Default:

}


}


КоментарДоДіагнозу_Found_LOOP: 

if (ПершаСтрокаДіагнозу = "") 
{
goto ЗБЕРЕГТИ_Found_LOOP
}
else
{
	CoordMode, Pixel, Screen 
	ImageSearch, КоментарДоДіагнозуFoundX, КоментарДоДіагнозуFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\КоментарДоДіагнозу.png
	if ErrorLevel = 0
	{
		Sleep 100
		КоментарДоДіагнозуFoundXPlus10 := КоментарДоДіагнозуFoundX + 200
		КоментарДоДіагнозуFoundYPlus10 := КоментарДоДіагнозуFoundY + 10
		Click, %КоментарДоДіагнозуFoundXPlus10%, %КоментарДоДіагнозуFoundYPlus10%
		ToolTip
			Sleep 100
			Send %ПершаСтрокаДіагнозу%
			Sleep 100
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Коментар до діагнозу), 930, 1
		goto КоментарДоДіагнозу_Found_LOOP
	}
}


ЗБЕРЕГТИ_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЗБЕРЕГТИFoundX, ЗБЕРЕГТИFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ЗБЕРЕГТИ.png
	if ErrorLevel = 0
	{
		Sleep 100
		ЗБЕРЕГТИFoundXPlus10 := ЗБЕРЕГТИFoundX + 10
		ЗБЕРЕГТИFoundYPlus10 := ЗБЕРЕГТИFoundY + 10
		Click, %ЗБЕРЕГТИFoundXPlus10%, %ЗБЕРЕГТИFoundYPlus10%
		ToolTip
		Sleep 100
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (ЗБЕРЕГТИ), 930, 1
		goto ЗБЕРЕГТИ_Found_LOOP
	}

ОСНОВНИЙ_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ОСНОВНИЙFoundX, ОСНОВНИЙFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ОСНОВНИЙ.png
	if ErrorLevel = 0
	{
		Sleep 100
		ОСНОВНИЙFoundXPlus10 := ОСНОВНИЙFoundX + 10
		ОСНОВНИЙFoundYPlus10 := ОСНОВНИЙFoundY + 10
		Click, %ОСНОВНИЙFoundXPlus10%, %ОСНОВНИЙFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (ОСНОВНИЙ (Основний Діагноз додано.), 930, 1
		goto ОСНОВНИЙ_Found_LOOP
	}


Sleep 100
if (СупутнійCheckBox = 1) {
Clipboard := ДругаСтрокаДіагнозу
SoundBeep, 800
SoundBeep, 800


Msgbox Введіть другий діагноз, та натисніть "ОК"
}





ПричиниЗверненняІСРС2_Found_LOOP: 

If ПричиниЗвернення = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, ПричиниЗверненняІСРС2FoundX, ПричиниЗверненняІСРС2FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПричиниЗверненняІСРС-2.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПричиниЗверненняІСРС2FoundXPlus10 := ПричиниЗверненняІСРС2FoundX + 1100
		ПричиниЗверненняІСРС2FoundYPlus10 := ПричиниЗверненняІСРС2FoundY + 10
		Click, %ПричиниЗверненняІСРС2FoundXPlus10%, %ПричиниЗверненняІСРС2FoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Причини звернення (згідно з ІСРС-2) (ДОДАТИ), 930, 1
		goto ПричиниЗверненняІСРС2_Found_LOOP
	}
}
else

{
MsgBox
}

;	Gui, PAUSE:Add, Button, xs w200 h40 Center gПричинаЗверненняПОЛЕ_PAUSE_Button		, ПричинаЗверненняПОЛЕ

;ПричинаЗверненняПОЛЕ_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ПричинаЗверненняПОЛЕ_Found_LOOP
;return

ПричинаЗверненняПОЛЕ_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПричинаЗверненняПОЛЕFoundX, ПричинаЗверненняПОЛЕFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ПричинаЗверненняПОЛЕ.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПричинаЗверненняПОЛЕFoundXPlus10 := ПричинаЗверненняПОЛЕFoundX + 700
		ПричинаЗверненняПОЛЕFoundYPlus10 := ПричинаЗверненняПОЛЕFoundY + 10
		Click, %ПричинаЗверненняПОЛЕFoundXPlus10%, %ПричинаЗверненняПОЛЕFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Причина Звернення: ПОЛЕ), 930, 1
		goto ПричинаЗверненняПОЛЕ_Found_LOOP
	}




;	Gui, PAUSE:Add, Button, xs w200 h40 Center gПовнеМедичнеОбстеження_PAUSE_Button		, ПовнеМедичнеОбстеження

;ПовнеМедичнеОбстеження_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ПовнеМедичнеОбстеження_Found_LOOP
;return

ПовнеМедичнеОбстеження_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПовнеМедичнеОбстеженняFoundX, ПовнеМедичнеОбстеженняFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПовнеМедичнеОбстеження.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПовнеМедичнеОбстеженняFoundXPlus10 := ПовнеМедичнеОбстеженняFoundX + 10
		ПовнеМедичнеОбстеженняFoundYPlus10 := ПовнеМедичнеОбстеженняFoundY + 10
		Click, %ПовнеМедичнеОбстеженняFoundXPlus10%, %ПовнеМедичнеОбстеженняFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Повне Медичне Обстеження), 930, 1
		goto ПовнеМедичнеОбстеження_Found_LOOP
	}



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gПричиниЗверненняЗБЕРЕГТИ_PAUSE_Button		, ПричиниЗверненняЗБЕРЕГТИ

;ПричиниЗверненняЗБЕРЕГТИ_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ПричиниЗверненняЗБЕРЕГТИ_Found_LOOP
;return

ПричиниЗверненняЗБЕРЕГТИ_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПричиниЗверненняЗБЕРЕГТИFoundX, ПричиниЗверненняЗБЕРЕГТИFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПричиниЗверненняЗБЕРЕГТИ.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПричиниЗверненняЗБЕРЕГТИFoundXPlus10 := ПричиниЗверненняЗБЕРЕГТИFoundX + 10
		ПричиниЗверненняЗБЕРЕГТИFoundYPlus10 := ПричиниЗверненняЗБЕРЕГТИFoundY + 10
		Click, %ПричиниЗверненняЗБЕРЕГТИFoundXPlus10%, %ПричиниЗверненняЗБЕРЕГТИFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Причини Звернення: ЗБЕРЕГТИ), 930, 1
		goto ПричиниЗверненняЗБЕРЕГТИ_Found_LOOP
	}



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gПричиниЗверненняДОДАНО_PAUSE_Button		, ПричиниЗверненняДОДАНО

;ПричиниЗверненняДОДАНО_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ПричиниЗверненняДОДАНО_Found_LOOP
;return

ПричиниЗверненняДОДАНО_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПричиниЗверненняДОДАНОFoundX, ПричиниЗверненняДОДАНОFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ПричиниЗверненняДОДАНО.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПричиниЗверненняДОДАНОFoundXPlus10 := ПричиниЗверненняДОДАНОFoundX + 10
		ПричиниЗверненняДОДАНОFoundYPlus10 := ПричиниЗверненняДОДАНОFoundY + 10
		Click, %ПричиниЗверненняДОДАНОFoundXPlus10%, %ПричиниЗверненняДОДАНОFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Причини Звернення: ДОДАНО), 930, 1
		goto ПричиниЗверненняДОДАНО_Found_LOOP
	}




Sleep 100

;ScreenWidth := 1920
;ScreenHeight := 1080

; Получаем разрешение экрана
ScreenWidth := 1920
ScreenHeight := 1080

; Вычисляем координаты центра экрана
CenterX := ScreenWidth // 2
CenterY := ScreenHeight // 2

; Перемещаем курсор в центр экрана и выполняем клик
MouseMove, CenterX, CenterY
Click, CenterX, CenterY

								; Дії

Sleep 10
Send {PgDn}
Sleep 10
Send {PgDn}
Sleep 1000

								; Дії (ДОДАТИ)



ДіїДодати_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДіїДодатиFoundX, ДіїДодатиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ДіїДодати.png
	if ErrorLevel = 0
	{
		Sleep 100
		ДіїДодатиFoundXPlus10 := ДіїДодатиFoundX + 1100
		ДіїДодатиFoundYPlus10 := ДіїДодатиFoundY + 10
		Click, %ДіїДодатиFoundXPlus10%, %ДіїДодатиFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Дії: ДОДАТИ), 930, 1
		goto ДіїДодати_Found_LOOP
	}


ДіїОберітьЗіСписку_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДіїОберітьЗіСпискуFoundX, ДіїОберітьЗіСпискуFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ДіїОберітьЗіСписку.png
	if ErrorLevel = 0
	{
		Sleep 100
		ДіїОберітьЗіСпискуFoundXPlus10 := ДіїОберітьЗіСпискуFoundX + 10
		ДіїОберітьЗіСпискуFoundYPlus10 := ДіїОберітьЗіСпискуFoundY + 10
		Click, %ДіїОберітьЗіСпискуFoundXPlus10%, %ДіїОберітьЗіСпискуFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Дії: Оберіть зі списку), 930, 1
		goto ДіїОберітьЗіСписку_Found_LOOP
	}


If Офтальмолог = 1
{
	if (ПаузаНаДії = 1) {
		SoundBeep, 800
		SoundBeep, 800
		Sleep 100
		Консультація := "A67002"
		Send %Консультація%
;		Msgbox Перевірте Дії
		Sleep 1000
		goto КонсультаціяТерапевта_Found_LOOP
		}
}

If Офтальмолог = 1
{
Sleep 100
Консультація := "F67002"
Send %Консультація%
}



If Невролог = 1
{
Sleep 100
Консультація := "N67002"
Send %Консультація%
}

If Психофізіолог = 1
{
Sleep 100
Консультація := "P67005"
Send %Консультація%
}

If Терапевт = 1
{
Sleep 100
Консультація := "A67002"
Send %Консультація%
}



КонсультаціяОфтальмолога_Found_LOOP: 

If Офтальмолог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, КонсультаціяОфтальмологаFoundX, КонсультаціяОфтальмологаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\КонсультаціяОфтальмолога.png
	if ErrorLevel = 0
	{
		Sleep 100
		КонсультаціяОфтальмологаFoundXPlus10 := КонсультаціяОфтальмологаFoundX + 10
		КонсультаціяОфтальмологаFoundYPlus10 := КонсультаціяОфтальмологаFoundY + 10
		Click, %КонсультаціяОфтальмологаFoundXPlus10%, %КонсультаціяОфтальмологаFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Консультація Офтальмолога), 930, 1
		goto КонсультаціяОфтальмолога_Found_LOOP
	}

}

КонсультаціяНевролога_Found_LOOP: 

If Невролог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, КонсультаціяНеврологаFoundX, КонсультаціяНеврологаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\КонсультаціяНевролога.png
	if ErrorLevel = 0
	{
		Sleep 100
		КонсультаціяНеврологаFoundXPlus10 := КонсультаціяНеврологаFoundX + 10
		КонсультаціяНеврологаFoundYPlus10 := КонсультаціяНеврологаFoundY + 10
		Click, %КонсультаціяНеврологаFoundXPlus10%, %КонсультаціяНеврологаFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Консультація Невролога), 930, 1
		goto КонсультаціяНевролога_Found_LOOP
	}

}


КонсультаціяТерапевта_Found_LOOP: 

If ПаузаНаДії = 1
;If Терапевт = 1

{
	CoordMode, Pixel, Screen 
	ImageSearch, КонсультаціяТерапевтаFoundX, КонсультаціяТерапевтаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\КонсультаціяТерапевта.png
	if ErrorLevel = 0
	{
		Sleep 100
		КонсультаціяТерапевтаFoundXPlus10 := КонсультаціяТерапевтаFoundX + 10
		КонсультаціяТерапевтаFoundYPlus10 := КонсультаціяТерапевтаFoundY + 10
		Click, %КонсультаціяТерапевтаFoundXPlus10%, %КонсультаціяТерапевтаFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Консультація Терапевта), 930, 1
		goto КонсультаціяТерапевта_Found_LOOP
	}
}


ДіїЗБЕРЕГТИ_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДіїЗБЕРЕГТИFoundX, ДіїЗБЕРЕГТИFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ДіїЗБЕРЕГТИ.png
	if ErrorLevel = 0
	{
		Sleep 100
		ДіїЗБЕРЕГТИFoundXPlus10 := ДіїЗБЕРЕГТИFoundX + 10
		ДіїЗБЕРЕГТИFoundYPlus10 := ДіїЗБЕРЕГТИFoundY + 10
		Click, %ДіїЗБЕРЕГТИFoundXPlus10%, %ДіїЗБЕРЕГТИFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Дії: ЗБЕРЕГТИ), 930, 1
		goto ДіїЗБЕРЕГТИ_Found_LOOP
	}

НазваEHealthПослуги_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, НазваEHealthПослугиFoundX, НазваEHealthПослугиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\НазваEHealthПослуги.png
	if ErrorLevel = 0
	{
		Sleep 100
		НазваEHealthПослугиFoundXPlus10 := НазваEHealthПослугиFoundX + 10
		НазваEHealthПослугиFoundYPlus10 := НазваEHealthПослугиFoundY + 10
		Click, %НазваEHealthПослугиFoundXPlus10%, %НазваEHealthПослугиFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Назва EHealth Послуги (Дію додано.), 930, 1
		goto НазваEHealthПослуги_Found_LOOP
	}


If ГалочкаРекомендації = 1
{
goto РекомендаціїДодати_Found_LOOP
}
else 
{
goto БезРекомендацій
}

;	Gui, PAUSE:Add, Button, xs w200 h40 Center gРекомендаціїДодати_PAUSE_Button		, РекомендаціїДодати

;РекомендаціїДодати_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto РекомендаціїДодати_Found_LOOP
;return

РекомендаціїДодати_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, РекомендаціїДодатиFoundX, РекомендаціїДодатиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\РекомендаціїДодати.png
	if ErrorLevel = 0
	{
		Sleep 500
		РекомендаціїДодатиFoundXPlus10 := РекомендаціїДодатиFoundX + 1100
		РекомендаціїДодатиFoundYPlus10 := РекомендаціїДодатиFoundY + 10
		Click, %РекомендаціїДодатиFoundXPlus10%, %РекомендаціїДодатиFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Рекомендації: Додати), 930, 1
		goto РекомендаціїДодати_Found_LOOP
	}



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gПолеРекомендаціїЛікаря_PAUSE_Button		, ПолеРекомендаціїЛікаря

;ПолеРекомендаціїЛікаря_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ПолеРекомендаціїЛікаря_Found_LOOP
;return

ПолеРекомендаціїЛікаря_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПолеРекомендаціїЛікаряFoundX, ПолеРекомендаціїЛікаряFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ПолеРекомендаціїЛікаря.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПолеРекомендаціїЛікаряFoundXPlus10 := ПолеРекомендаціїЛікаряFoundX + 100
		ПолеРекомендаціїЛікаряFoundYPlus10 := ПолеРекомендаціїЛікаряFoundY + 100
		Click, %ПолеРекомендаціїЛікаряFoundXPlus10%, %ПолеРекомендаціїЛікаряFoundYPlus10%
		ToolTip
		send %ПолеРекомендацій%
		Sleep 500
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Поле: Рекомендації Лікаря), 930, 1
		goto ПолеРекомендаціїЛікаря_Found_LOOP
	}



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gРекомендаціїЗберегти_PAUSE_Button		, РекомендаціїЗберегти

;РекомендаціїЗберегти_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto РекомендаціїЗберегти_Found_LOOP
;return

РекомендаціїЗберегти_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, РекомендаціїЗберегтиFoundX, РекомендаціїЗберегтиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\РекомендаціїЗберегти.png
	if ErrorLevel = 0
	{
		Sleep 500
		РекомендаціїЗберегтиFoundXPlus10 := РекомендаціїЗберегтиFoundX + 10
		РекомендаціїЗберегтиFoundYPlus10 := РекомендаціїЗберегтиFoundY + 10
		Click, %РекомендаціїЗберегтиFoundXPlus10%, %РекомендаціїЗберегтиFoundYPlus10%
		ToolTip
		Sleep 1000
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Рекомендації: Зберегти), 930, 1
		goto РекомендаціїЗберегти_Found_LOOP
	}

БезРекомендацій:

Sleep 100
; Получаем разрешение экрана
ScreenWidth := 1920
ScreenHeight := 1080

; Вычисляем координаты центра экрана
CenterX := ScreenWidth // 2
CenterY := ScreenHeight // 2

; Перемещаем курсор в центр экрана и выполняем клик
MouseMove, CenterX, CenterY
Click, CenterX, CenterY

	 Sleep 10
	 Send {PgDn}
	 Sleep 10
	 Send {PgDn}
	 Sleep 1000
	 Send {PgDn}
	 Sleep 1000


ПолеЗаключення_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПолеЗаключенняFoundX, ПолеЗаключенняFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ПолеЗаключення.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПолеЗаключенняFoundXPlus10 := ПолеЗаключенняFoundX + 100
		ПолеЗаключенняFoundYPlus10 := ПолеЗаключенняFoundY + 100
		Click, %ПолеЗаключенняFoundXPlus10%, %ПолеЗаключенняFoundYPlus10%
		ToolTip
		Sleep 100
		Send %ПолеЗаключення%
		Sleep 500
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Поле: Заключення), 930, 1
		goto ПолеЗаключення_Found_LOOP
	}


;Придатний1_LOOP:
;	 Click,374 694 0
;	 PixelGetColor,Придатний1,374,694
;	 If ( Придатний1 = 0xD8EAF9 )
;	 {
;	 Sleep 500
;	 Click,374,694
;	 }
;	 else
;	 {
;	 Sleep 1000
;	 goto Придатний1_LOOP
;	 }


	 Sleep 10
	 Send {PgDn}
	 Sleep 1000

ЕпізодиЗБЕРЕГТИ_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЕпізодиЗБЕРЕГТИFoundX, ЕпізодиЗБЕРЕГТИFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ЕпізодиЗБЕРЕГТИ.png
	if ErrorLevel = 0
	{
		Sleep 100
		ЕпізодиЗБЕРЕГТИFoundXPlus10 := ЕпізодиЗБЕРЕГТИFoundX + 10
		ЕпізодиЗБЕРЕГТИFoundYPlus10 := ЕпізодиЗБЕРЕГТИFoundY + 10
		Click, %ЕпізодиЗБЕРЕГТИFoundXPlus10%, %ЕпізодиЗБЕРЕГТИFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Епізоди: ЗБЕРЕГТИ), 930, 1
		goto ЕпізодиЗБЕРЕГТИ_Found_LOOP
	}

Профогляди_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПрофоглядиFoundX, ПрофоглядиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Профогляди.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПрофоглядиFoundXPlus10 := ПрофоглядиFoundX + 10
		ПрофоглядиFoundYPlus10 := ПрофоглядиFoundY + 10
		Click, %ПрофоглядиFoundXPlus10%, %ПрофоглядиFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: 	Вкладка: (Профогляди/ВЛК), 930, 1
		goto Профогляди_Found_LOOP
	}

If Профогляд = 0
{
goto ПричиниЗвернення_Found_LOOP
}


Вроботі_Found_LOOP: 
;	CoordMode, Pixel, Screen 
;	ImageSearch, ВроботіFoundX, ВроботіFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\Вроботі.png
;	if ErrorLevel = 0
;	{
;		Sleep 100
;		ВроботіFoundXPlus10 := ВроботіFoundX + 10
;		ВроботіFoundYPlus10 := ВроботіFoundY + 10
;		Click, %ВроботіFoundXPlus10%, %ВроботіFoundYPlus10%
;		ToolTip
;	}
;	else
;	{
;		Sleep 100
;		CoordMode, ToolTip, Screen
;		ToolTip, Чекаю появу: (В роботі), 930, 1
;		goto Вроботі_Found_LOOP
;	}




attemptCount := 0  ; Инициализируем счетчик попыток

Ланцюг_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЛанцюгFoundX, ЛанцюгFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Ланцюг.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЛанцюгFoundXPlus10 := ЛанцюгFoundX + 30
		ЛанцюгFoundYPlus10 := ЛанцюгFoundY + 30
		Click, %ЛанцюгFoundXPlus10%, %ЛанцюгFoundYPlus10%
		ToolTip
		attemptCount := 0  ; Сбросить счетчик попыток при успешном поиске
		goto ВзаємодіяЗаключення_Found_LOOP
	}
	else
    {
        attemptCount++  ; Увеличиваем счетчик попыток
        if (attemptCount >= 5)
        {
            attemptCount := 0  ; Сбросить счетчик попыток 
			goto СтворитиПрофогляд
        }
	
		else
		{
			Sleep 500
			CoordMode, ToolTip, Screen
			ToolTip, Чекаю появу: (Ланцюг), 930, 1
			goto Ланцюг_Found_LOOP
		}
	}

СтворитиПрофогляд:


	If Психофізіолог = 1
	{
		MsgBox, Створити профогляд "Психофізіологічна експертиза"?
		Sleep 100
		goto СтрокаПошуку_Found_LOOP
	}


SoundBeep, 523
Sleep 100
SoundBeep, 392
SoundBeep, 440
SoundBeep, 523






АктивнийПрофоглядНеЗнайдено:

If ЧерезЗапис = 1
{
goto MsgboxRetry
}
else
{
MsgBox, Профогляд не знайдено, перейти до "Причини зверненя"?
goto ПричиниЗвернення_Found_LOOP
}

;MsgBox, 2,, Активний профогляд не знайдено. Abort - створити профогляд. Retry - Знайти пацієнта на Головній сторінці. Ignore - перейти до Причини звернення		; Abort/Retry/Ignore


MsgboxRetry:
;IfMsgBox Retry
;{
RetrySearch := 1


    SoundBeep, 392
    SoundBeep, 523
	
	Sleep 100
	

;_____________________________________________________________________________________________________________________________________________________________________________________

;	AppointmentID := ID
;	Run, msedge.exe "https://doctor.health.mia.software/appointment/%AppointmentID%/"
;	Sleep 10
;	goto НеЗявивсяПрофільЗавантажено_Found_LOOP

	
	
	Run, msedge.exe "https://doctor.health.mia.software/"
	Sleep 500
	
;	Gui, PAUSE:Add, Button, xs w200 h40 Center gГоловна_PAUSE_Button		, Головна

;Головна_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto Головна_Found_LOOP
;return

Головна_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ГоловнаFoundX, ГоловнаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\Головна.png
	if ErrorLevel = 0
	{
		Sleep 500
		ГоловнаFoundXPlus10 := ГоловнаFoundX + 10
		ГоловнаFoundYPlus10 := ГоловнаFoundY + 10
		Click, %ГоловнаFoundXPlus10%, %ГоловнаFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Головна), 930, 1
		goto Головна_Found_LOOP
	}
	
	
Sleep 100
Send {F3}
Sleep 100
Send %Прізвище%
Sleep 100


ToolTip, --------------------------------------ОБЕРІТЬ ПАЦІЄНТА--------------------------------------, 930, 1
Sleep 100


goto НеЗявивсяПрофільЗавантажено_Found_LOOP



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gЗнайденоОдинЗОдного_PAUSE_Button		, ЗнайденоОдинЗОдного

;ЗнайденоОдинЗОдного_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ЗнайденоОдинЗОдного_Found_LOOP
;return

ЗнайденоОдинЗОдного_Found_LOOP: 
	CoordMode, Pixel, Screen 
;	ImageSearch, ЗнайденоОдинЗОдногоFoundX, ЗнайденоОдинЗОдногоFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ЗнайденоОдинЗОдного.png
	ImageSearch, ЗнайденоОдинЗОдногоFoundX, ЗнайденоОдинЗОдногоFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ЗнайденоОдинЗОдного2.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЗнайденоОдинЗОдногоFoundXPlus10 := ЗнайденоОдинЗОдногоFoundX + 10
		ЗнайденоОдинЗОдногоFoundYPlus10 := ЗнайденоОдинЗОдногоFoundY + 10
		Click, %ЗнайденоОдинЗОдногоFoundXPlus10%, %ЗнайденоОдинЗОдногоFoundYPlus10% 0

		
		ToolTip
		Sleep 2000
		goto ЗнайденоНаСторінці
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Знайдено 1/1), 930, 1
		goto ЗнайденоОдинЗДвох_Found_LOOP
	}






;	Gui, PAUSE:Add, Button, xs w200 h40 Center gЗнайденоОдинЗДвох_PAUSE_Button		, ЗнайденоОдинЗДвох

;ЗнайденоОдинЗДвох_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ЗнайденоОдинЗДвох_Found_LOOP
;return

ЗнайденоОдинЗДвох_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЗнайденоОдинЗДвохFoundX, ЗнайденоОдинЗДвохFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ЗнайденоОдинЗДвох.png
;	ImageSearch, ЗнайденоОдинЗДвохFoundX, ЗнайденоОдинЗДвохFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ЗнайденоОдинЗДвох2.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЗнайденоОдинЗДвохFoundXPlus10 := ЗнайденоОдинЗДвохFoundX + 10
		ЗнайденоОдинЗДвохFoundYPlus10 := ЗнайденоОдинЗДвохFoundY + 10
		Msgbox, оберіть вірний профіль з наявних та натисніть ОК даблкліком.
		goto НеЗявивсяПрофільЗавантажено_Found_LOOP
;		Click, %ЗнайденоОдинЗДвохFoundXPlus10%, %ЗнайденоОдинЗДвохFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Знайдено 1/2), 930, 1
		goto ЗнайденоДваЗДвох_Found_LOOP
	}



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gЗнайденоДваЗДвох_PAUSE_Button		, ЗнайденоДваЗДвох

;ЗнайденоДваЗДвох_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ЗнайденоДваЗДвох_Found_LOOP
;return

ЗнайденоДваЗДвох_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЗнайденоДваЗДвохFoundX, ЗнайденоДваЗДвохFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ЗнайденоДваЗДвох.png
;	ImageSearch, ЗнайденоДваЗДвохFoundX, ЗнайденоДваЗДвохFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ЗнайденоДваЗДвох2.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЗнайденоДваЗДвохFoundXPlus10 := ЗнайденоДваЗДвохFoundX + 10
		ЗнайденоДваЗДвохFoundYPlus10 := ЗнайденоДваЗДвохFoundY + 10
		Click, %ЗнайденоДваЗДвохFoundXPlus10%, %ЗнайденоДваЗДвохFoundYPlus10%
		ToolTip
		Msgbox, оберіть вірний профіль з наявних та натисніть ОК даблкліком.
		goto НеЗявивсяПрофільЗавантажено_Found_LOOP
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Знайдено 2/2), 930, 1
		goto ЗнайденоОдинЗОдного_Found_LOOP
	}





;	Gui, PAUSE:Add, Button, xs w200 h40 Center gЗнайденоНаСторінці_PAUSE_Button		, ЗнайденоНаСторінці

;ЗнайденоНаСторінці_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ЗнайденоНаСторінці_Found_LOOP
;return



ЗнайденоНаСторінці_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЗнайденоНаСторінціFoundX, ЗнайденоНаСторінціFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ЗнайденоНаСторінці.png
	if ErrorLevel = 0
	{
		Sleep 1000
		ЗнайденоНаСторінціFoundXPlus10 := ЗнайденоНаСторінціFoundX + 20
		ЗнайденоНаСторінціFoundYPlus10 := ЗнайденоНаСторінціFoundY + 20
		Click, %ЗнайденоНаСторінціFoundXPlus10%, %ЗнайденоНаСторінціFoundYPlus10% 
		;Msgbox
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Паціента знайдено на сторінці: Головна), 930, 1
		goto ЗнайденоНаСторінці_Found_LOOP
	}


ЗнайденоНаСторінці:
		Send {PgDn}
		Sleep 100
		Send {PgDn}
		Sleep 100
ToolTip, --------------------------------------ОБЕРІТЬ ПАЦІЄНТА--------------------------------------, 930, 1








goto НеЗявивсяПрофільЗавантажено_Found_LOOP
	
;    goto СтрокаПошуку_Found_LOOP



;}
;else if (IfMsgBox Ignore)
;{
;   Sleep 100
;   goto ПричиниЗвернення_Found_LOOP
;}
;else if (IfMsgBox Abort)
;{
;    Sleep 100
;    goto СтрокаПошуку_Found_LOOP
;}






СтрокаПошуку_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, СтрокаПошукуFoundX, СтрокаПошукуFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\СтрокаПошуку.png
	if ErrorLevel = 0
	{
		Sleep 500
		СтрокаПошукуFoundXPlus10 := СтрокаПошукуFoundX + 10
		СтрокаПошукуFoundYPlus10 := СтрокаПошукуFoundY + 10
		Click, %СтрокаПошукуFoundXPlus10%, %СтрокаПошукуFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Строка Пошуку), 930, 1
		goto СтрокаПошуку_Found_LOOP
	}



		Sleep 500
		Send ^c
		Sleep 500
		
		originalUrl := Clipboard
		StringSplit, parts, originalUrl, /
		newUrl := parts1 "/" parts2 "/" parts3 "/" parts4 "/" parts5 "/"
		Sleep 500
		Send ^w
		Run, msedge.exe %newUrl%



ДеталіПрийому_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДеталіПрийомуFoundX, ДеталіПрийомуFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ДеталіПрийому.png
	if ErrorLevel = 0
	{
		Sleep 500
		ДеталіПрийомуFoundXPlus10 := ДеталіПрийомуFoundX + 10
		ДеталіПрийомуFoundYPlus10 := ДеталіПрийомуFoundY + 10
		Click, %ДеталіПрийомуFoundXPlus10%, %ДеталіПрийомуFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Деталі Прийому), 930, 1
		goto ДеталіПрийому_Found_LOOP
	}

		Sleep 500
		Send, {PgDn}
		Sleep 500
		Send, {PgDn}
		


ПрофВлкДляСтворення_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПрофВлкДляСтворенняFoundX, ПрофВлкДляСтворенняFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПрофВлкДляСтворення.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПрофВлкДляСтворенняFoundXPlus10 := ПрофВлкДляСтворенняFoundX + 10
		ПрофВлкДляСтворенняFoundYPlus10 := ПрофВлкДляСтворенняFoundY + 10
		Click, %ПрофВлкДляСтворенняFoundXPlus10%, %ПрофВлкДляСтворенняFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Профогляди / ВЛК), 930, 1
		goto ПрофВлкДляСтворення_Found_LOOP
	}

goto СтворитиПрофогляд_Found_LOOP

ЗнайденоЗаписів1_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЗнайденоЗаписів1FoundX, ЗнайденоЗаписів1FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ЗнайденоЗаписів1.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЗнайденоЗаписів1FoundXPlus10 := ЗнайденоЗаписів1FoundX + 10
		ЗнайденоЗаписів1FoundYPlus10 := ЗнайденоЗаписів1FoundY + 10
		Click, %ЗнайденоЗаписів1FoundXPlus10%, %ЗнайденоЗаписів1FoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (ЗнайденоЗаписів1), 930, 1
		goto ЗнайденоЗаписів1_Found_LOOP
	}		


СтворитиПрофогляд_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, СтворитиПрофоглядFoundX, СтворитиПрофоглядFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\СтворитиПрофогляд.png
	if ErrorLevel = 0
	{
		Sleep 500
		СтворитиПрофоглядFoundXPlus10 := СтворитиПрофоглядFoundX + 10
		СтворитиПрофоглядFoundYPlus10 := СтворитиПрофоглядFoundY + 10
		Click, %СтворитиПрофоглядFoundXPlus10%, %СтворитиПрофоглядFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Профогляд/ВЛК +), 930, 1
		goto СтворитиПрофогляд_Found_LOOP
	}


ПрофоглядВЛКПоле_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПрофоглядВЛКПолеFoundX, ПрофоглядВЛКПолеFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ПрофоглядВЛКПоле.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПрофоглядВЛКПолеFoundXPlus10 := ПрофоглядВЛКПолеFoundX + 200
		ПрофоглядВЛКПолеFoundYPlus10 := ПрофоглядВЛКПолеFoundY + 10
		Click, %ПрофоглядВЛКПолеFoundXPlus10%, %ПрофоглядВЛКПолеFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Профогляд/ВЛК * Оберіть зі списку), 930, 1
		goto ПрофоглядВЛКПоле_Found_LOOP
	}

SelectedШаблон := ШаблонChoice

if (SelectedШаблон = "Профогляд Офт.")
{

goto ПсихофізіологічнаЕкспертиза_Found_LOOP

;goto Наказ246_Found_LOOP
}
else if (SelectedШаблон = "ВЛК Офт.")
{
goto Наказ246_Found_LOOP
}
else if (SelectedШаблон = "Прийом Невролога")
{
goto Наказ246_Found_LOOP
}
else if (SelectedШаблон = "ВЛК Невролога")
{
goto Наказ246_Found_LOOP
}

Наказ246_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, Наказ246FoundX, Наказ246FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Наказ246.png
	if ErrorLevel = 0
	{
		Sleep 500
		Наказ246FoundXPlus10 := Наказ246FoundX + 10
		Наказ246FoundYPlus10 := Наказ246FoundY + 10
		Click, %Наказ246FoundXPlus10%, %Наказ246FoundYPlus10%
		ToolTip
		Sleep 500
		goto ПрофоглядЗберегти_Found_LOOP
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Наказ №246), 930, 1
		goto Наказ246_Found_LOOP
	}


;	Gui, PAUSE:Add, Button, xs w200 h40 Center gПсихофізіологічнаЕкспертиза_PAUSE_Button		, ПсихофізіологічнаЕкспертиза

;ПсихофізіологічнаЕкспертиза_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ПсихофізіологічнаЕкспертиза_Found_LOOP
;return

ПсихофізіологічнаЕкспертиза_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПсихофізіологічнаЕкспертизаFoundX, ПсихофізіологічнаЕкспертизаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПсихофізіологічнаЕкспертиза.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПсихофізіологічнаЕкспертизаFoundXPlus10 := ПсихофізіологічнаЕкспертизаFoundX + 10
		ПсихофізіологічнаЕкспертизаFoundYPlus10 := ПсихофізіологічнаЕкспертизаFoundY + 10
		Click, %ПсихофізіологічнаЕкспертизаFoundXPlus10%, %ПсихофізіологічнаЕкспертизаFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Психофізіологічна Експертиза), 930, 1
		goto ПсихофізіологічнаЕкспертиза_Found_LOOP
	}



ПрофоглядЗберегти_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПрофоглядЗберегтиFoundX, ПрофоглядЗберегтиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПрофоглядЗберегти.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПрофоглядЗберегтиFoundXPlus10 := ПрофоглядЗберегтиFoundX + 10
		ПрофоглядЗберегтиFoundYPlus10 := ПрофоглядЗберегтиFoundY + 10
		Click, %ПрофоглядЗберегтиFoundXPlus10%, %ПрофоглядЗберегтиFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Профогляд Зберегти), 930, 1
		goto ПрофоглядЗберегти_Found_LOOP
	}


ВзятиВроботу_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ВзятиВроботуFoundX, ВзятиВроботуFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ВзятиВроботу.png
	if ErrorLevel = 0
	{
		Sleep 500
		ВзятиВроботуFoundXPlus10 := ВзятиВроботуFoundX + 10
		ВзятиВроботуFoundYPlus10 := ВзятиВроботуFoundY + 10
		Click, %ВзятиВроботуFoundXPlus10%, %ВзятиВроботуFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Взяти в роботу), 930, 1
		goto ВзятиВроботу_Found_LOOP
	}

	Sleep 1000
	Send ^w
	Sleep 500
	Run, msedge.exe %originalUrl% 

	goto Ланцюг_Found_LOOP








ВзаємодіяЗаключення_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ВзаємодіяЗаключенняFoundX, ВзаємодіяЗаключенняFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\Поля\ВзаємодіяЗаключення.png
	if ErrorLevel = 0
	{
		Sleep 500
		ВзаємодіяЗаключенняFoundXPlus10 := ВзаємодіяЗаключенняFoundX + 100
		ВзаємодіяЗаключенняFoundYPlus10 := ВзаємодіяЗаключенняFoundY + 100
		Click, %ВзаємодіяЗаключенняFoundXPlus10%, %ВзаємодіяЗаключенняFoundYPlus10%
			Sleep 500
			Send %ПолеЗаключення%
			Sleep 500
			
		ToolTip
		Sleep 500
		goto ПОСИЛАННЯ_Found_LOOP
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Взаємодія Заключення), 930, 1
		goto ВзаємодіяЗаключення2_Found_LOOP
	}


ВзаємодіяЗаключення2_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ВзаємодіяЗаключення2FoundX, ВзаємодіяЗаключення2FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\Поля\ВзаємодіяЗаключення2.png
	if ErrorLevel = 0
	{
		Sleep 500
		ВзаємодіяЗаключення2FoundXPlus10 := ВзаємодіяЗаключення2FoundX + 200
		ВзаємодіяЗаключення2FoundYPlus10 := ВзаємодіяЗаключення2FoundY + 100
		Click, %ВзаємодіяЗаключення2FoundXPlus10%, %ВзаємодіяЗаключення2FoundYPlus10%
			Sleep 500
			Send %ПолеЗаключення%
			
		ToolTip
		Sleep 500
		goto ПОСИЛАННЯ_Found_LOOP
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Взаємодія Заключення), 930, 1
		goto ВзаємодіяЗаключення_Found_LOOP
	}




ПОСИЛАННЯ_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПОСИЛАННЯFoundX, ПОСИЛАННЯFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПОСИЛАННЯ.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПОСИЛАННЯFoundXPlus10 := ПОСИЛАННЯFoundX + 10
		ПОСИЛАННЯFoundYPlus10 := ПОСИЛАННЯFoundY + 10
		Click, %ПОСИЛАННЯFoundXPlus10%, %ПОСИЛАННЯFoundYPlus10%
		
		ToolTip
		Sleep 500
		goto ВзаємодіюБуло_Found_LOOP
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (ПОСИЛАННЯ), 930, 1
		goto Посилання2_Found_LOOP
	}


Посилання2_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, Посилання2FoundX, Посилання2FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Посилання2.png
	if ErrorLevel = 0
	{
		Sleep 500
		Посилання2FoundXPlus10 := Посилання2FoundX + 10
		Посилання2FoundYPlus10 := Посилання2FoundY + 10
		Click, %Посилання2FoundXPlus10%, %Посилання2FoundYPlus10%
		ToolTip
		
		Sleep 500
		goto ВзаємодіюБуло_Found_LOOP
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (ПОСИЛАННЯ), 930, 1
		goto ПОСИЛАННЯ_Found_LOOP
	}


ВзаємодіюБуло_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ВзаємодіюБулоFoundX, ВзаємодіюБулоFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\ВзаємодіюБуло.png
	if ErrorLevel = 0
	{
		Sleep 100
;		ВзаємодіюБулоFoundXPlus10 := ВзаємодіюБулоFoundX + 10
;		ВзаємодіюБулоFoundYPlus10 := ВзаємодіюБулоFoundY + 10
;		Click, %ВзаємодіюБулоFoundXPlus10%, %ВзаємодіюБулоFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: ІНДИКАТОР (Взаємодію було прикріплено), 930, 1
		goto ВзаємодіюБуло_Found_LOOP
	}

If Офтальмолог = 1
{
goto ПричиниЗвернення_Found_LOOP
}

If Невролог = 1
{
goto ПричиниЗвернення_Found_LOOP
}

If Психофізіолог = 1
{
goto ПричиниЗвернення_Found_LOOP
}

If Терапевт = 1
{
goto ПричиниЗвернення_Found_LOOP
}

ПричиниЗвернення_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПричиниЗверненняFoundX, ПричиниЗверненняFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПричиниЗвернення.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПричиниЗверненняFoundXPlus10 := ПричиниЗверненняFoundX + 10
		ПричиниЗверненняFoundYPlus10 := ПричиниЗверненняFoundY + 10
		Click, %ПричиниЗверненняFoundXPlus10%, %ПричиниЗверненняFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Причини Звернення), 930, 1
		goto ПричиниЗвернення_Found_LOOP
	}

Загальні_Found_LOOP: 
If Офтальмолог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, ЗагальніFoundX, ЗагальніFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\Загальні.png
	if ErrorLevel = 0
	{
		Sleep 100
		ЗагальніFoundXPlus10 := ЗагальніFoundX + 200
		ЗагальніFoundYPlus10 := ЗагальніFoundY + 10
		Click, %ЗагальніFoundXPlus10%, %ЗагальніFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Загальні), 930, 1
		goto Загальні_Found_LOOP
	}
}


ЗагальніСкарги_Found_LOOP: 
If Невролог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, ЗагальніСкаргиFoundX, ЗагальніСкаргиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ЗагальніСкарги.png
	if ErrorLevel = 0
	{
		Sleep 200
		ЗагальніСкаргиFoundXPlus10 := ЗагальніСкаргиFoundX + 300
		ЗагальніСкаргиFoundYPlus10 := ЗагальніСкаргиFoundY + 30
		Click, %ЗагальніСкаргиFoundXPlus10%, %ЗагальніСкаргиFoundYPlus10%
		ToolTip
		Sleep 100
		Send cкарг на момент огляду немає
		Sleep 100
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Загальні Скарги), 930, 1
		goto ЗагальніСкарги_Found_LOOP
	}
}


СкаргНемаєНевр_Found_LOOP: 
If Невролог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, СкаргНемаєНеврFoundX, СкаргНемаєНеврFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\СкаргНемаєНевр.png
	if ErrorLevel = 0
	{
		Sleep 100
		СкаргНемаєНеврFoundXPlus10 := СкаргНемаєНеврFoundX + 10
		СкаргНемаєНеврFoundYPlus10 := СкаргНемаєНеврFoundY + 10
		Click, %СкаргНемаєНеврFoundXPlus10%, %СкаргНемаєНеврFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Скарг Немає), 930, 1
		goto СкаргНемаєНевр_Found_LOOP
	}
}


Немає_Found_LOOP: 
If Офтальмолог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, НемаєFoundX, НемаєFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Немає.png
	if ErrorLevel = 0
	{
		Sleep 100
		НемаєFoundXPlus10 := НемаєFoundX + 10
		НемаєFoundYPlus10 := НемаєFoundY + 10
		Click, %НемаєFoundXPlus10%, %НемаєFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Немає), 930, 1
		goto Немає_Found_LOOP
	}
}

	ТерапевтЗагальні_Found_LOOP: 
	If Терапевт = 1
	{
		CoordMode, Pixel, Screen 
		ImageSearch, ТерапевтЗагальніFoundX, ТерапевтЗагальніFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ТерапевтЗагальні.png
		if ErrorLevel = 0
		{
			Sleep 100
			ТерапевтЗагальніFoundXPlus10 := ТерапевтЗагальніFoundX + 200
			ТерапевтЗагальніFoundYPlus10 := ТерапевтЗагальніFoundY + 10
			Click, %ТерапевтЗагальніFoundXPlus10%, %ТерапевтЗагальніFoundYPlus10%
			ToolTip
				Sleep 100
				Send скарги відсутні
				Sleep 100
		}
		else
		{
			Sleep 100
			CoordMode, ToolTip, Screen
			ToolTip, Чекаю появу: (Терапевт: Причини звернення: Загальні), 930, 1
			goto ТерапевтЗагальні_Found_LOOP
		}
	}

	ТерапевтСкаргиВідсутні_Found_LOOP: 
	If Терапевт = 1
	{
		CoordMode, Pixel, Screen 
		ImageSearch, ТерапевтСкаргиВідсутніFoundX, ТерапевтСкаргиВідсутніFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ТерапевтСкаргиВідсутні.png
		if ErrorLevel = 0
		{
			Sleep 100
			ТерапевтСкаргиВідсутніFoundXPlus10 := ТерапевтСкаргиВідсутніFoundX + 10
			ТерапевтСкаргиВідсутніFoundYPlus10 := ТерапевтСкаргиВідсутніFoundY + 10
			Click, %ТерапевтСкаргиВідсутніFoundXPlus10%, %ТерапевтСкаргиВідсутніFoundYPlus10%
			ToolTip
		}
		else
		{
			Sleep 100
			CoordMode, ToolTip, Screen
			ToolTip, Чекаю появу: (ТерапевтСкаргиВідсутні), 930, 1
			goto ТерапевтСкаргиВідсутні_Found_LOOP
		}
	}


Обєктивно_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ОбєктивноFoundX, ОбєктивноFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Обєктивно.png
	if ErrorLevel = 0
	{
		Sleep 100
		ОбєктивноFoundXPlus10 := ОбєктивноFoundX + 10
		ОбєктивноFoundYPlus10 := ОбєктивноFoundY + 10
		Click, %ОбєктивноFoundXPlus10%, %ОбєктивноFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Обєктивно), 930, 1
		goto Обєктивно_Found_LOOP
	}



SelectedШаблон := ШаблонChoice

if (SelectedШаблон = "Профогляд Офт.")
{
goto VisOD_Found_LOOP
}
else if (SelectedШаблон = "ВЛК Офт.")
{
goto ПочатокІперебіг_Found_LOOP
}
else if (SelectedШаблон = "Прийом Невролога")
{
goto ЧерепноМозковіНерви_ПРОСТІШЕ
}


;	Gui, PAUSE:Add, Button, xs w200 h40 Center gПочатокІперебіг_PAUSE_Button		, ПочатокІперебіг
;ПочатокІперебіг_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ПочатокІперебіг_Found_LOOP
;return

ПочатокІперебіг_Found_LOOP: 

If Офтальмолог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, ПочатокІперебігFoundX, ПочатокІперебігFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ПочатокІперебіг.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПочатокІперебігFoundXPlus10 := ПочатокІперебігFoundX + 200
		ПочатокІперебігFoundYPlus10 := ПочатокІперебігFoundY + 30
		Click, %ПочатокІперебігFoundXPlus10%, %ПочатокІперебігFoundYPlus10%
		ToolTip
		Sleep 500
		

	if (WithCorrOD) = 1
	{
		if 		(CylOD = 0.0)
		{
			FullVisusCorrOD := ".`nVisus OD = " . VisusOD . " = Sph " . SphOD . " D = " . VisusCorrOD . "`n"
		}

		else if (SphOD = 0.0)

		{
			FullVisusCorrOD := ".`nVisus OD = " . VisusOD . " = Cyl " . CylOD . " D ( " . AxOD . " ) = " . VisusCorrOD . "`n"
		}

		else

		{
			FullVisusCorrOD := ".`nVisus OD = " . VisusOD . " = Sph " . SphOD . " D Cyl " . CylOD . " D ( " . AxOD . " ) = " . VisusCorrOD . "`n"
		}
	}

	else if (WithCorrOD) = -1
	{
	FullVisusCorrOD := ".`nVisus OD = " . VisusOD . "н.к.`n"
	}
	else
	{
	FullVisusCorrOD := ".`nVisus OD = " . VisusOD . "`n"
	}





	if (WithCorrOS) = 1
	{
		if (CylOS = 0.0)
		{
			FullVisusCorrOS := "Visus OS = " . VisusOS . " = Sph " . SphOS . " D = " . VisusCorrOS . "`n"
		}

		else if (SphOS = 0.0)

		{
			FullVisusCorrOS := "Visus OS = " . VisusOS . " = Cyl " . CylOS . " D ( " . AxOS . " ) = " . VisusCorrOS . "`n"
		}

		else
		{
			FullVisusCorrOS := "Visus OS = " . VisusOS . " = Sph " . SphOS . " D Cyl " . CylOS . " D ( " . AxOS . " ) = " . VisusCorrOS . "`n"
		}
	}

	else if (WithCorrOS) = -1
	{
	FullVisusCorrOS := "Visus OS = " . VisusOS . "н.к.`n"
	}
	else
	{
	FullVisusCorrOS := "Visus OS = " . VisusOS . "`n"
	}


Send %FullVisusCorrOD%
Send %FullVisusCorrOS%


Send Відчуття кольорів: Нормальна трихромазія. Окоруховий апарат: в нормі. Повіки і кон'юнктива: спокійні. Зіниці та їх реакція: рівномірні. Передні відділки очей і глибокі середовища: без особливостей. Положення і рухливість очних яблук: в повному обсязі. Очне дно правого ока: ДЗН блідо-рожевого забарвлення, межі чіткі, судини в нормі. Очне дно лівого ока: ДЗН блідо-рожевого забарвлення, межі чіткі, судини в нормі.
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Початок і перебіг), 930, 1
		goto ПочатокІперебіг_Found_LOOP
	}



If Офтальмолог = 1
{
	if (ПаузаНаVisus = 1) {
		SoundBeep, 800
		SoundBeep, 800
		Msgbox Перевірте Visus
		Sleep 100
		}
}

; Получаем разрешение экрана
ScreenWidth := 1920
ScreenHeight := 1080

; Вычисляем координаты центра экрана
CenterX := ScreenWidth // 2
CenterY := ScreenHeight // 2

	; Перемещаем курсор в центр экрана и выполняем клик
	MouseMove, CenterX, CenterY
	Click, CenterX, CenterY

	Sleep 100
	Send {PgUp}
	Sleep 10
	Send {PgUp}
	Sleep 1000

goto ЗавершитиПрийом_Found_LOOP

}


VisOD_Found_LOOP: 
If Офтальмолог = 1
{
		CoordMode, Pixel, Screen 
		ImageSearch, VisODFoundX, VisODFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\VisOD.png
		if ErrorLevel = 0
		{
			Sleep 500
			VisODFoundXPlus10 := VisODFoundX + 200
			VisODFoundYPlus10 := VisODFoundY + 10
			Click, %VisODFoundXPlus10%, %VisODFoundYPlus10%
			ToolTip
		}
		else
		{
			Sleep 500
			CoordMode, ToolTip, Screen
			ToolTip, Чекаю появу: (VisOD), 930, 1
			goto VisOD_Found_LOOP
		}



	if (WithCorrOD) = 1
	{
		if 		(CylOD = 0.0)
		{
			FullVisusCorrOD := "Sph " . SphOD . " D = " . VisusCorrOD
		}

		else if (SphOD = 0.0)

		{
			FullVisusCorrOD := "Cyl " . CylOD . " D ( " . AxOD . " ) = " . VisusCorrOD
		}

		else

		{
			FullVisusCorrOD := "Sph " . SphOD . " D Cyl " . CylOD . " D ( " . AxOD . " ) = " . VisusCorrOD
		}
	}

	else if (WithCorrOD) = -1
	{
	FullVisusCorrOD := "н.к."
	}
	else
	{
	FullVisusCorrOD :=
	}





	if (WithCorrOS) = 1
	{
		if (CylOS = 0.0)
		{
			FullVisusCorrOS := "Sph " . SphOS . " D = " . VisusCorrOS
		}

		else if (SphOS = 0.0)

		{
			FullVisusCorrOS := "Cyl " . CylOS . " D ( " . AxOS . " ) = " . VisusCorrOS
		}

		else
		{
			FullVisusCorrOS := "Sph " . SphOS . " D Cyl " . CylOS . " D ( " . AxOS . " ) = " . VisusCorrOS
		}
	}

	else if (WithCorrOS) = -1
	{
	FullVisusCorrOS := "н.к."
	}
	else
	{
	FullVisusCorrOS :=
	}


	Send %VisusOD%
	Sleep 100
	Send {TAB}
	Sleep 100
	Send %VisusOS%
	Sleep 100
	Send {TAB}
	Sleep 200
	Send %FullVisusCorrOD%
	Sleep 1000
	Send {TAB}
	Sleep 200
	Send %FullVisusCorrOS%




	if (ПаузаНаVisus = 1) {
	SoundBeep, 800
	SoundBeep, 800
	Msgbox Перевірте Visus
	Sleep 3000
	}

}

ХарактерЗору_Found_LOOP: 
If Офтальмолог = 1
{


		CoordMode, Pixel, Screen 
		ImageSearch, ХарактерЗоруFoundX, ХарактерЗоруFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Обєктивно\ХарактерЗору.png
		if ErrorLevel = 0
		{
			Sleep 2000
			ХарактерЗоруFoundXPlus10 := ХарактерЗоруFoundX + 300
			ХарактерЗоруFoundYPlus10 := ХарактерЗоруFoundY + 10
			Click, %ХарактерЗоруFoundXPlus10%, %ХарактерЗоруFoundYPlus10%
			ToolTip
		}
		else
		{
			Sleep 500
			CoordMode, ToolTip, Screen
			ToolTip, Чекаю появу: (Характер Зору), 930, 1
			goto ХарактерЗору_Found_LOOP
		}

}


ХарактерЗоруВнормі_Found_LOOP: 
If Офтальмолог = 1
{
		CoordMode, Pixel, Screen 
		ImageSearch, ХарактерЗоруВнорміFoundX, ХарактерЗоруВнорміFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Обєктивно\ХарактерЗоруВнормі.png
		if ErrorLevel = 0
		{
			Sleep 2000
			ХарактерЗоруВнорміFoundXPlus10 := ХарактерЗоруВнорміFoundX + 10
			ХарактерЗоруВнорміFoundYPlus10 := ХарактерЗоруВнорміFoundY + 10
			Click, %ХарактерЗоруВнорміFoundXPlus10%, %ХарактерЗоруВнорміFoundYPlus10%
			ToolTip
			Send {Pgdn}
			Sleep 500
			Send {Pgdn}
			Sleep 500
			Sleep 1000
			
		}
		else
		{
			Sleep 500
			CoordMode, ToolTip, Screen
			ToolTip, Чекаю появу: (Характер Зору: В нормі), 930, 1
			goto ХарактерЗоруВнормі_Found_LOOP
		}
}

РогівкаОД_Found_LOOP: 
If Офтальмолог = 1
{
		CoordMode, Pixel, Screen 
		ImageSearch, РогівкаОДFoundX, РогівкаОДFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Обєктивно\РогівкаОД.png
		if ErrorLevel = 0
		{
			Sleep 500
			РогівкаОДFoundXPlus10 := РогівкаОДFoundX + 300
			РогівкаОДFoundYPlus10 := РогівкаОДFoundY + 10
			Click, %РогівкаОДFoundXPlus10%, %РогівкаОДFoundYPlus10%
			ToolTip
			Sleep 500
		}
		else
		{
			Sleep 500
			CoordMode, ToolTip, Screen
			ToolTip, Чекаю появу: (Рогівка ОД), 930, 1
			goto РогівкаОД_Found_LOOP
		}
}

If Офтальмолог = 1
{
Sleep 500
Send Прозора
Sleep 300
Send {Enter} 		;Рогівка (OD)

Sleep 300
Send {TAB}
Sleep 500
Send Прозора
Sleep 300
Send {Enter} 		;Рогівка (OS)

Sleep 300
Send {TAB}
Sleep 500
Send Прозорий
Sleep 300
Send {Enter} 		;Кришталик (OD)

Sleep 300
Send {TAB}
Sleep 500
Send Прозорий
Sleep 300
Send {Enter} 		;Кришталик (OS)

Sleep 300
Send {TAB}
Sleep 500
Send Блідорожевий
Sleep 300
Send {Enter} 		;Колір диску зорового нерву (OD)

Sleep 300
Send {TAB}
Sleep 500
Send Блідорожевий
Sleep 300
Send {Enter} 		;Колір диску зорового нерву (OS)

Sleep 300
Send {TAB}
Sleep 500
Send в нормі
Sleep 300
Send {Enter} 		;Границі диску зорового нерву (OD)

Sleep 300
Send {TAB}
Sleep 500
Send в нормі
Sleep 500
Send {Enter} 		;Границі диску зорового нерву (OS)


Sleep 300
Send {TAB}
Sleep 500
Send Нормального калібру
Sleep 500
Send {Down}
Sleep 500
Send {Enter} 		;Калібр судин сітківки (OD)

Sleep 300
Send {TAB}
Sleep 500
Send Нормального калібру
Sleep 300
Send {Down}
Sleep 500
Send {Enter} 		;Калібр судин сітківки (OS)

Sleep 300
Send {TAB}
Sleep 500
Send В межах норми
Sleep 500
Send {Down}
Sleep 500
Send {Enter} 		;Макула (жовта пляма) (OD)

Sleep 300
Send {TAB}
Sleep 500
Send В межах норми
Sleep 500
Send {Down}
Sleep 500
Send {Enter} 		;Макула (жовта пляма) (OS)

Sleep 300
Send {TAB}

Sleep 300
Send {TAB}

}


SelectedШаблон := ШаблонChoice
if (SelectedШаблон = "Прийом Невролога")
{
;goto ЧерепноМозковіНерви_Found_LOOP
goto ЧерепноМозковіНерви_ПРОСТІШЕ
}
else if (SelectedШаблон = "ВЛК Невролога")
{

}


;ЧерепноМозковіНерви_Found_LOOP: 
;If Невролог = 1
;{
;	CoordMode, Pixel, Screen 
;	ImageSearch, ЧерепноМозковіНервиFoundX, ЧерепноМозковіНервиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ЧерепноМозковіНерви.png
;	if ErrorLevel = 0
;	{
;		Sleep 500
;		ЧерепноМозковіНервиFoundXPlus10 := ЧерепноМозковіНервиFoundX + 200
;		ЧерепноМозковіНервиFoundYPlus10 := ЧерепноМозковіНервиFoundY + 10
;		Click, %ЧерепноМозковіНервиFoundXPlus10%, %ЧерепноМозковіНервиFoundYPlus10%
;		Sleep 500
;		Send Без особливостей
;		Sleep 500
;		ToolTip
;	}
;	else
;	{
;		Sleep 500
;		CoordMode, ToolTip, Screen
;		ToolTip, Чекаю появу: (Черепно Мозкові Нерви), 930, 1
;		goto ЧерепноМозковіНерви_Found_LOOP
;	}
;}


If Невролог = 1
{
БезОсобливостей_Found_LOOP: 
goto ЧерепноМозковіНерви_ПРОСТІШЕ
	CoordMode, Pixel, Screen 
	ImageSearch, БезОсобливостейFoundX, БезОсобливостейFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\БезОсобливостей.png
	if ErrorLevel = 0
	{
		Sleep 500
		БезОсобливостейFoundXPlus10 := БезОсобливостейFoundX + 10
		БезОсобливостейFoundYPlus10 := БезОсобливостейFoundY + 10
		Click, %БезОсобливостейFoundXPlus10%, %БезОсобливостейFoundYPlus10%
			Sleep 500
			Send {TAB}
			Sleep 500
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Без особливостей), 930, 1
		goto БезОсобливостей_Found_LOOP
	}
}

If Невролог = 1
{
		Sleep 500
		Send непорушена
		Sleep 500
}

Непорушена_Found_LOOP: 
If Невролог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, НепорушенаFoundX, НепорушенаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Непорушена.png
	if ErrorLevel = 0
	{
		Sleep 500
		НепорушенаFoundXPlus10 := НепорушенаFoundX + 10
		НепорушенаFoundYPlus10 := НепорушенаFoundY + 10
		Click, %НепорушенаFoundXPlus10%, %НепорушенаFoundYPlus10%
			Sleep 500
			Send {TAB}
			Sleep 500
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (непорушена), 930, 1
		goto Непорушена_Found_LOOP
	}
}


If Невролог = 1
{
		Sleep 500
		Send З верхніх кінцівок - живі, D=S. З нижніх  кінцівок - живі, D=S.
		Sleep 500
}



РефлексиЖиві_Found_LOOP: 
If Невролог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, РефлексиЖивіFoundX, РефлексиЖивіFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\РефлексиЖиві.png
	if ErrorLevel = 0
	{
		Sleep 500
		РефлексиЖивіFoundXPlus10 := РефлексиЖивіFoundX + 10
		РефлексиЖивіFoundYPlus10 := РефлексиЖивіFoundY + 10
		Click, %РефлексиЖивіFoundXPlus10%, %РефлексиЖивіFoundYPlus10%
			Sleep 500
			Send {TAB}
			Sleep 500
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Рефлекси живі), 930, 1
		goto РефлексиЖиві_Found_LOOP
	}
}


If Невролог = 1
{
			Sleep 500
			Send збережена
			Sleep 500
}


Збережена_Found_LOOP: 
If Невролог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, ЗбереженаFoundX, ЗбереженаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Збережена.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЗбереженаFoundXPlus10 := ЗбереженаFoundX + 10
		ЗбереженаFoundYPlus10 := ЗбереженаFoundY + 10
		Click, %ЗбереженаFoundXPlus10%, %ЗбереженаFoundYPlus10%
			Sleep 500
			Send {TAB}
			Sleep 500
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Збережена), 930, 1
		goto Збережена_Found_LOOP
	}
}




If Невролог = 1
{
			Sleep 500
			Send в нормі
			Sleep 500
}


ВегНервСистВнормі_Found_LOOP: 
If Невролог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, ВегНервСистВнорміFoundX, ВегНервСистВнорміFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ВегНервСистВнормі.png
	if ErrorLevel = 0
	{
		Sleep 500
		ВегНервСистВнорміFoundXPlus10 := ВегНервСистВнорміFoundX + 10
		ВегНервСистВнорміFoundYPlus10 := ВегНервСистВнорміFoundY + 10
		Click, %ВегНервСистВнорміFoundXPlus10%, %ВегНервСистВнорміFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (в нормі), 930, 1
		goto ВегНервСистВнормі_Found_LOOP
	}
}


ЧерепноМозковіНерви_ПРОСТІШЕ:

ЧерепноМозковіНерви_Found_LOOP: 
If Невролог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, ЧерепноМозковіНервиFoundX, ЧерепноМозковіНервиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ЧерепноМозковіНерви.png
	if ErrorLevel = 0
	{
		Sleep 1000
		ЧерепноМозковіНервиFoundXPlus10 := ЧерепноМозковіНервиFoundX + 200
		ЧерепноМозковіНервиFoundYPlus10 := ЧерепноМозковіНервиFoundY + 10
		Click, %ЧерепноМозковіНервиFoundXPlus10%, %ЧерепноМозковіНервиFoundYPlus10%
		Sleep 100
		Send без особливостей. Рухова сфера: непорушена. Рефлекси: З верхніх кінцівок - живі, D=S. З нижніх кінцівок - живі, D=S. Чутливість: збережена. Вегетативна нервова система: в нормі.
		Sleep 1000
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: ПОЛЕ:(Черепно-мозкові нерви:), 930, 1
		goto ЧерепноМозковіНерви_Found_LOOP
	}
}



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gОбєктивноВведено_PAUSE_Button		, ОбєктивноВведено

;ОбєктивноВведено_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ОбєктивноВведено_Found_LOOP
;return

ОбєктивноВведено_Found_LOOP: 

If Невролог = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, ОбєктивноВведеноFoundX, ОбєктивноВведеноFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ОбєктивноВведено.png
	if ErrorLevel = 0
	{
		Sleep 500
		ОбєктивноВведеноFoundXPlus10 := ОбєктивноВведеноFoundX + 10
		ОбєктивноВведеноFoundYPlus10 := ОбєктивноВведеноFoundY + 10
		Click, %ОбєктивноВведеноFoundXPlus10%, %ОбєктивноВведеноFoundYPlus10%
		ToolTip
		Sleep 1000
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Обєктивно - Введено), 930, 1
		goto ОбєктивноВведено_Found_LOOP
	}
}

															;Обєктивно

Зріст_Found_LOOP: 
If Терапевт = 1						
{
	CoordMode, Pixel, Screen 
	ImageSearch, ЗрістFoundX, ЗрістFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\Зріст.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЗрістFoundXPlus10 := ЗрістFoundX + 200
		ЗрістFoundYPlus10 := ЗрістFoundY + 10
		Click, %ЗрістFoundXPlus10%, %ЗрістFoundYPlus10%
		ToolTip
			Sleep 500
			Send %Зріст%
			Sleep 500
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Зріст), 930, 1
		goto Зріст_Found_LOOP
	}
}




Вага_Found_LOOP: 
If Терапевт = 1						
{
	CoordMode, Pixel, Screen 
	ImageSearch, ВагаFoundX, ВагаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\Вага.png
	if ErrorLevel = 0
	{
		Sleep 500
		ВагаFoundXPlus10 := ВагаFoundX + 200
		ВагаFoundYPlus10 := ВагаFoundY + 10
		Click, %ВагаFoundXPlus10%, %ВагаFoundYPlus10%
		ToolTip
			Sleep 500
			Send %Вага%
			Sleep 500
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Вага), 930, 1
		goto Вага_Found_LOOP
	}
}


Температура_Found_LOOP:
If Терапевт = 1						
{ 
	CoordMode, Pixel, Screen 
	ImageSearch, ТемператураFoundX, ТемператураFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\Температура.png
	if ErrorLevel = 0
	{
		Sleep 500
		ТемператураFoundXPlus10 := ТемператураFoundX + 200
		ТемператураFoundYPlus10 := ТемператураFoundY + 10
		Click, %ТемператураFoundXPlus10%, %ТемператураFoundYPlus10%
		ToolTip
		Sleep 500
		Send %Температура%
		Sleep 500
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Температура), 930, 1
		goto Температура_Found_LOOP
	}
}




ЗагальнийСтан_Found_LOOP: 
If Терапевт = 1						
{ 
	CoordMode, Pixel, Screen 
	ImageSearch, ЗагальнийСтанFoundX, ЗагальнийСтанFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ЗагальнийСтан.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЗагальнийСтанFoundXPlus10 := ЗагальнийСтанFoundX + 200
		ЗагальнийСтанFoundYPlus10 := ЗагальнийСтанFoundY + 10
		Click, %ЗагальнийСтанFoundXPlus10%, %ЗагальнийСтанFoundYPlus10%
		ToolTip
			Sleep 500
			Send задовільний
			Sleep 500
			Send {Enter}
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Загальний стан), 930, 1
		goto ЗагальнийСтан_Found_LOOP
	}
}


СвідомістьТ_Found_LOOP: 
If Терапевт = 1						
{ 
	CoordMode, Pixel, Screen 
	ImageSearch, СвідомістьТFoundX, СвідомістьТFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\СвідомістьТ.png
	if ErrorLevel = 0
	{
		Sleep 500
		СвідомістьТFoundXPlus10 := СвідомістьТFoundX + 200
		СвідомістьТFoundYPlus10 := СвідомістьТFoundY + 10
		Click, %СвідомістьТFoundXPlus10%, %СвідомістьТFoundYPlus10%
		ToolTip
			Sleep 500
			Send ясна
			Sleep 500
			Send {Enter}
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Свідомість Т), 930, 1
		goto СвідомістьТ_Found_LOOP
	}
}


Шкіра_Found_LOOP:
If Терапевт = 1						
{  
	CoordMode, Pixel, Screen 
	ImageSearch, ШкіраFoundX, ШкіраFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\Шкіра.png
	if ErrorLevel = 0
	{
		Sleep 500
		ШкіраFoundXPlus10 := ШкіраFoundX + 200
		ШкіраFoundYPlus10 := ШкіраFoundY + 10
		Click, %ШкіраFoundXPlus10%, %ШкіраFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Шкіра), 930, 1
		goto Шкіра_Found_LOOP
	}
}

ШкіраЧиста_Found_LOOP:
 If Терапевт = 1						
{ 
	CoordMode, Pixel, Screen 
	ImageSearch, ШкіраЧистаFoundX, ШкіраЧистаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ШкіраЧиста.png
	if ErrorLevel = 0
	{
		Sleep 500
		ШкіраЧистаFoundXPlus10 := ШкіраЧистаFoundX + 10
		ШкіраЧистаFoundYPlus10 := ШкіраЧистаFoundY + 10
		Click, %ШкіраЧистаFoundXPlus10%, %ШкіраЧистаFoundYPlus10%
		ToolTip
		
		Send {PgDn}

		Sleep 500
	
		Send {PgDn}

		Sleep 500
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Шкіра: Чиста), 930, 1
		goto ШкіраЧиста_Found_LOOP
	}
}


ГруднаКлітина_Found_LOOP: 
If Терапевт = 1						
{ 	
	CoordMode, Pixel, Screen 
	ImageSearch, ГруднаКлітинаFoundX, ГруднаКлітинаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ГруднаКлітина.png
	if ErrorLevel = 0
	{
		Sleep 500
		Click, %ГруднаКлітинаFoundX%, %ГруднаКлітинаFoundY%
		Sleep 500
		ГруднаКлітинаFoundXPlus10 := ГруднаКлітинаFoundX + 200
		ГруднаКлітинаFoundYPlus10 := ГруднаКлітинаFoundY + 10
		Click, %ГруднаКлітинаFoundXPlus10%, %ГруднаКлітинаFoundYPlus10%
		ToolTip
			Sleep 500
;			Send правильної форми
			Sleep 500
;			Send {Enter}
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Грудна Клітина), 930, 1
		goto ГруднаКлітина_Found_LOOP
	}
}

ПравильноїФорми_Found_LOOP: 
If Терапевт = 1						
{ 	
	CoordMode, Pixel, Screen 
	ImageSearch, ПравильноїФормиFoundX, ПравильноїФормиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПравильноїФорми.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПравильноїФормиFoundXPlus10 := ПравильноїФормиFoundX + 10
		ПравильноїФормиFoundYPlus10 := ПравильноїФормиFoundY + 10
		Click, %ПравильноїФормиFoundXPlus10%, %ПравильноїФормиFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Грудна клітина: Правильної Форми), 930, 1
		goto ПравильноїФорми_Found_LOOP
	}
}


АускНадЛегенями_Found_LOOP: 
If Терапевт = 1						
{ 	
	CoordMode, Pixel, Screen 
	ImageSearch, АускНадЛегенямиFoundX, АускНадЛегенямиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\АускНадЛегенями.png
	if ErrorLevel = 0
	{
		Sleep 500
		АускНадЛегенямиFoundXPlus10 := АускНадЛегенямиFoundX + 200
		АускНадЛегенямиFoundYPlus10 := АускНадЛегенямиFoundY + 10
		Click, %АускНадЛегенямиFoundXPlus10%, %АускНадЛегенямиFoundYPlus10%
		ToolTip
			Sleep 500
;			Send везикулярне
			Sleep 500
;			Send {Enter}
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Аускультативно Над Легенями), 930, 1
		goto АускНадЛегенями_Found_LOOP
	}
}	

Везикуляне_Found_LOOP: 
If Терапевт = 1						
{ 
	CoordMode, Pixel, Screen 
	ImageSearch, ВезикулянеFoundX, ВезикулянеFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Везикуляне.png
	if ErrorLevel = 0
	{
		Sleep 500
		ВезикулянеFoundXPlus10 := ВезикулянеFoundX + 10
		ВезикулянеFoundYPlus10 := ВезикулянеFoundY + 10
		Click, %ВезикулянеFoundXPlus10%, %ВезикулянеFoundYPlus10%
		ToolTip
		Sleep 500
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Везикуляне), 930, 1
		goto Везикуляне_Found_LOOP
	}
}

Тиск_Found_LOOP:
If Терапевт = 1						
{  
	CoordMode, Pixel, Screen 
	ImageSearch, ТискFoundX, ТискFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\Тиск.png
	if ErrorLevel = 0
	{
		Sleep 500
		ТискFoundXPlus10 := ТискFoundX + 200
		ТискFoundYPlus10 := ТискFoundY + 10
		Click, %ТискFoundXPlus10%, %ТискFoundYPlus10%
		ToolTip
		Sleep 500
		Send %Тиск%
		Sleep 500
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Тиск), 930, 1
		goto Тиск_Found_LOOP
	}
}


АускТониСерця_Found_LOOP: 
If Терапевт = 1						
{  
	CoordMode, Pixel, Screen 
	ImageSearch, АускТониСерцяFoundX, АускТониСерцяFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\АускТониСерця.png
	if ErrorLevel = 0
	{
		Sleep 500
		АускТониСерцяFoundXPlus10 := АускТониСерцяFoundX + 200
		АускТониСерцяFoundYPlus10 := АускТониСерцяFoundY + 10
		Click, %АускТониСерцяFoundXPlus10%, %АускТониСерцяFoundYPlus10%
		ToolTip
			Sleep 500
;			Send ясні
			Sleep 500
;			Send {Enter}

		Send {PgDn}

		Sleep 500
	
		Send {PgDn}

		Sleep 500
		
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (АускТониСерця), 930, 1
		goto АускТониСерця_Found_LOOP
	}
}	
	

Ясні_Found_LOOP: 
If Терапевт = 1						
{  
	CoordMode, Pixel, Screen 
	ImageSearch, ЯсніFoundX, ЯсніFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Ясні.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЯсніFoundXPlus10 := ЯсніFoundX + 10
		ЯсніFoundYPlus10 := ЯсніFoundY + 10
		Click, %ЯсніFoundXPlus10%, %ЯсніFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Ясні), 930, 1
		goto Ясні_Found_LOOP
	}
}

Живіт_Found_LOOP: 
If Терапевт = 1						
{  
	CoordMode, Pixel, Screen 
	ImageSearch, ЖивітFoundX, ЖивітFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\Живіт.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЖивітFoundXPlus10 := ЖивітFoundX + 300
		ЖивітFoundYPlus10 := ЖивітFoundY + 10
		Click, %ЖивітFoundXPlus10%, %ЖивітFoundYPlus10%
		ToolTip
			Sleep 500
;			Send безболісний
			Sleep 500
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Живіт), 930, 1
		goto Живіт_Found_LOOP
	}
}


Безболісний_Found_LOOP: 
If Терапевт = 1						
{  
	CoordMode, Pixel, Screen 
	ImageSearch, БезболіснийFoundX, БезболіснийFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Безболісний.png
	if ErrorLevel = 0
	{
		Sleep 500
		БезболіснийFoundXPlus10 := БезболіснийFoundX + 10
		БезболіснийFoundYPlus10 := БезболіснийFoundY + 10
		Click, %БезболіснийFoundXPlus10%, %БезболіснийFoundYPlus10%
		ToolTip
			Sleep 500	
;			Send +{TAB}
			Sleep 500	
;			Send м'який
			Sleep 500	
		Click, %ЖивітFoundXPlus10%, %ЖивітFoundYPlus10%
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Безболісний), 930, 1
		goto Безболісний_Found_LOOP
	}
}


Мякий_Found_LOOP:
If Терапевт = 1						
{   
	CoordMode, Pixel, Screen 
	ImageSearch, МякийFoundX, МякийFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Мякий.png
	if ErrorLevel = 0
	{
		Sleep 500
		МякийFoundXPlus10 := МякийFoundX + 10
		МякийFoundYPlus10 := МякийFoundY + 10
		Click, %МякийFoundXPlus10%, %МякийFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Мякий), 930, 1
		goto Мякий_Found_LOOP
	}
}









	Send {PgUp}
	Sleep 10
	Send {PgUp}
	Sleep 10

ЗавершитиПрийом_Found_LOOP: 
;goto ЗавершитиПрийом_Found_LOOP_Cancel

	Send {PgUp}
	Sleep 10
	Send {PgUp}
	Sleep 10
	
	CoordMode, Pixel, Screen 
	ImageSearch, ЗавершитиПрийомFoundX, ЗавершитиПрийомFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ЗавершитиПрийом.png
	if ErrorLevel = 0
	{
		Sleep 100
		ЗавершитиПрийомFoundXPlus10 := ЗавершитиПрийомFoundX + 10
		ЗавершитиПрийомFoundYPlus10 := ЗавершитиПрийомFoundY + 10
		Click, %ЗавершитиПрийомFoundXPlus10%, %ЗавершитиПрийомFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (ЗАВЕРШИТИ ПРИЙОМ), 930, 1
		goto ЗавершитиПрийом_Found_LOOP
	}

;ЗавершитиПрийом_Found_LOOP_Cancel:

If Підпис = 0
{
goto БезПідпису
}

Невизначено_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, НевизначеноFoundX, НевизначеноFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\Невизначено.png
	if ErrorLevel = 0
	{
		Sleep 500
;		НевизначеноFoundXPlus10 := НевизначеноFoundX + 10
;		НевизначеноFoundYPlus10 := НевизначеноFoundY + 10
;		Click, %НевизначеноFoundXPlus10%, %НевизначеноFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Невизначено), 930, 1
		goto Невизначено_Found_LOOP
	}




Обробка_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ОбробкаFoundX, ОбробкаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\Обробка.png
	if ErrorLevel = 0
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Обробка), 930, 1
		goto Обробка_Found_LOOP
	}
	else
	{
		Sleep 500
;		ОбробкаFoundXPlus10 := ОбробкаFoundX + 10
;		ОбробкаFoundYPlus10 := ОбробкаFoundY + 10
;		Click, %ОбробкаFoundXPlus10%, %ОбробкаFoundYPlus10%
		ToolTip
		
	}


ПІДПИСАТИ_attemptCount := 0  ; Инициализируем счетчик попыток

ПІДПИСАТИ_Found_LOOP:
	CoordMode, Pixel, Screen
	ImageSearch, ПІДПИСАТИFoundX, ПІДПИСАТИFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПІДПИСАТИ.png
	if ErrorLevel = 0
	{
		Sleep 1000
		ПІДПИСАТИFoundXPlus10 := ПІДПИСАТИFoundX + 50
		ПІДПИСАТИFoundYPlus10 := ПІДПИСАТИFoundY + 20
		Click, %ПІДПИСАТИFoundXPlus10%, %ПІДПИСАТИFoundYPlus10%
		ToolTip
		ПІДПИСАТИ_attemptCount := 0  ; Сбрасываем счетчик попыток при успешной попытке
		goto ПриватнийКлюч_Found_LOOP
	}
	else
	{
		ПІДПИСАТИ_attemptCount++  ; Увеличиваем счетчик попыток
		Sleep 1000
		if (ПІДПИСАТИ_attemptCount >= 5)
		{
			
			Send, {F5}  ; Нажимаем F5 после 3 неудачных попыток
			ПІДПИСАТИ_attemptCount := 0  ; Сбрасываем счетчик попыток
		}
		else
		{
			Sleep 500
			CoordMode, ToolTip, Screen
			ToolTip, Чекаю появу: (ПІДПИСАТИ), 930, 1
		}
	}
	goto ПІДПИСАТИ_Found_LOOP





ПриватнийКлюч_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПриватнийКлючFoundX, ПриватнийКлючFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПриватнийКлюч.png
	if ErrorLevel = 0
	{
		Sleep 2000
		ПриватнийКлючFoundXPlus10 := ПриватнийКлючFoundX + 10
		ПриватнийКлючFoundYPlus10 := ПриватнийКлючFoundY + 10
		Click, %ПриватнийКлючFoundXPlus10%, %ПриватнийКлючFoundYPlus10%
		ToolTip
		goto ключ
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Приватний Ключ), 930, 1
		goto АпаратнийКлюч_Found_LOOP
	}



;	Gui, PAUSE:Add, Button, section w300 h40 Center gАпаратнийКлюч_PAUSE_Button, АпаратнийКлюч

;АпаратнийКлюч_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto АпаратнийКлюч_Found_LOOP
;return



АпаратнийКлюч_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, АпаратнийКлючFoundX, АпаратнийКлючFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\АпаратнийКлюч.png
	if ErrorLevel = 0
	{
		Sleep 500
		АпаратнийКлючFoundXPlus10 := АпаратнийКлючFoundX + 10
		АпаратнийКлючFoundYPlus10 := АпаратнийКлючFoundY + 10
		;Click, %АпаратнийКлючFoundXPlus10%, %АпаратнийКлючFoundYPlus10%
		ToolTip
		Sleep 500
		;goto ПІДТВЕРДИТИ_Found_LOOP
		goto ЗчитатиКлюч_Found_LOOP 
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Апаратний Ключ), 930, 1
		goto ДоступКБиблиотеке_Found_LOOP
	}

;	Gui, PAUSE:Add, Button, xs w200 h40 Center gДоступКБиблиотеке_PAUSE_Button		, ДоступКБиблиотеке

;ДоступКБиблиотеке_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ДоступКБиблиотеке_Found_LOOP
;return

ДоступКБиблиотеке_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДоступКБиблиотекеFoundX, ДоступКБиблиотекеFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ДоступКБиблиотеке.png
	if ErrorLevel = 0
	{
		Sleep 500
		ДоступКБиблиотекеFoundXPlus10 := ДоступКБиблиотекеFoundX + 10
		ДоступКБиблиотекеFoundYPlus10 := ДоступКБиблиотекеFoundY + 10
		Click, %ДоступКБиблиотекеFoundXPlus10%, %ДоступКБиблиотекеFoundYPlus10%
		ToolTip
		Sleep 500
		goto ПриватнийКлюч_Found_LOOP
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Доступ к Библиотеке), 930, 1
		goto ПриватнийКлюч_Found_LOOP
	}



ключ:

Sleep 1000
Send ключ
Sleep 1000
Send {Down}
Sleep 500
Send {Enter}
Sleep 1000


ПарольДоКлюча_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПарольДоКлючаFoundX, ПарольДоКлючаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПарольДоКлюча.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПарольДоКлючаFoundXPlus10 := ПарольДоКлючаFoundX + 10
		ПарольДоКлючаFoundYPlus10 := ПарольДоКлючаFoundY + 10
		Click, %ПарольДоКлючаFoundXPlus10%, %ПарольДоКлючаFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Пароль до ключа), 930, 1
		goto ПарольДоКлюча_Found_LOOP
	}


Sleep 500
Send {Down}
Sleep 500
Send {Enter}
Sleep 500


ЗчитатиКлюч_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЗчитатиКлючFoundX, ЗчитатиКлючFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ЗчитатиКлюч.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЗчитатиКлючFoundXPlus10 := ЗчитатиКлючFoundX + 10
		ЗчитатиКлючFoundYPlus10 := ЗчитатиКлючFoundY + 10
		Click, %ЗчитатиКлючFoundXPlus10%, %ЗчитатиКлючFoundYPlus10%
		ToolTip
		Sleep 500
		goto ПІДТВЕРДИТИ_Found_LOOP
		
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Зчитати Ключ), 930, 1
		goto ЗчитатиКлюч_Found_LOOP
	}




ПІДТВЕРДИТИ_Found_LOOP:
	CoordMode, Pixel, Screen
	 ImageSearch, ПІДТВЕРДИТИFoundX, ПІДТВЕРДИТИFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ПІДТВЕРДИТИ.png
	 if ErrorLevel = 0
	 {
		 Sleep 500
		 ПІДТВЕРДИТИFoundXPlus10 := ПІДТВЕРДИТИFoundX + 30
		 ПІДТВЕРДИТИFoundYPlus10 := ПІДТВЕРДИТИFoundY + 30
		 Click, %ПІДТВЕРДИТИFoundXPlus10%, %ПІДТВЕРДИТИFoundYPlus10%
		 ToolTip
	 }
	 else
	 {
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (ПІДТВЕРДИТИ), 930, 1
		goto ПІДТВЕРДИТИ_Found_LOOP
	 }


Sleep 500

goto ПропускОброблено

Оброблено_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ОбробленоFoundX, ОбробленоFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\Оброблено.png
	if ErrorLevel = 0
	{
		Sleep 500
		ОбробленоFoundXPlus10 := ОбробленоFoundX + 10
		ОбробленоFoundYPlus10 := ОбробленоFoundY + 10
		Click, %ОбробленоFoundXPlus10%, %ОбробленоFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Оброблено), 930, 1
		goto Оброблено_Found_LOOP
	}


ПропускОброблено:


SB_SetParts(300)
SB_SetText(Прізвище . " " . Імя . " " . Датанародження " введено", 2)


;Send, ^{w}

БезПідпису:

		
If ДРУК = 1
{
goto Друкувати
}
else
{
goto ScriptEnd
}


Друкувати?:
		
MsgBox, 4,, Друкувати?
IfMsgBox Yes
{
    goto Друкувати
}
else
	Sleep 100
	goto ScriptEnd



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gРезультатПрийому_PAUSE_Button		, РезультатПрийому

;РезультатПрийому_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto РезультатПрийому_Found_LOOP
;return


РезультатПрийому_Found_LOOP: 

If РежимДрукуРезультатаПрийому = 1
{
	CoordMode, Pixel, Screen 
	ImageSearch, РезультатПрийомуFoundX, РезультатПрийомуFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\РезультатПрийому.png
	if ErrorLevel = 0
	{
		Sleep 500
		РезультатПрийомуFoundXPlus10 := РезультатПрийомуFoundX + 30
		РезультатПрийомуFoundYPlus10 := РезультатПрийомуFoundY + 30
		Click, %РезультатПрийомуFoundXPlus10%, %РезультатПрийомуFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Результат прийому), 930, 1
		goto РезультатПрийому_Found_LOOP
	}
}
else
{
goto ScriptEnd
}



Друкувати:

ГалочкаДодатиДоДруку_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ГалочкаДодатиДоДрукуFoundX, ГалочкаДодатиДоДрукуFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ГалочкаДодатиДоДруку.png
	if ErrorLevel = 0
	{
		Sleep 500
		ГалочкаДодатиДоДрукуFoundXPlus10 := ГалочкаДодатиДоДрукуFoundX + 30
		ГалочкаДодатиДоДрукуFoundYPlus10 := ГалочкаДодатиДоДрукуFoundY + 30
		Click, %ГалочкаДодатиДоДрукуFoundXPlus10%, %ГалочкаДодатиДоДрукуFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Галочка Додати до друку), 930, 1
		goto ГалочкаДодатиДоДруку_Found_LOOP
	}



Друк_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДрукFoundX, ДрукFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Друк.png
	if ErrorLevel = 0
	{
		Sleep 500
		ДрукFoundXPlus10 := ДрукFoundX + 10
		ДрукFoundYPlus10 := ДрукFoundY + 10
		Click, %ДрукFoundXPlus10%, %ДрукFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (ДРУК), 930, 1
		goto Друк_Found_LOOP
	}



ЗначокПринтера_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЗначокПринтераFoundX, ЗначокПринтераFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ЗначокПринтера.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЗначокПринтераFoundXPlus10 := ЗначокПринтераFoundX + 10
		ЗначокПринтераFoundYPlus10 := ЗначокПринтераFoundY + 10
		Click, %ЗначокПринтераFoundXPlus10%, %ЗначокПринтераFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Значок Принтера), 930, 1
		goto ЗначокПринтера_Found_LOOP
	}


Печать_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПечатьFoundX, ПечатьFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Печать.png
	if ErrorLevel = 0
	{
		Sleep 500
		ПечатьFoundXPlus10 := ПечатьFoundX + 10
		ПечатьFoundYPlus10 := ПечатьFoundY + 10
		Click, %ПечатьFoundXPlus10%, %ПечатьFoundYPlus10%
		ToolTip
		Sleep 500
		Send ^w
		Sleep 500
		Send ^w
		Sleep 1000
;		Send {F3}
		Sleep 500
		If РежимДрукуРезультатаПрийому = 0
		{
		Send {F1}
		}
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Печать), 930, 1
		goto Печать_Found_LOOP
	}

If РежимДрукуРезультатаПрийому = 1
{
goto РезультатПрийому_Found_LOOP
}


Sleep 500

ScriptEnd:

	
		SoundBeep, 523, 100
		SoundBeep, 784, 100
		

Send {F1}
Sleep 1000

	if (Діагноз1 != "Здоровий") 
		{
	return
		}
	else
		{
			goto Function6
		}
		
return




F8::

РежимДрукуРезультатаПрийому := 1
goto РезультатПрийому_Found_LOOP

return



F11::
Gui, MIA:Submit

Run, msedge.exe "https://doctor.health.mia.software/"


;	Gui, PAUSE:Add, Button, xs w200 h40 Center gГоловна_PAUSE_Button		, Головна

;Головна_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto Головна_Found_LOOP
;return

;Головна_Found_LOOP: 
;	CoordMode, Pixel, Screen 
;	ImageSearch, ГоловнаFoundX, ГоловнаFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\Головна.png
;	if ErrorLevel = 0
;	{
;		Sleep 500
;		ГоловнаFoundXPlus10 := ГоловнаFoundX + 10
;		ГоловнаFoundYPlus10 := ГоловнаFoundY + 10
;		;Click, %ГоловнаFoundXPlus10%, %ГоловнаFoundYPlus10%
;		ToolTip
;	}
;	else
;	{
;		Sleep 500
;		CoordMode, ToolTip, Screen
;		ToolTip, Чекаю появу: (Головна), 930, 1
;		goto Головна_Found_LOOP
;	}


Send PgDn
Sleep 100

Send PgDn
Sleep 100

Send PgDn
Sleep 100



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gАктивний_PAUSE_Button		, Активний

;Активний_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto Активний_Found_LOOP
;return

;Активний_Found_LOOP: 
;	CoordMode, Pixel, Screen 
;	ImageSearch, АктивнийFoundX, АктивнийFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Активний.png
;	if ErrorLevel = 0
;	{
;		Sleep 500
;		АктивнийFoundXPlus10 := АктивнийFoundX + 10
;		АктивнийFoundYPlus10 := АктивнийFoundY + 10
;		Click, %АктивнийFoundXPlus10%, %АктивнийFoundYPlus10%
;		ToolTip
;	}
;	else
;	{
;		Sleep 500
;		CoordMode, ToolTip, Screen
;		ToolTip, Чекаю появу: (Активний), 930, 1
;		goto Активний_Found_LOOP
;	}

return







F10::
Gui, MIA:Submit



Sleep 100
Send {PgDn}
Sleep 100

Send {PgDn}
Sleep 100

Send {PgDn}
Sleep 100

Send {PgDn}
Sleep 100



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gІсторіяЗначок_PAUSE_Button		, ІсторіяЗначок

;ІсторіяЗначок_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ІсторіяЗначок_Found_LOOP
;return

;ІсторіяЗначок_Found_LOOP: 
;	CoordMode, Pixel, Screen 
;	ImageSearch, ІсторіяЗначокFoundX, ІсторіяЗначокFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\ІсторіяЗначок.png
;	if ErrorLevel = 0
;	{
;		Sleep 500
;		ІсторіяЗначокFoundXPlus10 := ІсторіяЗначокFoundX + 10
;		ІсторіяЗначокFoundYPlus10 := ІсторіяЗначокFoundY + 10
;		Click, %ІсторіяЗначокFoundXPlus10%, %ІсторіяЗначокFoundYPlus10%
;		ToolTip
;	}
;	else
;	{
;		Sleep 500
;		CoordMode, ToolTip, Screen
;		ToolTip, Чекаю появу: (Історія Значок), 930, 1
;		goto ІсторіяЗначок_Found_LOOP
;	}
	
Sleep 100
Send {PgUp}
Sleep 100


;	Gui, PAUSE:Add, Button, xs w200 h40 Center gФільтри_PAUSE_Button		, Фільтри

;Фільтри_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto Фільтри_Found_LOOP
;return

Фільтри_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ФільтриFoundX, ФільтриFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Фільтри.png
	if ErrorLevel = 0
	{
		Sleep 1000
		ФільтриFoundXPlus10 := ФільтриFoundX + 10
		ФільтриFoundYPlus10 := ФільтриFoundY + 10
		Click, %ФільтриFoundXPlus10%, %ФільтриFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Фільтри), 930, 1
		goto Фільтри_Found_LOOP
	}



;	Gui, PAUSE:Add, Button, xs w200 h40 Center gЛікарФільтр_PAUSE_Button		, ЛікарФільтр

;ЛікарФільтр_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto ЛікарФільтр_Found_LOOP
;return

ЛікарФільтр_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЛікарФільтрFoundX, ЛікарФільтрFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Поля\ЛікарФільтр.png
	if ErrorLevel = 0
	{
		Sleep 1000
		ЛікарФільтрFoundXPlus10 := ЛікарФільтрFoundX + 400
		ЛікарФільтрFoundYPlus10 := ЛікарФільтрFoundY + 10
		Click, %ЛікарФільтрFoundXPlus10%, %ЛікарФільтрFoundYPlus10%
		ToolTip
		Send Арнаутов
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Лікар Фільтр), 930, 1
		goto ЛікарФільтр_Found_LOOP
	}


;	Gui, PAUSE:Add, Button, xs w200 h40 Center gАрнаутовВА_PAUSE_Button		, АрнаутовВА

;АрнаутовВА_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto АрнаутовВА_Found_LOOP
;return

АрнаутовВА_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, АрнаутовВАFoundX, АрнаутовВАFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\АрнаутовВА.png
	if ErrorLevel = 0
	{
		Sleep 1000
		АрнаутовВАFoundXPlus10 := АрнаутовВАFoundX + 10
		АрнаутовВАFoundYPlus10 := АрнаутовВАFoundY + 10
		Click, %АрнаутовВАFoundXPlus10%, %АрнаутовВАFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Арнаутов В.А.), 930, 1
		goto АрнаутовВА_Found_LOOP
	}


;	Gui, PAUSE:Add, Button, xs w200 h40 Center gЗастосувати_PAUSE_Button		, Застосувати

;Застосувати_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto Застосувати_Found_LOOP
;return

Застосувати_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ЗастосуватиFoundX, ЗастосуватиFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Застосувати.png
	if ErrorLevel = 0
	{
		Sleep 500
		ЗастосуватиFoundXPlus10 := ЗастосуватиFoundX + 10
		ЗастосуватиFoundYPlus10 := ЗастосуватиFoundY + 10
		Click, %ЗастосуватиFoundXPlus10%, %ЗастосуватиFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Застосувати), 930, 1
		goto Застосувати_Found_LOOP
	}
	
Sleep 1000
Send {PgDn}
Sleep 100
Sleep 100
Send {PgDn}
Sleep 1000






;	Gui, PAUSE:Add, Button, xs w200 h40 Center gПерегляд_PAUSE_Button		, Перегляд

;Перегляд_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto Перегляд_Found_LOOP
;return

Перегляд_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ПереглядFoundX, ПереглядFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\Перегляд.png
	if ErrorLevel = 0
	{
		Sleep 100
		ПереглядFoundXPlus10 := ПереглядFoundX + 10
		ПереглядFoundYPlus10 := ПереглядFoundY + 10
		Click, %ПереглядFoundXPlus10%, %ПереглядFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Перегляд), 930, 1
		goto Перегляд_Found_LOOP
	}

Sleep 1000

;	Gui, PAUSE:Add, Button, xs w200 h40 Center gНормауРезультаті_PAUSE_Button		, НормауРезультаті

;НормауРезультаті_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto НормауРезультаті_Found_LOOP
;return

НормауРезультаті_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, НормауРезультатіFoundX, НормауРезультатіFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\НормауРезультаті.png
	if ErrorLevel = 0
	{
		Sleep 500
		НормауРезультатіFoundXPlus10 := НормауРезультатіFoundX + 10
		НормауРезультатіFoundYPlus10 := НормауРезультатіFoundY + 10
		Click, %НормауРезультатіFoundXPlus10%, %НормауРезультатіFoundYPlus10%
		ToolTip
		Msgbox Норма
	}
	else
	{
		Sleep 500
		CoordMode, ToolTip, Screen
		ToolTip, Чекаю появу: (Норма у Результаті), 930, 1
		goto НормауРезультаті_Found_LOOP
	}









return



F9::
Function9:

Iteration := 0
Goto, ProcessRow

ProcessRow:
    Iteration++
    if (Iteration > 50)
    {
		SoundBeep, 523
		SoundBeep, 523
		SoundBeep, 523
		
        MsgBox, Лишилось вкладок: %RowCount%`nДалі?
        goto Function9
    }

 ;   RowCount := LV_GetCount()
    if (RowCount = 0)
    {
        SoundBeep, 523, 100 ;ccge
		SoundBeep, 523, 100
		SoundBeep, 784, 100
		SoundBeep, 659, 100
		
        Exit
    }
    else
    {
 
 
F6continue := 1


;	Gui, PAUSE:Add, Button, xs w200 h40 Center gIDуІнтерфейсі_PAUSE_Button		, IDуІнтерфейсі

;IDуІнтерфейсі_PAUSE_Button:
;	SoundBeep, 900
;	Gui, PAUSE:Submit
;	goto IDуІнтерфейсі_Found_LOOP
;return

IDуІнтерфейсі_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, IDуІнтерфейсіFoundX, IDуІнтерфейсіFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Кнопки\IDуІнтерфейсі.png
	if ErrorLevel = 0
	{
		Sleep 100
		IDуІнтерфейсіFoundXPlus10 := IDуІнтерфейсіFoundX + 50
		IDуІнтерфейсіFoundYPlus10 := IDуІнтерфейсіFoundY + 40
		Click, %IDуІнтерфейсіFoundXPlus10%, %IDуІнтерфейсіFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 100
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (ID у Інтерфейсі), 930, 1
		goto IDуІнтерфейсі_Found_LOOP
	}


goto ПереміститиКнопка_Found_LOOP
    }
	
BackToF9:

	AppointmentID := ID
	Run, msedge.exe "https://doctor.health.mia.software/appointment/%AppointmentID%/?tab=history"
Sleep 100


Деталі_Found_LOOP: 
	CoordMode, Pixel, Screen 
	ImageSearch, ДеталіFoundX, ДеталіFoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *10 %A_ScriptDir%\Унікальні значки\Деталі.png
	if ErrorLevel = 0
	{
		Sleep 10
		ДеталіFoundXPlus10 := ДеталіFoundX + 10
		ДеталіFoundYPlus10 := ДеталіFoundY + 10
		Click, %ДеталіFoundXPlus10%, %ДеталіFoundYPlus10%
		ToolTip
	}
	else
	{
		Sleep 10
		CoordMode, ToolTip, Screen
		ToolTip, Поточна кнопка: (Деталі), 930, 1
		goto Деталі_Found_LOOP
	}
	
Sleep 100
Send {End}
Sleep 10
Send {End}
Sleep 10
Send {End}

Sleep 1000
Send {F1}


        Goto, ProcessRow

 

    	SoundBeep, 523
		SoundBeep, 523
		SoundBeep, 523
    ; Отображаем прогресс в MsgBox и спрашиваем продолжить ли
    MsgBox, 4,  Лишилось вкладок: %RowCount%`nДалі?
    IfMsgBox, Yes
        goto Function9
    else
        Exit









return


FILLButtonОбєктивно:
Gui, FILL:Submit
	Sleep 500
	Send ^c
	Sleep 500
	
	originalUrl := Clipboard
	StringSplit, parts, originalUrl, /
	newUrl := parts1 "/" parts2 "/" parts3 "/" parts4 "/" parts5 "/?tab=history/#history"
	Sleep 500
	Send ^w
	Run, msedge.exe %newUrl%


return



FILLButtonЕпізоди:
Gui, FILL:Submit

return




NumpadAdd::

send {Enter}
Sleep 500
send {F6}

return




return









