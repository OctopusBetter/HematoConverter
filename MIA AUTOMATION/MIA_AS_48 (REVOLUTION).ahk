#NoEnv
#SingleInstance force
#Persistent
SendMode Input

;=================================================================
; Интерфейс
;=================================================================
Gui, MIA:Font, S10 CDefault, Arial

; Поля ввода с привязкой gCheckFields
Gui, MIA:Add, Edit, Left w100 section vID gCheckFields,
Gui, MIA:Add, Edit, Left w200 ys vПрізвище gCheckFields,
Gui, MIA:Add, Edit, Left w200 ys vІмя gCheckFields,
Gui, MIA:Add, Edit, Left w100 ys vДатанародження gCheckFields, dd.MM.yyyy

; Кнопки управления
Gui, MIA:Add, Button, Center h30 w100 section xs gDeleteAllRows, ❌ ВСЕ
Gui, MIA:Add, Button, Center h30 w100 ys gFunction6, START
Gui, MIA:Add, Button, Center h30 w50 ys Default vДОДАТИ gAddToListView, 🔻
Gui, MIA:Add, Button, Center h30 w50 ys gПереміститиНаПоля, 🔺




; Статусная строка и прогресс-бар
Gui, MIA:Add, StatusBar,
Gui, MIA:Add, Progress, h10 w760 section xs vMyProgress

; ListView с данными – изменён заголовок: первый столбец – галочка (✅), второй – ID
Gui, MIA:Add, ListView, h670 w660 xs Checked Grid vOft_ListView gDeleteSelectedRow, ✅|ID|Прізвище|Імя|Дата|VisOD|VisOS

; Элементы для работы с Excel
Gui, MIA:Add, Edit, w220 section xs Center vНазваФайлуДляЗбереження,
Gui, MIA:Add, Button, w60 ys Center gЗберегтиСписок, SAVE
Gui, MIA:Add, DropDownList, Left w105 ys vOpenFileChoice, МедичнийОгляд|ЗбереженийСписок
Gui, MIA:Add, Button, w230 ys Center gЗавантажитиСписок, OPEN

GuiControl, MIA:Choose, OpenFileChoice, 1
Gui, Submit, NoHide
gosub OpenFileChoice

; Элементы для выбора врача и диагностики
Gui, MIA:Font, S10 CDefault, Arial
Gui, MIA:Add, Text, Left w100 section ys ym x+20, Дата огляду:
Gui, MIA:Add, Text, Left w200 ys , Лікар:
Gui, MIA:Add, Text, Left w250 ys, Шаблон огляду:
Gui, MIA:Add, Button, Center ys  w100 gСобратьVISUS, VISUS
Gui, MIA:Add, Button, Center ys  w100 gОбновитьДиагноз, Діагноз

Gui, MIA:Font, S15 CDefault, Arial
Gui, MIA:Add, Edit, Center w100 h35 section xs vДатаПфОгляду Limit10 gCheckFields,
Gui, MIA:Add, ComboBox, Left w200 ys vЛікарChoice gЛікарChoice, Офтальмолог|Невролог|Терапевт|Психофізіолог
Gui, MIA:Add, ComboBox, Left w350 ys vШаблонОгляду



Gui, MIA:Add, Button, Center w35 h35 ys vBtnLoad   gШаблонLoad,   ✅
Gui, MIA:Add, Button, Center w35 h35 ys vBtnSave   gШаблонSave,   💾
Gui, MIA:Add, Button, Center w35 h35 ys vBtnDelete gШаблонDelete, 🗑️


GuiControl, MIA:Choose, ЛікарChoice, 1
gosub ЛікарChoice

Gui, MIA:Font, S12 CDefault, Arial
;Gui, MIA:Add, Text, Right w90 section xs, Обєктивно:
;Gui, MIA:Add, Text, Right w90 ys, Додатково:
;Gui, MIA:Add, CheckBox, Left w200 ys vПаузаНаVisus, Пауза на Visus

Gui, MIA:Add, Text, Right w90 section xs, Visus OD =
Gui, MIA:Add, ComboBox, Center w60 ys vVisusOD, 1.0|0.9|0.8|0.7|0.6|0.5|0.4|0.3|0.2|0.1|0.09|0.08|0.07|0.06|0.05|0.04|0.03|0.02|0.01
GuiControl, MIA:Choose, VisusOD, 1
Gui, MIA:Add, Button, Center w30 ys gSetVisusODto09, 0.9
Gui, MIA:Add, CheckBox, Center w30 ys gWithCorrOD vWithCorrOD Check3,
Gui, MIA:Add, Text, Center w30 ys vSphOD_text,
Gui, MIA:Add, ComboBox, Center w60 ys vSphOD, +6.0|+5.75|+5.5|+5.25|+5.0|+4.75|+4.5|+4.25|+4.0|+3.75|+3.5|+3.25|+3.0|+2.75|+2.5|+2.25|+2.0|+1.75|+1.5|+1.25|+1.0|+0.75|+0.5|+0.25|0.0|-0.25|-0.5|-0.75|-1.0|-1.25|-1.5|-1.75|-2.0|-2.25|-2.5|-2.75|-3.0|-3.25|-3.5|-3.75|-4.0|-4.25|-4.5|-4.75|-5.0|-5.25|-5.5|-5.75|-6.0
GuiControl, MIA:Choose, SphOD, 25

