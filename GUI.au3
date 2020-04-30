#include-once
#include <GuiEdit.au3>
#include <GuiRichEdit.au3>
#include <ScrollBarsConstants.au3>

Global $strName = ""
Global $SUCCESSFUL_RUNS = 0
Global $TOTAL_RUNS = 0

Global $File = @ScriptDir & "/Trace/Trace du " & @MDAY & "-" & @MON & " a " & @HOUR & "h et " & @MIN & "minutes.txt"

Global $intSkillEnergy[8] = [0, 15, 25, 5, 10, 15, 5, 5]

Opt("GUIOnEventMode", 1)

#Region GUI
Global $win = GUICreate("KurzickFarm", 275, 200, -1, -1)

GUICtrlCreateGroup("Status", 10, 5, 130, 80)
GUICtrlCreateLabel("Total Runs", 20, 20, 70, 15)
Global $gui_status_runs = GUICtrlCreateLabel("0", 90, 20, 40, 15, $SS_RIGHT)

GUICtrlCreateLabel("Successful", 20, 35, 70, 15)
	GUICtrlSetColor(-1, 0x008000)
Global $gui_status_successful = GUICtrlCreateLabel("0", 90, 35, 40, 15, $SS_RIGHT)
	GUICtrlSetColor(-1, 0x008000)

GUICtrlCreateLabel("Kurzick", 20, 50, 70, 15)
	GUICtrlSetColor(-1, 0x808000)
Global $gui_status_point = GUICtrlCreateLabel("0", 90, 50, 40, 15, $SS_RIGHT)
	GUICtrlSetColor(-1, 0x808000)

GUICtrlCreateLabel("Time", 20, 65, 50, 15)
Global $label_stat = GUICtrlCreateLabel("00:00", 70, 65, 60, 15, $SS_RIGHT)


Global $Donate = GUICtrlCreateRadio("Donate", 150, 10, 55, 15)
Global $Amber = GUICtrlCreateRadio("Amber", 210, 10, 55, 15)

Global $txtName = GUICtrlCreateCombo($strName, 150, 30, 110, 20)
	GUICtrlSetData($txtName, GetLoggedCharNames())
Global $Start = GUICtrlCreateButton("Start", 150, 55, 110, 25, $WS_GROUP)
	GUICtrlSetOnEvent(-1, "GUI_EventHandler")


Global $edtLog = _GUICtrlRichEdit_Create($win, "", 10, 90, 250, 100, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_READONLY))
	_GUICtrlRichEdit_SetFont($edtLog, 9, "Arial")
	_GUICtrlRichEdit_SetCharColor($edtLog, "65280")
	_GUICtrlEdit_Scroll($edtLog, $SB_SCROLLCARET)
	_GUICtrlRichEdit_SetText($edtLog, StringFormat("Ferndale Bot\n"))

;GUICtrlCreateGroup("Status: Current Action", 10, 375 - 90 - 65 + 20, 255, 45)
;Global $STATUS = GUICtrlCreateLabel("Script not started yet", 20, 390 - 90 - 65 + 20, 235, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_EventHandler")
GUICtrlSetState($Donate, $GUI_CHECKED)
GUISetState(@SW_SHOW)
#EndRegion GUI

Func GUI_EventHandler()
	switch (@GUI_CtrlId)
		case $GUI_EVENT_CLOSE
			exit
		case $Start
			$TOTAL_RUNS = 0
			$SUCCESSFUL_RUNS = 0
			$BOT_RUNNING = True

			GUICtrlSetState($Start, $GUI_DISABLE)
			GUICtrlSetState($txtName, $GUI_DISABLE)
			If GUICtrlRead($txtName) = "" Then
				If Initialize(ProcessExists("gw.exe")) = False Then
					MsgBox(0, "Error", "Guild Wars it not running.")
					Exit
				EndIf
			Else
				If Initialize(GUICtrlRead($txtName), "Guild Wars - " & GUICtrlRead($txtName)) = False Then
					MsgBox(0, "Error", "Can't find a Guild Wars client with that character name.")
					Exit
				EndIf
			EndIf
	endswitch
EndFunc
