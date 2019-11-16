#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include "../GWA2.au3"
#include "CommonFunction.au3"
#include "../SimpleInventory.au3"

Global $START_TIME
Global $BOT_RUNNING = False

Global $STARTING_POINTS
Global $POINTS_EARNED = 0
Global $POINTS_DONATED = 0
Global $TOTAL_RUNS = 0

Global $FERNDALE = 210
Global $HOUSE_ZU_HELTZER = 77
Global $TOTAL_RUNS = 0	
Global $VQ = False
Global $DeadOnTheRun = False

While 1
    If Not $BOT_RUNNING Then
        Sleep(50)
        ContinueLoop
    EndIf

    If $TOTAL_RUNS == 0 Then
        $START_TIME = TimerInit()
        $STARTING_POINTS = GetKurzickFaction()
    EndIf

    If GetMapID() <> $HOUSE_ZU_HELTZER Then
        Out("Moving to Outpost")
        TravelTo($HOUSE_ZU_HELTZER, 0)
    EndIf

    SwitchMode(1)
    RndSleep(1000)
    $TOTAL_RUNS += 1
    Out("Begin run number " & $TOTAL_RUNS)
    GoOut()
    VQ()
    TravelTo($HOUSE_ZU_HELTZER)
    Inventory()
    TurnInFactionKurzick()
    KurzickPoints()
WEnd

Func GoMerchant()
    GoToNPC(GetNearestNPCToCoords(8481, 2005))
EndFunc ;GoMerchant

Func GoOut()
    If GetGoldCharacter() < 100 AND GetGoldStorage() > 2000 Then
        Out("Grabbing gold for shrine")
        WithdrawGold(1000)
        RndSleep(250)
    EndIf

    MoveTo(7810,-726)
    Do
        MoveTo(10042,-1173)
        MoveTo(10446, -1147, 5)
    Until GetMapID() == $FERNDALE
EndFunc ;GoOut

Func TurnInFactionKurzick()
    Out("Turning in faction")
    GoToNPC(GetNearestNPCToCoords(5390, 1524))

    If GUICtrlRead($Donate) == $GUI_CHECKED Then
        Do
            Out("Donate")
            DonateFaction("kurzick")
            RndSleep(500)
            $POINTS_DONATED += 5000
        Until GetKurzickFaction() < 5000
    EndIf
    If GUICtrlRead($Amber) == $GUI_CHECKED Then
        If InventoryIsFull() Then Return
        Do
            Out("Getting Amber")
            Dialog(0x84)
            RndSleep(500)
            Dialog(0x800101)
            RndSleep(500)
            $POINTS_DONATED += 5000
        Until GetKurzickFaction() < 5000
    EndIf
EndFunc ;TurnInFactionKurzick

Func KurzickPoints()
    $point_earn = GetKurzickFaction() - $STARTING_POINTS + $POINTS_DONATED
    GUICtrlSetData($gui_status_point, $point_earn)
EndFunc ;Kurzickpoint