Gui, MIA:Add, Text, Left w50 ys vCylOD_text, D CYL
Gui, MIA:Add, ComboBox, Center w60 ys vCylOD, +6.0|+5.75|+5.5|+5.25|+5.0|+4.75|+4.5|+4.25|+4.0|+3.75|+3.5|+3.25|+3.0|+2.75|+2.5|+2.25|+2.0|+1.75|+1.5|+1.25|+1.0|+0.75|+0.5|+0.25|0.0|-0.25|-0.5|-0.75|-1.0|-1.25|-1.5|-1.75|-2.0|-2.25|-2.5|-2.75|-3.0|-3.25|-3.5|-3.75|-4.0|-4.25|-4.5|-4.75|-5.0|-5.25|-5.5|-5.75|-6.0
GuiControl, MIA:Choose, CylOD, 25

Gui, MIA:Add, Text, Center w30 ys vAxOD_text, D (
Gui, MIA:Add, Edit, Center w50 ys number Limit3 vAxOD,
Gui, MIA:Add, Text, Left w30 ys vVisusCorrOD_text, ) =
Gui, MIA:Add, ComboBox, Center w60 ys vVisusCorrOD, 1.0|0.9|0.8|0.7|0.6|0.5|0.4|0.3|0.2|0.1|0.09|0.08|0.07|0.06|0.05|0.04|0.03|0.02|0.01
GuiControl, MIA:Choose, VisusCorrOD, 1

Gui, MIA:Add, Text, Right w90 section xs, Visus OS =
Gui, MIA:Add, ComboBox, Center w60 ys vVisusOS, 1.0|0.9|0.8|0.7|0.6|0.5|0.4|0.3|0.2|0.1|0.09|0.08|0.07|0.06|0.05|0.04|0.03|0.02|0.01
GuiControl, MIA:Choose, VisusOS, 1
Gui, MIA:Add, Button, Center w30 ys gSetVisusOSto09, 0.9

Gui, MIA:Add, CheckBox, Center w30 ys gWithCorrOS vWithCorrOS Check3,
Gui, MIA:Add, Text, Center w30 ys vSphOS_text,
Gui, MIA:Add, ComboBox, Center w60 ys vSphOS, +6.0|+5.75|+5.5|+5.25|+5.0|+4.75|+4.5|+4.25|+4.0|+3.75|+3.5|+3.25|+3.0|+2.75|+2.5|+2.25|+2.0|+1.75|+1.5|+1.25|+1.0|+0.75|+0.5|+0.25|0.0|-0.25|-0.5|-0.75|-1.0|-1.25|-1.5|-1.75|-2.0|-2.25|-2.5|-2.75|-3.0|-3.25|-3.5|-3.75|-4.0|-4.25|-4.5|-4.75|-5.0|-5.25|-5.5|-5.75|-6.0
GuiControl, MIA:Choose, SphOS, 25

Gui, MIA:Add, Text, Left w50 ys vCylOS_text, D CYL
Gui, MIA:Add, ComboBox, Center w60 ys vCylOS, +6.0|+5.75|+5.5|+5.25|+5.0|+4.75|+4.5|+4.25|+4.0|+3.75|+3.5|+3.25|+3.0|+2.75|+2.5|+2.25|+2.0|+1.75|+1.5|+1.25|+1.0|+0.75|+0.5|+0.25|0.0|-0.25|-0.5|-0.75|-1.0|-1.25|-1.5|-1.75|-2.0|-2.25|-2.5|-2.75|-3.0|-3.25|-3.5|-3.75|-4.0|-4.25|-4.5|-4.75|-5.0|-5.25|-5.5|-5.75|-6.0
GuiControl, MIA:Choose, CylOS, 25

Gui, MIA:Add, Text, Center w30 ys vAxOS_text, D (
Gui, MIA:Add, Edit, Center w50 ys number Limit3 vAxOS,
Gui, MIA:Add, Text, Left w30 ys vVisusCorrOS_text, ) =
Gui, MIA:Add, ComboBox, Center w60 ys vVisusCorrOS, 1.0|0.9|0.8|0.7|0.6|0.5|0.4|0.3|0.2|0.1|0.09|0.08|0.07|0.06|0.05|0.04|0.03|0.02|0.01
GuiControl, MIA:Choose, VisusCorrOS, 1

Gui, MIA:Add, Edit, Left w810 section xs R3 vЗібрано_Обєктивно,
;Gui, MIA:Add, Text, Right w90 section xs, Епізод:




Gui, MIA:Font, S8 CDefault, Arial

Gui, MIA:Add, Text, Right w90 h25 section xs, Основний`n Діагноз:
Gui, MIA:Add, Edit, Left w720 h25 ys vОсновний_Діагноз,
;Gui, MIA:Add, DropDownList, Left w100 ys vСтупінь_Основного_Діагнозу, |Слабка|Середня|Висока
Gui, MIA:Add, Text, Right w90 h25 section xs, Коментар:
Gui, MIA:Add, Edit, Left w720 h25 ys vКоментар_Основного_Діагнозу,

Gui, MIA:Add, Text, Right w90 h25 section xs, Супутній`n Діагноз 1:
Gui, MIA:Add, Edit, Left w720 h25 ys vСупутній_Діагноз_1,
;Gui, MIA:Add, DropDownList, Left w100 ys vСтупінь_Супутнього_Діагнозу_1, |Слабка|Середня|Висока
Gui, MIA:Add, Text, Right w90 h25 section xs, Коментар:
Gui, MIA:Add, Edit, Left w720 h25 ys vКоментар_Супутнього_Діагнозу_1,

