#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <Date.au3>
#include "../GWA2/GWA2.au3"
#include "GUI.au3"
#include "../_SimpleInventory.au3"
#include "../_AttackMove.au3"
#NoTrayIcon

Global $START_TIME
Global $BOT_RUNNING = False

Global $STARTING_POINTS
Global $POINTS_EARNED = 0
Global $POINTS_DONATED = 0

Global $FERNDALE = 210
Global $HOUSE_ZU_HELTZER = 77
Global $VQ = False
Global $DeadOnTheRun = False

While 1
	Sleep(100)
	If Not $BOT_RUNNING Then ContinueLoop

	$START_TIME = TimerInit()
	If $TOTAL_RUNS == 0 And GetMapID() <> $FERNDALE Then Setup()

	$TOTAL_RUNS += 1
	GUICtrlSetData($gui_status_runs, $TOTAL_RUNS)
	Out("Begin run number " & $TOTAL_RUNS)

	GoOut()
	Vanquish()
WEnd

Func Setup()
	$STARTING_POINTS = GetKurzickFaction()

	If GetMapID() <> $HOUSE_ZU_HELTZER And GetMapID() <> $FERNDALE Then
		Out("Moving to Outpost")
		TravelTo($HOUSE_ZU_HELTZER, 0)
	EndIf

	SwitchMode(1)
EndFunc ;Setup

Func GoMerchant()
	GoToNPC(GetNearestNPCToCoords(8481, 2005))
EndFunc ;GoMerchant

Func GoOut()
	If GetMapID() <> $HOUSE_ZU_HELTZER Then Return
	If GetGoldCharacter() < 100 AND GetGoldStorage() > 2000 Then
		Out("Grabbing gold for shrine")
		WithdrawGold(1000)
		RndSleep(250)
	EndIf

	MoveTo(7810,-726)
	Do
		MoveTo(10042,-1173)
		Move(10446, -1147, 5)
	Until WaitMapLoading($FERNDALE)
EndFunc ;GoOut

Func TurnInFactionKurzick()
	Out("Turning in faction")
	GoToNPC(GetNearestNPCToCoords(5390, 1524))
	Local $timer = TimerInit()

	If GUICtrlRead($Donate) == $GUI_CHECKED Then
		Do
			Out("Donating 5000")
			DonateFaction("kurzick")
			RndSleep(500)
			$POINTS_DONATED += 5000
		Until GetKurzickFaction() < 5000 Or TimerDiff($timer) > 20000
	EndIf
	If GUICtrlRead($Amber) == $GUI_CHECKED Then
		If InventoryIsFull() Then Return
		Do
			Out("Getting 1 Amber")
			Dialog(0x84)
			RndSleep(500)
			Dialog(0x800101)
			RndSleep(500)
			$POINTS_DONATED += 5000
		Until GetKurzickFaction() < 5000 Or TimerDiff($timer) > 20000
	EndIf
EndFunc ;TurnInFactionKurzick

Func KurzickPoints()
	GUICtrlSetData($gui_status_point, GetKurzickFaction() - $STARTING_POINTS + $POINTS_DONATED)
EndFunc ;Kurzickpoint

Func HasBlessing()
	Local $KUZICK_BUFFS = [593, 912]

	For $i = 0 to UBound($KUZICK_BUFFS) - 1
		If IsDllStruct(GetEffect($KUZICK_BUFFS[$i])) Then Return True
	Next
	Return False
EndFunc ;HasBlessing

Func TakeBlessing()
	Out("Taking blessing")
	$deadlock = 0
	Do
		GoToNPC(GetNearestNPCToCoords(-12909, 15616))
		Dialog(0x85)
		RndSleep(1000)
		Dialog(0x86)
		RndSleep(1000)
		$deadlock+=1
	Until HasBlessing() or $deadlock = 10 ; luxon = 1947
EndFunc

