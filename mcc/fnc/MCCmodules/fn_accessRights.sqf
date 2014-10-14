
//******************************************************************************************
//==========================================================================================
//=		 						 Shay-Gman 
//=					                             24.12.2011
//==========================================================================================
//******************************************************************************************
private ["_logic","_names","_namesList","_synced","_name"];


// Exit when no player system
if !(hasInterface) exitWith {}; 

_logic 		= _this select 0;

_namesList = call compile (_logic getvariable ["names","[]"]); 
_logic setpos [1000,10,0];

waituntil {isplayer player && alive player && MCC_initDone};

//remove previously added action
player removeAction mcc_actionInedx;			

//who autohrized to access the module
if (count _namesList == 0) then 
{
	_names = false
} 
else 
{  
	_names = true;
};	

_synced = synchronizedobjects _logic;									//Who synced with the module

if (_names || (count _synced > 0) || (serverCommandAvailable "#logout")) then 								//We have autorized personal only
{							
	if (((getPlayerUID player) in _namesList) || (player in _synced) || (serverCommandAvailable "#logout"))then 
	{
		mcc_actionInedx = player addaction ["<t color=""#99FF00"">--= MCC =--</t>", MCC_path + "mcc\dialogs\mcc_PopupMenu.sqf",[nil,nil,nil,nil,0], 0,false, false, "teamSwitch","vehicle _target == vehicle _this"];
		player setvariable ["MCC_allowed",true,true];
	} 
	else
	{
		player setvariable ["MCC_allowed",false,true];
	}
};

//Case Admin DC	
while {true} do 												
{														
	sleep 5;
	if (serverCommandAvailable "#logout") then
	{
		mcc_actionInedx = player addaction ["<t color=""#99FF00"">--= MCC =--</t>", MCC_path + "mcc\dialogs\mcc_PopupMenu.sqf",[nil,nil,nil,nil,0], 0,false, false, "teamSwitch","vehicle _target == vehicle _this"];
		player setvariable ["MCC_allowed",true,true];
	};
};