Gui, MIA:Add, Text, Right w90 h25 section xs, Супутній`n Діагноз 2:
Gui, MIA:Add, Edit, Left w720 h25 ys vСупутній_Діагноз_2,
;Gui, MIA:Add, DropDownList, Left w100 ys vСтупінь_Супутнього_Діагнозу_2, |Слабка|Середня|Висока
Gui, MIA:Add, Text, Right w90 h25 section xs, Коментар:
Gui, MIA:Add, Edit, Left w720 h25 ys vКоментар_Супутнього_Діагнозу_2,

Gui, MIA:Add, Text, Right w90 h25 section xs, Супутній`n Діагноз 3:
Gui, MIA:Add, Edit, Left w720 h25 ys vСупутній_Діагноз_3,
;Gui, MIA:Add, DropDownList, Left w100 ys vСтупінь_Супутнього_Діагнозу_3, |Слабка|Середня|Висока
Gui, MIA:Add, Text, Right w90 h25 section xs, Коментар:
Gui, MIA:Add, Edit, Left w720 h25 ys vКоментар_Супутнього_Діагнозу_3,

Gui, MIA:Add, Text, Right w90 h25 section xs, Супутній`n Діагноз 4:
Gui, MIA:Add, Edit, Left w720 h25 ys vСупутній_Діагноз_4,
;Gui, MIA:Add, DropDownList, Left w100 ys vСтупінь_Супутнього_Діагнозу_4, |Слабка|Середня|Висока
Gui, MIA:Add, Text, Right w90 h25 section xs, Коментар:
Gui, MIA:Add, Edit, Left w720 h25 ys vКоментар_Супутнього_Діагнозу_4,

Gui, MIA:Add, Text, Right w90 h25 section xs, Супутній`n Діагноз 5:
Gui, MIA:Add, Edit, Left w720 h25 ys vСупутній_Діагноз_5,
;Gui, MIA:Add, DropDownList, Left w100 ys vСтупінь_Супутнього_Діагнозу_5, |Слабка|Середня|Висока
Gui, MIA:Add, Text, Right w90 h25 section xs, Коментар:
Gui, MIA:Add, Edit, Left w720 h25 ys vКоментар_Супутнього_Діагнозу_5,

Gui, MIA:Add, Text, Right w90 section xs, Причини`n звернення:
Gui, MIA:Add, Edit, Left w720 ys vПричини_Звернення,
Gui, MIA:Add, Text, Right w90 section xs, Дія:
Gui, MIA:Add, Edit, Left w250 ys vДія,
Gui, MIA:Add, Text, Right w90 ys, Коментар дії:
Gui, MIA:Add, Edit, Left w250 ys vКоментарДії,
Gui, MIA:Add, Text, Right w90 section xs, Заключення:
Gui, MIA:Add, Edit, Left w720 ys vПоле_Заключення R2,

Gui, MIA:Add, Text, Right w90 section xs vРекомендації, Рекомендації:
Gui, MIA:Add, Edit, Left w720 ys vПоле_Рекомендацій R2,

Gui, MIA:Font, S18 CDefault, Arial

; Вызов проверки полей
gosub CheckFields

; Скрываем корректирующие поля (пока не используются)
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


return


PopulateTemplates() {
    items := ""
    Loop, Files, %A_ScriptDir%\ШАБЛОНИ\*.ini
    {
        name := RegExReplace(A_LoopFileName, "\.ini$")
        items .= (items ? "|" : "") name
    }
    Gui, MIA:Default
    GuiControl,, ШаблонОгляду, |%items%
    if (items)
        GuiControl, Choose, ШаблонОгляду, 1
}

LogStatusBar(message) {
    FormatTime, timestamp, %A_Now%, dd.MM.yyyy HH:mm:ss
    logLine := timestamp . " | " . message . "`n"
    FileAppend, %logLine%, %A_ScriptDir%\_log_statusbar.txt
}


;=================================================================
; Инициализация и горячие клавиши
;=================================================================
F1::
    SetTimer, CheckLanguage, 1000
    Send, #d
    Sleep, 100
    Прізвище =
    GuiControl, MIA:, Прізвище, %Прізвище%
    Імя =
    GuiControl, MIA:, Імя, %Імя%
    Датанародження =
    GuiControl, MIA:, Датанародження, %Датанародження%
    VisusOD = 1.0
    GuiControl, MIA:, VisusOD, 1.0
    VisusOS = 1.0
    GuiControl, MIA:, VisusOS, 1.0
    VisusCorrOD = 1.0
    GuiControl, MIA:, VisusCorrOD, 1.0
    VisusCorrOS = 1.0
    GuiControl, MIA:, VisusCorrOS, 1.0
    GuiControl, MIA:Focus, Прізвище
    SysGet, ScreenWidth, 0
    SysGet, ScreenHeight, 1
    OnMessage(0x100, "KeyPressed")
		PopulateTemplates()
	Gui, MIA:+MaximizeBox +DPIScale
    Gui, MIA:Show, Maximize

return





ШаблонLoad:
Gui, Submit, NoHide
tpl := ШаблонОгляду
if (tpl = "") {
    SB_SetText("Не обрано шаблон для завантаження!", 2)
	LogStatusBar("Не обрано шаблон для завантаження!")
    return
}