Func VQ()
    AdlibRegister("_status", 1000)
    $VQ = False
    $DeadOnTheRun = False
    Out("Taking blessing")
    $deadlock = 0
    Do
        GoToNPC(GetNearestNPCToCoords(-12909, 15616))
        Dialog(0x85)
        RndSleep(1000)
        Dialog(0x86)
        RndSleep(1000)
        $deadlock+=1
    Until DllStructGetData(geteffect(593), 'skillid') = 593 or DllStructGetData(geteffect(912), 'skillid') = 912 or $deadlock = 10 ; luxon = 1947

    $enemy = "Mantis Group"
    If Not $DeadOnTheRun Then AggroMoveToEx(-11733, 16729, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-11942, 18468, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-11178,20073, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-11008, 16972, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-11238, 15226, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-10965, 13496, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-10570, 11789, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-10138, 10076, $enemy)

    $enemy = "Dredge Boss Warrior"
    If Not $DeadOnTheRun Then AggroMoveToEx(-10289, 8329, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-8587, 8739, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-6853, 8496, $enemy)

    $enemy = "Dredge Patrol"
    If Not $DeadOnTheRun Then AggroMoveToEx(-5211, 7841, $enemy)

    $enemy = "Missing Dredge Patrol"
    If Not $DeadOnTheRun Then AggroMoveToEx(-4059, 11325, $enemy)

    $enemy = "Oni and Dredge Patrol"
    If Not $DeadOnTheRun Then AggroMoveToEx(-4328, 6317, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-4454, 4558, $enemy)

    $enemy = "Dredge Patrol Again"
    If Not $DeadOnTheRun Then AggroMoveToEx(-4650, 2812, $enemy)

    $enemy = "Missing Patrol"
    If Not $DeadOnTheRun Then AggroMoveToEx(-9326,1601, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-11000,2219, $enemy,5000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-6313,2778, $enemy)

    $enemy = "Dreadge Patrol"
    If Not $DeadOnTheRun Then AggroMoveToEx(-4447, 1055, $enemy,3000)

    $enemy = "Warden and Dredge Patrol"
    If Not $DeadOnTheRun Then AggroMoveToEx(-3832, -586, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-3143, -2203, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-5780, -4665, $enemy,3000)

    $enemy = "Warden Group / Mesmer Boss"
    If Not $DeadOnTheRun Then AggroMoveToEx(-2541, -3848, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-2108, -5549, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-1649, -7250, $enemy,2500)

    $enemy = "Dredge Patrol and Mesmer Boss"
    If Not $DeadOnTheRun Then AggroMoveToEx(-666, -8708, $enemy,2500)

    $enemy = "Warden Group"
    If Not $DeadOnTheRun Then AggroMoveToEx(526, -10001, $enemy)

    $enemy = "Warden Group"
    If Not $DeadOnTheRun Then AggroMoveToEx(1947, -11033, $enemy)

    $enemy = "Warden Group"
    If Not $DeadOnTheRun Then AggroMoveToEx(3108, -12362, $enemy)

    $enemy = "Kirin Group"
    If Not $DeadOnTheRun Then AggroMoveToEx(2932, -14112, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(2033, -15621, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(1168, -17145, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-254, -18183, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-1934, -18692, $enemy)

    $enemy = "Warden Patrol"
    If Not $DeadOnTheRun Then AggroMoveToEx(-3676, -18939, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-5433, -18839, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-3679, -18830, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-1925, -18655, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-274, -18040, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(1272, -17199, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(2494, -15940, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(3466, -14470, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(4552, -13081, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(6279, -12777, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(7858, -13545, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(8396, -15221, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(9117, -16820, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(10775, -17393, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(9133, -16782, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(8366, -15202, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(8083, -13466, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(6663, -12425, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(5045, -11738, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(4841, -9983, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(5262, -8277, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(5726, -6588, $enemy)

    $enemy = "Dredge Patrol / Bridge / Boss"
    If Not $DeadOnTheRun Then AggroMoveToEx(5076, -4955, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(4453, -3315, $enemy,3000)
    AdlibRegister("CheckVQ", 5000)
    $enemy = "Dedge Patrol"
    If Not $DeadOnTheRun Then AggroMoveToEx(5823, -2204, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(7468, -1606, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(8591, -248, $enemy, 3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(8765, 1497, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(9756, 2945, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(11344, 3722, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(12899, 2912, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(12663, 4651, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(13033, 6362, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(13018, 8121, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(11596, 9159, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(11880, 10895, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(11789, 12648, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(10187, 13369, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(8569, 14054, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(8641, 15803, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(10025, 16876, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(11318, 18944, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(8621, 15831, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(7382, 14594, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(6253, 13257, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(5531, 11653, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(6036, 8799, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(4752, 7594, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(3630, 6240, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(4831, 4966, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(6390, 4141, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(4833, 4958, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(3167, 5498, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(2129, 4077, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(3151, 5502, $enemy)
    If Not $DeadOnTheRun Then AggroMoveToEx(-2234, 311, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(2474, 4345, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(3294, 5899, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(3072, 7643, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(1836, 8906, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(557, 10116, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-545, 11477, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-1413, 13008, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-2394, 14474, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-3986, 15218, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-5319, 16365, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-5238, 18121, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-7916, 19630, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-3964, 19324, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-2245, 19684, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(-802, 18685, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(74, 17149, $enemy,3000)
    If Not $DeadOnTheRun Then AggroMoveToEx(611, 15476, $enemy,4000)
    If Not $DeadOnTheRun Then AggroMoveToEx(2139, 14618, $enemy,4000)
    If Not $DeadOnTheRun Then AggroMoveToEx(3883, 14448, $enemy,4000)
    If Not $DeadOnTheRun Then AggroMoveToEx(5624, 14226, $enemy,4000)
    If Not $DeadOnTheRun Then AggroMoveToEx(7384, 14094, $enemy,4000)
    If Not $DeadOnTheRun Then AggroMoveToEx(8223, 12552, $enemy,4000)
    If Not $DeadOnTheRun Then AggroMoveToEx(7148, 11167, $enemy,4000)
    If Not $DeadOnTheRun Then AggroMoveToEx(5427, 10834, $enemy,10000)
    If Not $DeadOnTheRun Then Out("Waiting to get reward")
    If Not $DeadOnTheRun Then RndSleep(6000)
    If $VQ Then $DeadOnTheRun = False
    AdlibUnRegister("_status")
    AdlibUnRegister("CheckVQ")
EndFunc

#Region Helpers
Func CheckVQ()
    If GetAreaVanquished() Then
        $DeadOnTheRun = True
        $VQ = True
    EndIf
EndFunc ;CheckVQ

Func _status()
    $time = TimerDiff($START_TIME)
    $string = StringFormat("min: %03u  sec: %02u ", $time/1000/60, Mod($time/1000,60))
    GUICtrlSetData($label_stat, $string)
EndFunc ;_status
#EndRegion Helpers
