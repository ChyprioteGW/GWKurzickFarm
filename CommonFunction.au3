#include-once

Global $strName = ""
Global $iItems_Picked = 0
Global $NumberRun = 0, $DeldrimorMade = 0, $IDKitBought = 0, $RunSuccess = 0
Global $boolrun = False
Global $strName = ""
Global $coords[2]

Global $File = @ScriptDir & "\Trace\Traça du " & @MDAY & "-" & @MON & " a " & @HOUR & "h et " & @MIN & "minutes.txt"

Global $intSkillEnergy[8] = [1, 15, 5, 5, 10, 15, 5, 5]

Opt("GUIOnEventMode", 1)

#Region GUI
Global $win = GUICreate("KurzickFarm", 274, 270 + 20, 500, 1)
GUICtrlCreateLabel("Globeul", 180, 180-70-30,80)
	GUICtrlSetFont(-1, 15)
$Start = GUICtrlCreateButton("Start", 178, 250-90-50, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent(-1, "GUI_EventHandler")
GUICtrlCreateGroup("Status: Runs", 275-265, 8, 255, 90-35)
GUICtrlCreateLabel("Total Runs:", 285-265, 28, 70, 17)
Global $gui_status_runs = GUICtrlCreateLabel("0", 355-265, 28, 40, 17, $SS_RIGHT)
GUICtrlCreateLabel("Kits Bought:", 410-265, 28, 70, 17)
Global $gui_status_kit = GUICtrlCreateLabel("0", 480-265, 28, 40, 17, $SS_RIGHT)
GUICtrlCreateLabel("Successful:", 285-265, 43, 70, 17)
	GUICtrlSetColor(-1, 0x008000)
Global $gui_status_successful = GUICtrlCreateLabel("0", 355-265, 43, 40, 17, $SS_RIGHT)
	GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Status: Items", 275-265, 235-132-35, 150, 195-80-40-15)
GUICtrlCreateLabel("Titre:", 285-265, 255-132-35, 27, 17)
GUICtrlCreateLabel("Made:", 380-265, 255-132-35, 40, 17)
GUICtrlCreateLabel("Kurzick", 285-265, 285-132-35-15, 70, 17)
	GUICtrlSetColor(-1, 0x808000)
Global $gui_status_point = GUICtrlCreateLabel("0", 370-265, 285-132-35-15, 40, 17, $SS_RIGHT)
	GUICtrlSetColor(-1, 0x808000)
Global $Donate = GUICtrlCreateRadio("Donate", 370-265, 285-132-35-15+35, 55, 17)
Global $Amber = GUICtrlCreateRadio("Amber", 370-265-60, 285-132-35-15+35, 45, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Status: Time", 10, 310 - 90 - 75 + 20, 255, 43)
GUICtrlCreateLabel("Total:", 20, 330 - 90 - 75 + 20, 50, 17)
Global $label_stat = GUICtrlCreateLabel("min: 000  sec: 00", 70, 330 - 90 - 75 + 20)

GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $txtName = GUICtrlCreateCombo($strName, 60, 330 - 90 - 45 + 20, 150 , 20)
GUICtrlSetData($txtName, GetLoggedCharNames())

GUICtrlCreateGroup("Status: Current Action", 10, 375 - 90 - 65 + 20, 255, 45)
Global $STATUS = GUICtrlCreateLabel("Script not started yet", 20, 390 - 90 - 65 + 20, 235, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_EventHandler")
GUICtrlSetState($Donate, $GUI_CHECKED)
GUISetState(@SW_SHOW)
#EndRegion GUI

func GUI_EventHandler()
	switch (@GUI_CtrlId)
		case $GUI_EVENT_CLOSE
			exit
		case $Start
			$NumberRun = 0
			$DeldrimorMade = 0
			$IDKitBought = 0
			$RunSuccess = 0
			$boolrun = True

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
endfunc


Func Out($MSG)
	GUICtrlSetData($STATUS, $MSG)
	GUICtrlSetData($gui_status_runs, $NumberRun)
	GUICtrlSetData($gui_status_kit, $IDKitBought)
	GUICtrlSetData($gui_status_successful, $RunSuccess)
	FileWriteLine($File, "Run : " & $NumberRun & " à : " & @Hour & ":" & @MIN & "." & @Sec & "   " & $MSG & @CRLF)
EndFunc ;Out

Func WaitForLoad()
	Out("Loading zone")
	InitMapLoad()
	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load = 2 And DllStructGetData($lMe, 'X') = 0 And DllStructGetData($lMe, 'Y') = 0 Or $deadlock > 10000

	$deadlock = 0
	Do
		Sleep(100)
		$deadlock += 100

		$deadlock += 100
		$load = GetMapLoading()
		$lMe = GetAgentByID(-2)

	Until $load <> 2 And DllStructGetData($lMe, 'X') <> 0 And DllStructGetData($lMe, 'Y') <> 0 Or $deadlock > 30000
	Out("Load complete")
	RndSleep(3000)
EndFunc ;WaitForLoad

Func AggroMoveToEx($x, $y, $s = "", $z = 2000)


	Out("Hunting " & $s)
	$random = 50
	$iBlocked = 0

	Move($x, $y, $random)
	$Me = GetAgentByID()
	$coords[0] = DllStructGetData($Me, 'X')
	$coords[1] = DllStructGetData($Me, 'Y')
	Do
		RndSleep(250)
		$oldCoords = $coords
		local $timeragro = TimerInit()
		$enemy = GetNearestEnemyToAgent(-2)
		$distance = ComputeDistance(DllStructGetData($enemy, 'X'),DllStructGetData($enemy, 'Y'),DllStructGetData(GetAgentByID(-2), 'X'),DllStructGetData(GetAgentByID(-2), 'Y'))
		If $distance < $z AND $enemy <> 0 Then
			Fight($z, $s)
			Out("Hunting " & $s)
		EndIf
		RndSleep(250)
		$Me = GetAgentByID()
		$coords[0] = DllStructGetData($Me, 'X')
		$coords[1] = DllStructGetData($Me, 'Y')
		If $oldCoords[0] = $coords[0] AND $oldCoords[1] = $coords[1] AND TimerDiff($timeragro) < 2000 Then
			$iBlocked += 1
			MoveTo($coords[0], $coords[1], 1500)
			RndSleep(1000)
			Move($x, $y)
		EndIf

	Until ComputeDistance($coords[0], $coords[1], $x, $y) < 250 OR $iBlocked > 20
EndFunc ;AggroMoveToEx

Func Fight($x, $s = "enemies")
	Local $lastId = 99999, $coordinate[2],$timer
	Out("Fighting " & $s & " !")

	Do
		$Me = GetAgentByID(-2)
		$energy = GetEnergy()
		$skillbar = GetSkillbar()
		$useSkill = -1
		For $i = 0 To 7
			$recharged = DllStructGetData($skillbar, 'Recharge' & ($i + 1))
			$strikes = DllStructGetData($skillbar, 'AdrenalineA' & ($i + 1))
			If $recharged = 0 AND $intSkillEnergy[$i] <= $energy  Then
				$useSkill = $i + 1
				ExitLoop
			EndIf
		Next

		$target = GetNearestEnemyToAgent(-2)
		$distance = ComputeDistance(DllStructGetData($target, 'X'),DllStructGetData($target, 'Y'),DllStructGetData(GetAgentByID(-2), 'X'),DllStructGetData(GetAgentByID(-2), 'Y'))
		If $useSkill <> -1 AND $target <> 0 AND $distance < $x Then
			If DllStructGetData($target, 'Id') <> $lastId Then
				ChangeTarget($target)
				RndSleep(150)
				CallTarget($target)
				RndSleep(150)
				Attack($target)
				$lastId = DllStructGetData($target, 'Id')
				$coordinate[0] = DllStructGetData($target, 'X')
				$coordinate[1] = DllStructGetData($target, 'Y')
				$timer = TimerInit()
				Do
					Move($coordinate[0],$coordinate[1])
					rndsleep(500)
					$Me = GetAgentByID(-2)
					$distance = ComputeDistance($coordinate[0],$coordinate[1],DllStructGetData($Me, 'X'),DllStructGetData($Me, 'Y'))
				Until $distance < 1100 or TimerDiff($timer) > 10000
			EndIf
			RndSleep(150)
			$timer = TimerInit()
			Do
				$target = GetNearestEnemyToAgent(-2)
				$distance = ComputeDistance(DllStructGetData($target, 'X'),DllStructGetData($target, 'Y'),DllStructGetData(GetAgentByID(-2), 'X'),DllStructGetData(GetAgentByID(-2), 'Y'))
				If $distance < 1250 Then
					UseSkill($useSkill, $target)
					RndSleep(500)
				EndIf
				Attack($target)
				$Me = GetAgentByID(-2)
				$target = GetAgentByID(DllStructGetData($target, 'Id'))
				$coordinate[0] = DllStructGetData($target, 'X')
				$coordinate[1] = DllStructGetData($target, 'Y')
				$distance = ComputeDistance($coordinate[0],$coordinate[1],DllStructGetData($Me, 'X'),DllStructGetData($Me, 'Y'))
			Until DllStructGetData(GetSkillbar(), 'Recharge' & $useSkill) >0 or DllStructGetData($target, 'HP') < 0.005 Or $distance > $x Or TimerDiff($timer) > 5000
		EndIf
		$target = GetNearestEnemyToAgent(-2)
		$distance = ComputeDistance(DllStructGetData($target, 'X'),DllStructGetData($target, 'Y'),DllStructGetData(GetAgentByID(-2), 'X'),DllStructGetData(GetAgentByID(-2), 'Y'))
	Until DllStructGetData($target, 'ID') = 0 OR $distance > $x
	If CountSlots() == 0 then
		Out("Inventory full")
	Else
		Out("Picking up items")
		PickupItems(-1, $x)
	EndIf
EndFunc ;Fight

Func PickupItems($iItems = -1, $fMaxDistance = 1012)
	Local $aItemID, $lNearestDistance, $lDistance
	$tDeadlock = TimerInit()
	Do
		$aItem = GetNearestItemToAgent(-2)
		$lDistance = @extended

		$aItemID = DllStructGetData($aItem, 'ID')
		If $aItemID = 0 Or $lDistance > $fMaxDistance Or TimerDiff($tDeadlock) > 30000 Then ExitLoop
		PickUpItem($aItem)
		$tDeadlock2 = TimerInit()
		Do
			Sleep(500)
			If TimerDiff($tDeadlock2) > 5000 Then ContinueLoop 2
		Until DllStructGetData(GetAgentById($aItemID), 'ID') == 0
		$iItems_Picked += 1
	Until $iItems_Picked = $iItems
	Return $iItems_Picked
EndFunc ;PickupItems