filename := A_ScriptDir . "\ШАБЛОНИ\" . tpl . ".ini"
if !FileExist(filename) {
    SB_SetText("Файл шаблону не знайдено!", 2)
	LogStatusBar("Файл шаблону не знайдено!")
    return
}

FileRead, content, %filename%
if ErrorLevel {
    SB_SetText("Помилка читання файлу шаблону!", 2)
	LogStatusBar("Помилка читання файлу шаблону!")
    return
}

Loop, Parse, content, `n, `r
{
    line := A_LoopField
    if RegExMatch(line, "^\s*\[.*\]\s*$")
        continue
    if !RegExMatch(line, "^\s*([^=]+)=(.*)$", m)
        continue

    field := Trim(m1)
    value := Trim(m2)
    value := StrReplace(value, "\n", "`n")  ; восстанавливаем перенос строки
    value := StrReplace(value, "->", "→")

    if field in VisusOD,VisusOS,VisusCorrOD,VisusCorrOS,SphOD,SphOS,CylOD,CylOS
        GuiControl, MIA:Choose, %field%, %value%
    else
        GuiControl,, %field%, %value%
}

gosub WithCorrOD
gosub WithCorrOS

ControlGetPos, bx, by, bw, bh,, ahk_class AutoHotkeyGUI
ToolTip, Шаблон «%tpl%» завантажено!, %bx%, % by + bh + 10, LoadTip
SetTimer, RemoveLoadTip, -1500
SB_SetText("Шаблон «" tpl "» успішно завантажений", 1)
LogStatusBar("Шаблон «" tpl "» успішно завантажений")
return

RemoveLoadTip:
    ToolTip,, LoadTip
return








ШаблонSave:
Gui, Submit, NoHide
tpl := ШаблонОгляду
if (tpl = "")
    return

filename := A_ScriptDir "\ШАБЛОНИ\" tpl ".ini"
FileDelete, %filename%

content := ""
fields := ["Прізвище","Імя","Датанародження"
          ,"ДатаПфОгляду"
          ,"Зібрано_Обєктивно"
          ,"Основний_Діагноз","Коментар_Основного_Діагнозу"
          ,"Супутній_Діагноз_1","Коментар_Супутнього_Діагнозу_1"
          ,"Супутній_Діагноз_2","Коментар_Супутнього_Діагнозу_2"
          ,"Супутній_Діагноз_3","Коментар_Супутнього_Діагнозу_3"
          ,"Супутній_Діагноз_4","Коментар_Супутнього_Діагнозу_4"
          ,"Супутній_Діагноз_5","Коментар_Супутнього_Діагнозу_5"
          ,"Причини_Звернення","Дія"
          ,"Поле_Заключення","Поле_Рекомендацій"]

for _, key in fields {
    GuiControlGet, val,, %key%
    val := StrReplace(val, "`n", "\n")
    val := StrReplace(val, "→", "->")
    content .= key "=" val "`n"
}

; Затем идут технические поля, строго в том же порядке как визуально
GuiControlGet, idxVisusOD,, VisusOD
GuiControlGet, idxVisusOS,, VisusOS
GuiControlGet, idxVisusCorrOD,, VisusCorrOD
GuiControlGet, idxVisusCorrOS,, VisusCorrOS
GuiControlGet, idxSphOD,, SphOD
GuiControlGet, idxSphOS,, SphOS
GuiControlGet, idxCylOD,, CylOD
GuiControlGet, idxCylOS,, CylOS
GuiControlGet, AxOD,, AxOD
GuiControlGet, AxOS,, AxOS
GuiControlGet, WithCorrOD,, WithCorrOD
GuiControlGet, WithCorrOS,, WithCorrOS

content .= "VisusOD=" idxVisusOD "`n"
content .= "VisusOS=" idxVisusOS "`n"
content .= "VisusCorrOD=" idxVisusCorrOD "`n"
content .= "VisusCorrOS=" idxVisusCorrOS "`n"
content .= "SphOD=" idxSphOD "`n"
content .= "SphOS=" idxSphOS "`n"
content .= "CylOD=" idxCylOD "`n"
content .= "CylOS=" idxCylOS "`n"
content .= "AxOD=" AxOD "`n"
content .= "AxOS=" AxOS "`n"
content .= "WithCorrOD=" WithCorrOD "`n"
content .= "WithCorrOS=" WithCorrOS "`n"

FileAppend, %content%, %filename%
PopulateTemplates()

; ToolTip
ControlGetPos, bx, by, bw, bh,, ahk_class AutoHotkeyGUI
ToolTip, Шаблон «%tpl%» збережено!, %bx%, % by + bh + 10, SaveTip
SetTimer, RemoveSaveTip, -1500
SB_SetText("Шаблон «" tpl "» успішно збережений", 1)
LogStatusBar("Шаблон «" tpl "» успішно збережений")
return

RemoveSaveTip:
    ToolTip,, SaveTip
return




ШаблонDelete:
Gui, Submit, NoHide
tpl := ШаблонОгляду
if (tpl = "")
    return
MsgBox,4,Видалити?,Видалити шаблон «%tpl%»?
ifMsgBox,No
    return
FileDelete, % A_ScriptDir "\ШАБЛОНИ\" tpl ".ini"
PopulateTemplates()