Func Vanquish()
	AdlibRegister("_status", 1000)
	$VQ = False
	$DeadOnTheRun = False

	If Not HasBlessing() Then TakeBlessing()
	AdlibRegister("CheckVQ", 5000)

	Local $Waypoints = [ _
		[-11733, 16729, "Mantis Group"], _
		[-11942, 18468], _
		[-11178, 20073], _
		[-11008, 16972], _
		[-11238, 15226], _
		[-10965, 13496], _
		[-10570, 11789], _
		[-10138, 10076], _
		[-10289, 8329, "Dredge Boss Warrior"], _
		[-8587, 8739], _
		[-6853, 8496], _
		[-5211, 7841, "Dredge Patrol"], _
		[-4059, 11325], _
		[-4328, 6317, "Missing Dread Patrol"], _
		[-4454, 4558, "Oni and Dredge patrol"], _
		[-4650, 2812], _
		[-9326, 1601, "Dredge patrol again"], _
		[-11000, 2219, "Missing patrol"], _
		[-6313, 2778], _
		[-4447, 1055], _
		[-3832, -586, "Dredge patrol"], _
		[-3143, -2203, "warden and dredge patrol"], _
		[-5780, -4665], _
		[-2541, -3848], _
		[-7352, -6865], _
		[-2108, -5549, "Warden Group / Mesmer Boss"], _
		[-1649, -7250], _
		[-666, -8708], _
		[526, -10001, "Warden Group"], _
		[1947, -11033, "Warden Group"], _
		[3108, -12362, "Warden Group"], _
		[2932, -14112, "Kirin Group"], _
		[2033, -15621], _
		[1168, -17145], _
		[-254, -18183], _
		[-1934, -18692], _
		[-3676, -18939, "Warden Patrol"], _
		[-5433, -18839], _
		[-3679, -18830], _
		[-1925, -18655], _
		[-274, -18040], _
		[1272, -17199], _
		[2494, -15940], _
		[3466, -14470], _
		[4552, -13081], _
		[6279, -12777], _
		[7858, -13545], _
		[8396, -15221], _
		[9117, -16820], _
		[10775, -17393], _
		[9133, -16782], _
		[8366, -15202], _
		[8083, -13466], _
		[6663, -12425], _
		[5045, -11738], _
		[4841, -9983], _
		[5262, -8277], _
		[5726, -6588], _
		[5076, -4955, "Dredge Patrol / Bridge / Boss"], _
		[4453, -3315], _
		[2433, -3190], _
		[5823, -2204, "Dedge Patrol"], _
		[7468, -1606], _
		[8591, -248], _
		[8765, 1497], _
		[9756, 2945], _
		[11344, 3722], _
		[12899, 2912], _
		[12663, 4651], _
		[13033, 6362], _
		[13018, 8121], _
		[11596, 9159], _
		[11880, 10895], _
		[11789, 12648], _
		[10187, 13369], _
		[8569, 14054], _
		[8641, 15803], _
		[10025, 16876], _
		[11318, 18944], _
		[8621, 15831], _
		[7382, 14594], _
		[6253, 13257], _
		[5531, 11653], _
		[6036, 8799], _
		[4752, 7594], _
		[3630, 6240], _
		[4831, 4966], _
		[6390, 4141], _
		[4833, 4958], _
		[3167, 5498], _
		[2129, 4077], _
		[3151, 5502], _
		[-2234, 311], _
		[2474, 4345], _
		[3294, 5899], _
		[3072, 7643], _
		[1836, 8906], _
		[557, 10116], _
		[-545, 11477], _
		[-1413, 13008], _
		[-2394, 14474], _
		[-3986, 15218], _
		[-5319, 16365], _
		[-5238, 18121], _
		[-7916, 19630], _
		[-3964, 19324], _
		[-2245, 19684], _
		[-802, 18685], _
		[74, 17149], _
		[611, 15476], _
		[2139, 14618], _
		[3883, 14448], _
		[5624, 14226], _
		[7384, 14094], _
		[8223, 12552], _
		[7148, 11167], _
		[5427, 10834], _
		[2881, 9939], _
		[-910, 8685], _
		[-4128, 6194], _
		[-6594, 8377], _
		[-9990, 9089]]

	Do
		FollowPath($Waypoints)
	Until $VQ Or $DeadOnTheRun

	If $VQ Then
		Out("Waiting to get reward")
		RndSleep(6000)
		$DeadOnTheRun = False
		EndRun()
		Return
	EndIf

	If $DeadOnTheRun Then
		Out("Party wipe, restarting")
		$DeadOnTheRun = False
		Return Vanquish()
	Endif

	MoveTo($Waypoints[0][0], $Waypoints[0][1])
	Vanquish()
EndFunc

Func EndRun()
	AdlibUnRegister("_status")
	AdlibUnRegister("CheckVQ")
	$SUCCESSFUL_RUNS += 1
	GUICtrlSetData($gui_status_successful, $SUCCESSFUL_RUNS)
	TravelTo($HOUSE_ZU_HELTZER)
	Inventory()
	TurnInFactionKurzick()
	KurzickPoints()
EndFunc

#Region Helpers
Func CheckVQ()
	If GetAreaVanquished() Then
		$DeadOnTheRun = True
		$VQ = True
	EndIf
EndFunc ;CheckVQ

Func _status()
	Local $g_iSecs, $g_iMins, $g_iHour
	_TicksToTime(Int(TimerDiff($START_TIME)), $g_iHour, $g_iMins, $g_iSecs)
	Local $sTime = StringFormat("%02i:%02i:%02i", $g_iHour, $g_iMins, $g_iSecs)
	GuiCtrlSetData($label_stat, $sTime)
EndFunc ;_status

Func Out($MSG)
	_GUICtrlRichEdit_AppendText($edtLog, $MSG & @CRLF)
	FileWriteLine($File, "Run : " & $TOTAL_RUNS & " à : " & @Hour & ":" & @MIN & "." & @Sec & "   " & $MSG & @CRLF)
EndFunc ;Out
#EndRegion Helpers