; ToolTip
ControlGetPos, bx, by, bw, bh,, ahk_class AutoHotkeyGUI
ToolTip, Шаблон «%tpl%» видалено!, %bx%, % by + bh + 10, DelTip
SetTimer, RemoveDelTip, -1500
SB_SetText("Шаблон «" tpl "» успішно видалено", 1)
LogStatusBar("Шаблон «" tpl "» успішно видалено")
return


RemoveDelTip:
    ToolTip,, DelTip
return




F6::
Function6:
    F6continue := 0
    gosub ЛікарChoice
    SetTimer, CheckLanguage, Off
    gosub ПереміститиНаПоля
    Run, msedge.exe "https://doctor.health.mia.software/login/pass/"
    Sleep, 2000
return

;=================================================================
; Функции и подпрограммы
;=================================================================

SetVisusODto09:
    chooseVisusOD := 2
    GuiControl, MIA:Choose, VisusOD, %chooseVisusOD%
return

SetVisusOSto09:
    chooseVisusOS := 2
    GuiControl, MIA:Choose, VisusOS, %chooseVisusOS%
return



; Восстановленная метка CheckFields – проверка обязательных полей
CheckFields:
    if (Офтальмолог = "1" or Невролог = "1" or Психофізіолог = "1" or Терапевт = "1")
    {
        GuiControlGet, Прізвище,, Прізвище
        GuiControlGet, Імя,, Імя
        GuiControlGet, Датанародження,, Датанародження
        if (Прізвище != "" and Імя != "" and Датанародження != "")
            GuiControl, MIA:Enable, ДОДАТИ
        else
            GuiControl, MIA:Disable, ДОДАТИ
    }
return

ЛікарChoice:
    Gui, Submit, NoHide
    SelectedЛікар := ЛікарChoice
    if (SelectedЛікар = "Офтальмолог")
    {
        GuiControl, MIA:Choose, Офтальмолог, Choose1
        Офтальмолог := 1, Невролог := 0, Психофізіолог := 0, Терапевт := 0
    }
    else if (SelectedЛікар = "Невролог")
    {
        GuiControl, MIA:Choose, Невролог, Choose1
        Офтальмолог := 0, Невролог := 1, Психофізіолог := 0, Терапевт := 0
    }
    else if (SelectedЛікар = "Психофізіолог")
    {
        GuiControl, MIA:Choose, Психофізіолог, Choose1
        Офтальмолог := 0, Невролог := 0, Психофізіолог := 1, Терапевт := 0
    }
    else if (SelectedЛікар = "Терапевт")
    {
        GuiControl, MIA:Choose, Терапевт, Choose1
        Офтальмолог := 0, Невролог := 0, Психофізіолог := 0, Терапевт := 1
    }
return


ChooseVisusOD(VisusODValue) {
    switch VisusODValue {
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
        case "0.09":
            return 11
        case "0.08":
            return 12
        case "0.07":
            return 13
        case "0.06":
            return 14
        case "0.05":
            return 15
        case "0.04":
            return 16
        case "0.03":
            return 17
        case "0.02":
            return 18
        case "0.01":
            return 19
        default:
            return 0  ; Если значение не найдено – возвращаем 0
    }
}

ChooseVisusOS(VisusOSValue) {
    switch VisusOSValue {
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
        case "0.09":
            return 11
        case "0.08":
            return 12
        case "0.07":
            return 13
        case "0.06":
            return 14
        case "0.05":
            return 15
        case "0.04":
            return 16
        case "0.03":
            return 17
        case "0.02":
            return 18
        case "0.01":
            return 19
        default:
            return 0
    }
}



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












ОбновитьДиагноз:
    Gui, MIA:Submit, NoHide

    ; 1) забираем значения
    sphOD := SphOD + 0, sphOS := SphOS + 0
    cylOD := CylOD + 0, cylOS := CylOS + 0
    absOD := Abs(sphOD), absOS := Abs(sphOS)

    ; 2) вычисляем возраст
    age := 0
    if (Датанародження != "") {
        FormatTime, Ynow, %A_Now%, yyyy
        RegExMatch(Датанародження, "(\d{4})", m)
        age := Ynow - m1
    }

    ; 3) собираем шаблон
    diagList := []
    tpl := ШаблонОгляду
    if (tpl = "Профогляд")
        diagList.Push({d:"Загальний медичний огляд", c:""})

    ; 4) рефракция (миопия/гиперметропия)
    if (absOD > 0.5 && absOS > 0.5 && sphOD * sphOS > 0) {
        prefix := (sphOD<0 ? "Міопія" : "Гіперметропія")
        degOD := GetDegree(sphOD), degOS := GetDegree(sphOS)
        cmt := prefix " " degOD " (" FormatRefract(sphOD) ") правого ока. "
             . prefix " " degOS " (" FormatRefract(sphOS) ") лівого ока"
        diagList.Push({d:prefix, c:cmt})
    } else {
        if (absOD > 0.5) {
            prefix := (sphOD<0 ? "Міопія" : "Гіперметропія")
            deg := GetDegree(sphOD)
            cmt := prefix " " deg " (" FormatRefract(sphOD) ") правого ока"
            diagList.Push({d:prefix, c:cmt})
        }
        if (absOS > 0.5) {
            prefix := (sphOS<0 ? "Міопія" : "Гіперметропія")
            deg := GetDegree(sphOS)
            cmt := prefix " " deg " (" FormatRefract(sphOS) ") лівого ока"
            diagList.Push({d:prefix, c:cmt})
        }
    }
; 5) АСТИГМАТИЗМ (исправленное объединение комментариев)
astParts := []
if (Abs(cylOD) >= 0.5) {
    c := Abs(cylOD)
    deg := (c <= 1) ? "слабкого ступеню"
         : (c <= 2) ? "середнього ступеню"
         : (c <= 3) ? "високого ступеню"
                    : "надвисокого ступеню"
    if (sphOD * cylOD < 0) {
        prefix := "Змішаний", type := ""
    } else if (Abs(sphOD) > 0.5) {
        prefix := "Складний", type := (sphOD<0 ? " міопічний" : " гіперметропічний")
    } else {
        prefix := "Простий", type := (sphOD<0 ? " міопічний" : " гіперметропічний")
    }
    astParts.Push(prefix . type . " астигматизм " . deg . " (" FormatRefract(cylOD) ") правого ока")
}
if (Abs(cylOS) >= 0.5) {
    c := Abs(cylOS)
    deg := (c <= 1) ? "слабкого ступеню"
         : (c <= 2) ? "середнього ступеню"
         : (c <= 3) ? "високого ступеню"
                    : "надвисокого ступеню"
    if (sphOS * cylOS < 0) {
        prefix := "Змішаний", type := ""
    } else if (Abs(sphOS) > 0.5) {
        prefix := "Складний", type := (sphOS<0 ? " міопічний" : " гіперметропічний")
    } else {
        prefix := "Простий", type := (sphOS<0 ? " міопічний" : " гіперметропічний")
    }
    astParts.Push(prefix . type . " астигматизм " . deg . " (" FormatRefract(cylOS) ") лівого ока")
}

; ИСПРАВЛЕННОЕ объединение частей в комментарий:
if (astParts.Length()) {
    cmtAst := ""
    for idx, val in astParts
        cmtAst .= (idx>1 ? ", " : "") . val
    diagList.Push({d:"Астигматизм", c:cmtAst})
}


    ; 6) Анізометропія
    if (absOD > 0.5 && absOS > 0.5) {
        d := Abs(sphOD - sphOS)
        if (d >= 2)
            diagList.Push({d:"Анізометропія", c:"Анізометропія з різницею сфер: " FormatRefract(d) " D"})
    }

; 7) Пресбіопія з урахуванням віку і оптики
presbyopia := ""
if (age >= 40) {
    if (age >= 40 && age <= 44)
        presbyopia := "+1.0 D"
    else if (age >= 45 && age <= 49)
        presbyopia := "+1.5 D"
    else if (age >= 50 && age <= 54)
        presbyopia := "+2.0 D"
    else if (age >= 55 && age <= 59)
        presbyopia := "+2.5 D"
    else if (age >= 60 && age <= 64)
        presbyopia := "+3.0 D"
    else if (age >= 65)
        presbyopia := "+3.5 D"

    diagList.Push({d:"Пресбіопія", c:"Пресбіопія до " . presbyopia})
}


    ; 8) Запись в GUI
    if (diagList.Length() >= 1) {
        GuiControl,, Основний_Діагноз,             % diagList[1].d
        GuiControl,, Коментар_Основного_Діагнозу, % diagList[1].c
    } else {
        GuiControl,, Основний_Діагноз
        GuiControl,, Коментар_Основного_Діагнозу
    }
    Loop 5 {
        idx := A_Index + 1
        if (diagList.Length() >= idx) {
            GuiControl,, Супутній_Діагноз_%A_Index%,       % diagList[idx].d
            GuiControl,, Коментар_Супутнього_Діагнозу_%A_Index%, % diagList[idx].c
        } else {
            GuiControl,, Супутній_Діагноз_%A_Index%
            GuiControl,, Коментар_Супутнього_Діагнозу_%A_Index%
        }
    }

    ; 9) Заключение
    final := ""
    for _, e in diagList
        if (e.c)
            final .= e.c ". "
    final := RTrim(final) . "Придатний."
    GuiControl,, Поле_Заключення, % final
return


;———— Вспомогательные ————
GetDegree(val) {
    n := Abs(val)
    if (val < 0)
        return n<=3 ? "слабкого ступеню"
             : n<=6 ? "середнього ступеню"
             : n<=10? "високого ступеню"
                     : "надвисокого ступеню"
    else
        return n<=2 ? "слабкого ступеню"
             : n<=5 ? "середнього ступеню"
                     : "високого ступеню"
}

FormatRefract(v) {
    num := v + 0
    return (num>=0?"+":"") . Round(num,2)
}








;==================================================
; СОБРАТЬ VISUS
;==================================================
СобратьVISUS:
    Gui, MIA:Submit, NoHide

    vOD := VisusOD
    sOD := SphOD + 0
    cOD := CylOD + 0
    aOD := AxOD
    corrOD := VisusCorrOD

    vOS := VisusOS
    sOS := SphOS + 0
    cOS := CylOS + 0
    aOS := AxOS
    corrOS := VisusCorrOS

    ; Если SPH=0 и CYL=0 => только Visus
    if (Abs(sOD) < 0.01 and Abs(cOD) < 0.01)
        lineOD := "Visus OD = " vOD
    else
        lineOD := "Visus OD = " vOD " → SPH " FormatRefract(sOD) " D, CYL " FormatRefract(cOD) " D (" aOD "°) → " corrOD

    if (Abs(sOS) < 0.01 and Abs(cOS) < 0.01)
        lineOS := "Visus OS = " vOS
    else
        lineOS := "Visus OS = " vOS " → SPH " FormatRefract(sOS) " D, CYL " FormatRefract(cOS) " D (" aOS "°) → " corrOS

    finalVisus := lineOD "`n" lineOS
    GuiControl, MIA:, Зібрано_Обєктивно, %finalVisus%
return






;=================================================================
; Обработка языка клавиатуры
;=================================================================
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


;=================================================================
; Добавление в таблицу (ListView)
;=================================================================
AddToListView:
    Gui, MIA:Default
    Gui, MIA:Submit, NoHide
    GuiControlGet, Прізвище,, Прізвище
    StringUpper, Прізвище, Прізвище
    GuiControl, MIA:, Прізвище, %Прізвище%
    LV_Add("", ID, Прізвище, Імя, Датанародження, VisusOD, VisusOS)
    LV_ModifyCol()
    GuiControl, MIA:, ID
    GuiControl, MIA:, Прізвище
    GuiControl, MIA:, Імя
    GuiControl, MIA:, Датанародження
    GuiControl, MIA:Choose, VisusOD, 1
    GuiControl, MIA:Choose, VisusOS, 1
    GuiControl, MIA:Focus, Прізвище
    UpdateStatusBar()
    SB_SetText(Прізвище . " " . Імя . " " . Датанародження . " додано до списку", 2)
	LogStatusBar(Прізвище . " " . Імя . " " . Датанародження . " додано до списку")
return

; Функция обновления статусной строки и расчёта оставшегося времени
UpdateStatusBar() {
    Gui, MIA:Default
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
	LogStatusBar(" " . RowCount . " пацієнтів - знадобиться " . Часы . " ч " . Минуты . " м " . Секунды . " с ")
}

;=================================================================
; Перемещение данных из ListView на поля ввода
;=================================================================
ПереміститиНаПоля:
    Gui, MIA:Default
    RowCount := LV_GetCount()
    if (RowCount <= 0) {
        MsgBox, Список порожній
        SoundBeep, 523, 100
        SoundBeep, 523, 100
        SoundBeep, 784, 100
        SoundBeep, 659, 100
        Sleep, 100
        Reload
        return
    }
    SelectedIndex := LV_GetNext(0, "Checked")
    if (SelectedIndex = 0) {
        SelectedIndex := 1
        LV_Modify(SelectedIndex, "Check")
    }
    LV_GetText(ID, SelectedIndex, 1)
    LV_GetText(Прізвище, SelectedIndex, 2)
    LV_GetText(Імя, SelectedIndex, 3)
    LV_GetText(Датанародження, SelectedIndex, 4)
    LV_GetText(VisusOD, SelectedIndex, 5)
    LV_GetText(VisusOS, SelectedIndex, 6)
    GuiControl, MIA:, ID, %ID%
    GuiControl, MIA:, Прізвище, %Прізвище%
    GuiControl, MIA:, Імя, %Імя%
    GuiControl, MIA:, Датанародження, %Датанародження%
    Sleep, 1000
    VisusODValue := StrReplace(VisusOD, """", "")
    VisusOSValue := StrReplace(VisusOS, """", "")
    chooseVisusOD := ChooseVisusOD(VisusODValue)
    chooseVisusOS := ChooseVisusOS(VisusOSValue)
    GuiControl, MIA:Choose, VisusOD, %chooseVisusOD%
    GuiControl, MIA:Choose, VisusOS, %chooseVisusOS%
    Sleep, 100
    LV_Delete(SelectedIndex)
    UpdateStatusBar()
    SB_SetText(Прізвище . " " . Імя . " " . Датанародження . " переміщено зі списку на поля", 2)
	LogStatusBar(Прізвище . " " . Імя . " " . Датанародження . " переміщено зі списку на поля")
return

;=================================================================
; Удаление всех строк из ListView
;=================================================================
DeleteAllRows:
    Gui, MIA:Default
    LV_Delete()
    UpdateStatusBar()
    SB_SetText("Список очищено", 2)
	LogStatusBar("Список очищено")
return

;=================================================================
; Удаление выделенной строки из ListView
;=================================================================
DeleteSelectedRow:
    Gui, MIA:Default
    SelectedIndex := LV_GetNext("", "F")
    if (SelectedIndex) {
        LV_Delete(SelectedIndex)
    }
    UpdateStatusBar()
    SB_SetText("Пункт " . SelectedIndex . " видалено зі списку", 2)
	LogStatusBar("Пункт " . SelectedIndex . " видалено зі списку")
return

;=================================================================
; Обработка нажатия клавиши Delete для удаления строки
;=================================================================
KeyPressed(wParam, lParam, msg, hwnd) {
    if (wParam = 0x2E) ; Delete key
        SendMessage, 0x111, 46,,, ahk_id %Oft_ListView%
}

;=================================================================
; Экспорт списка в Excel
;=================================================================
ЗберегтиСписок:
    Gui, MIA:Default
    Gui, MIA:Submit, NoHide
    НазваФайлуДляЗбереження := НазваФайлуДляЗбереження
    xl := ComObjCreate("Excel.Application")
    xl.Visible := true
    wb := xl.Workbooks.Add()
    ws := wb.ActiveSheet
    Loop, % LV_GetCount() {
        LV_GetText(ID, A_Index, 1)
        LV_GetText(Прізвище, A_Index, 2)
        LV_GetText(Імя, A_Index, 3)
        LV_GetText(Датанародження, A_Index, 4)
        LV_GetText(VisusOD, A_Index, 5)
        LV_GetText(VisusOS, A_Index, 6)
        LV_GetText(ДатаПфОгляду, A_Index, 7)
        ws.Cells(A_Index, 1).Value := ID
        ws.Cells(A_Index, 2).Value := Прізвище
        ws.Cells(A_Index, 3).Value := Імя
        ws.Cells(A_Index, 4).Value := Датанародження
        ws.Cells(A_Index, 5).Value := VisusOD
        ws.Cells(A_Index, 6).Value := VisusOS
        ws.Cells(A_Index, 7).Value := ДатаПфОгляду
    }
    FilePath := A_ScriptDir "\ЧАСТИНИ\Новий медогляд 2025\" . НазваФайлуДляЗбереження . ".xlsx"
    wb.SaveAs(FilePath, 51)
    wb.Close(true)
    xl.Quit()
    wb := "", xl := ""
    UpdateStatusBar()
    SB_SetText("Список " . НазваФайлуДляЗбереження . " збережено", 2)
	LogStatusBar("Список " . НазваФайлуДляЗбереження . " збережено")
return

;=================================================================
; Загрузка списка из Excel
;=================================================================
ЗавантажитиСписок:
    Gui, MIA:Default
    gosub OpenFileChoice
    Gui, MIA:Submit, NoHide
    FileSelectFile, ExcelFilePath, 1, , Выберите файл Excel, Excel Files (*.xlsx; *.xls)
    if ErrorLevel
        return
    xl := ComObjCreate("Excel.Application")
    if !xl {
        MsgBox, Excel не найден!
        return
    }
    wb := xl.Workbooks.Open(ExcelFilePath)
    if !wb {
        MsgBox, Файл Excel не найден!
        return
    }
    FormatTime, CurrentDate,, dd.MM
    if (wb.Sheets.Count > 1) {
        InputBox, sheetNumberOrName, Выбор листа, Введите номер листа или его имя:, , 200, 100
        if ErrorLevel {
            MsgBox, Пользователь отменил ввод.
            xl.Quit()
            return
        }
        isNumber := RegExMatch(sheetNumberOrName, "^\d+$")
        sheetExists := false
        if (isNumber) {
            sheetIndex := sheetNumberOrName + 0
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
        if (!sheetExists) {
            MsgBox, Указанный лист не найден. Будет использован первый лист.
            ws := wb.Sheets(1)
        }
    } else {
        ws := wb.Sheets(1)
    }
    TotalRows := ws.UsedRange.Rows.Count
    Loop, % TotalRows {
        ProgressPercentage := (A_Index * 100) / TotalRows
        GuiControl,, MyProgress, %ProgressPercentage%
        ws.Cells(A_Index, 1).Activate
        if (МедичнийОгляд = 1) {
            IDcellValue := ws.Cells(A_Index, 1).Value
            ID := SubStr(IDcellValue, 1, 7)
            CellData := ws.Cells(A_Index, 9).Value
            Датанародження := ws.Cells(A_Index, 2).Value
            if (CellData != "") {
                StringSplit, Names, CellData, %A_Space%
                Прізвище := Names1
                StringUpper, Прізвище, Прізвище
                Імя := Names2
            }
        }
        if (ЗбереженийСписок = 1) {
            IDcellValue := ws.Cells(A_Index, 1).Value
            ID := SubStr(IDcellValue, 1, 7)
            Прізвище := ws.Cells(A_Index, 2).Value
            Імя := ws.Cells(A_Index, 3).Value
            Датанародження := ws.Cells(A_Index, 4).Value
            VisusOD := ws.Cells(A_Index, 5).Value
            VisusOS := ws.Cells(A_Index, 6).Value
            ДатаПфОгляду := ws.Cells(A_Index, 7).Value
        }
        if (Прізвище != "") {
            LV_Add("", ID, Прізвище, Імя, Датанародження, VisusOD, VisusOS)
            LV_ModifyCol()
            GuiControl,, MyProgress, %A_Index%
        }
    }
    xl.Quit()
    xl := ""
    wb := ""
    if RegExMatch(ExcelFilePath, "(\d{4})-(\d{2})-(\d{2})", m) {
        File_year  := m1
        File_month := m2
        File_day   := m3
        НазваФайлуДляЗбереження := File_day "." File_month "." File_year
    } else {
        НазваФайлуДляЗбереження := ExcelFilePath
    }
    GuiControl, MIA:, НазваФайлуДляЗбереження, %НазваФайлуДляЗбереження%
    UpdateStatusBar()
    SB_SetText("Список імпортовано из файла: " . ExcelFilePath, 2)
	LogStatusBar("Список імпортовано из файла: " . ExcelFilePath)
return

OpenFileChoice:
    Gui, Submit, NoHide
    SelectedFileChoice := OpenFileChoice
    if (SelectedFileChoice = "МедичнийОгляд") {
        МедичнийОгляд := 1
        ЗбереженийСписок := 0
    } else if (SelectedFileChoice = "ЗбереженийСписок") {
        МедичнийОгляд := 0
        ЗбереженийСписок := 1
    }
return

;=================================================================
; Обработка закрытия окна
;=================================================================
GuiClose:
    ExitApp
