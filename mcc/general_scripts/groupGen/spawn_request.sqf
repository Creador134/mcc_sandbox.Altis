//Made by Shay_Gman (c) 09.10
#define groupGen_IDD 2994

#define UNIT_TYPE 3010
#define UNIT_CLASS 3011
#define MCC_GGUNIT_TYPE 3012
#define MCC_GGUNIT_EMPTY 3016
#define MCC_GGUNIT_BEHAVIOR 3030

private ["_type","_mccdialog","_comboBox","_displayname","_index","_wpType","_wpComabt","_wpFormation","_wpSpeed","_wpBehavior","_nul",
		 "_wpText","_wpTextStatement","_wpTimOut","_spawnType","_classtype","_timeout","_groupArray","_zonePos","_group"];
disableSerialization;

_type = _this select 0;

_mccdialog = findDisplay groupGen_IDD;
MCC_groupBroadcast = []; 
MCC_isEmpty = if (ctrlShown (_mccdialog displayCtrl MCC_GGUNIT_EMPTY) && (lbCurSel MCC_GGUNIT_EMPTY == 1) && (count MCC_groupGenCurrenGroupArray == 0)) then {true} else {false};  
if !mcc_isloading then	
{
	
	//Case we are spawning a cfg Group
	if ((lbCurSel MCC_GGUNIT_TYPE) == 1) then
	{
		//Paratroopers
		if ((((MCC_groupTypes select (lbCurSel UNIT_TYPE) select 0)) =="Reinforcement") && !(_type==0)) exitWith 	
		{
			mcc_spawnname = (lbCurSel UNIT_CLASS);    //MCCR14 remove
			mcc_spawntype="Reinforcement";
			mcc_classtype = "Reinforcement";
			mcc_spawnfaction = mcc_faction;
			
			click = false;

			hint parseText format["<br/>--------------------------<br/>	
			<br/><t size='1.2' color='#33CC00'>Left click on the map to set start location (direction) of reinforcement</t><br/>
			<br/>--------------------------<br/>"]; 
			
			onMapSingleClick "mcc_spawn_dir = _pos;
			click = true;
			onMapSingleClick """";" ;
				
			waitUntil {(click)};
			hintsilent "";
			click = false;
		};  
		
		//Garrison
		if ((((MCC_groupTypes select (lbCurSel UNIT_TYPE) select 0)) =="Garrison")  && !(_type==0)) exitWith 
		{							
			private ["_center","_radius","_action","_intanse","_faction"];
			
			//Failsafe incase we trying to spawn something without making a zone first
			if (count mcc_zone_pos == 0) exitWith {hint "Create a zone first"};	
		
			_center = (mcc_zone_pos select (mcc_zone_number));
			_radius = (((mcc_zone_size select (mcc_zone_number))select 0) + ((mcc_zone_size select (mcc_zone_number)) select 1))/2;
			_faction = getText (configFile >> "CfgVehicles" >> (U_GEN_SOLDIER select 0 select 1) >> "faction");
			
			switch (lbCurSel UNIT_CLASS) do		
			{
				case 0:	//Light
				{
					_action 	= 0;
					_intanse 	= 0.5;
				};

				 case 1:	//Light -vehicles
				{
					_action 	= 1;
					_intanse 	= 0.5;
				};

				 case 2:	//Heavy
				{
					_action 	= 0;
					_intanse 	= 1.5;
				};

				 case 3:	//Heavy -vehicles
				{
					_action 	= 1;
					_intanse 	= 1.5;
				};
			};
			
			if (MCC_capture_state) then	
			{
				MCC_capture_var = MCC_capture_var + FORMAT ['
					[[%1,%2,%3,%4,"%5","%6"],"MCC_fnc_garrison",true,false] call BIS_fnc_MP;;
					'
					,_center
					,_radius
					,_action
					,_intanse
					,_faction
					,mcc_sidename
					];
			} 
			else 
			{
					mcc_safe = mcc_safe + FORMAT ['
					[[%1,%2,%3,%4,"%5","%6"],"MCC_fnc_garrison",true,false] call BIS_fnc_MP;;
					'
					,_center
					,_radius
					,_action
					,_intanse
					,_faction
					,mcc_sidename
					];
					[[_center,_radius,_action,_intanse,_faction,mcc_sidename],"MCC_fnc_garrison",true,false] call BIS_fnc_MP;;
			};
		};
			
		mcc_spawntype="GROUP";
	
		if (((MCC_groupTypes select (lbCurSel UNIT_TYPE) select 0)) =="Custom")
		then
		{
			_comboBox = _mccdialog displayCtrl UNIT_CLASS;	
			_classtype = MCC_customGroupsSave select (call compile (_comboBox lbData (lbCurSel UNIT_CLASS)));
			if (isnil "_classtype") exitWIth {}; 
			
			MCC_groupBroadcast  = (_classtype select 2);
			
			mcc_classtype = _classtype select 1;
			mcc_spawnname = _classtype select 3;
			mcc_spawnfaction = _classtype select 2;
			mcc_spawndisplayname = _classtype select 3;
		}
		else
		{
			_classtype	= (MCC_groupArray select (lbCurSel UNIT_CLASS)) select 2;
			if (isnil "_classtype") exitWIth {}; 
			
			MCC_groupBroadcast = _classtype;
			
			mcc_classtype = (MCC_groupArray select (lbCurSel UNIT_CLASS)) select 0;
			mcc_spawnname = (MCC_groupArray select (lbCurSel UNIT_CLASS)) select 1;
			mcc_spawnfaction = (MCC_groupArray select (lbCurSel UNIT_CLASS)) select 2;
			mcc_spawndisplayname = (MCC_groupArray select (lbCurSel UNIT_CLASS)) select 3;
		};
	}
	else		//Case we are spawning a unit 
	{
		//Case we are spawning a unit with out a group. 
		if (count MCC_groupGenCurrenGroupArray == 0) then
		{
			_groupArray = []; 
			switch (lbCurSel UNIT_TYPE) do		//Which unit do we want
			{
			   case 0:	//Infantry
				{
					_groupArray = U_GEN_SOLDIER;
					mcc_spawntype="MAN";
				};
				
				case 1:	//Car
				{
					_groupArray = U_GEN_CAR;
					mcc_spawntype="VEHICLE";
				};
				
				case 2:	//Tank
				{
					_groupArray = U_GEN_TANK;
					mcc_spawntype="VEHICLE";
				};
				
				case 3:	//Motorcycle
				{
					_groupArray = U_GEN_MOTORCYCLE;
					mcc_spawntype="VEHICLE";
				};
				
				case 4:	//Helicopter
				{
					_groupArray = U_GEN_HELICOPTER;
					mcc_spawntype="VEHICLE";
				};
				
				case 5:	//Aircraft
				{
					_groupArray = U_GEN_AIRPLANE;
					mcc_spawntype="VEHICLE";
				};
				
				case 6:	//Ship
				{
					_groupArray = U_GEN_SHIP;
					mcc_spawntype="VEHICLE";
				};
						
				case 7:	//DOC
				{
					_groupArray = GEN_DOC1;
					mcc_spawntype="DOC";
				};
				
				case 8:	//AMMO
				{
					_groupArray = U_AMMO;
					mcc_spawntype="AMMO";
				};
			};
			
			if ((lbCurSel UNIT_CLASS) != -1) then
			{
				_classtype	= (_groupArray select (lbCurSel UNIT_CLASS)) select 1;
				MCC_groupBroadcast = [_classtype];
				
				mcc_classtype = (_groupArray select (lbCurSel UNIT_CLASS)) select 0;
				mcc_spawnname = (_groupArray select (lbCurSel UNIT_CLASS)) select 1;
				mcc_spawnfaction = (_groupArray select (lbCurSel UNIT_CLASS)) select 2;
				mcc_spawndisplayname = (_groupArray select (lbCurSel UNIT_CLASS)) select 3;
			};
		}
		else
		{
			MCC_groupBroadcast = MCC_groupGenCurrenGroupArray;
		};
	};
	
	//Spawn Group
	//Spawn in mouse Click
	if ((_type==0) && !(((MCC_groupTypes select (lbCurSel UNIT_TYPE) select 0)) in ["Reinforcement","Garrison"])) then	
	{	
		if (typeName MCC_groupBroadcast != "STRING") then
		{
			if (count MCC_groupBroadcast == 0) exitWIth {player sidechat "Cannot spawn an empty group"}; 
		};
		click = false; 
		_timeout = time + 5; 
		hint "click on the map"; 
		onMapSingleClick " 	hint ""Group Spawned."";
						click = true; 
						mcc_safe = mcc_safe + FORMAT ['
									[[%1 , %2, %3, %4, %5],""MCC_fnc_groupSpawn"",false,false] spawn BIS_fnc_MP;
									sleep 1;'
									, _pos
									, MCC_groupBroadcast
									, mcc_hc
									, mcc_sidename
									, MCC_isEmpty
									];
						[[_pos, MCC_groupBroadcast, mcc_hc, mcc_sidename, MCC_isEmpty],'MCC_fnc_groupSpawn',false,false] spawn BIS_fnc_MP;
						onMapSingleClick """";";
		waituntil {click || (time > _timeout)}; 
		sleep 1; 
		[west,east,resistance,civilian] execVM format ["%1mcc\general_scripts\groupGen\group_manage.sqf",MCC_path];	//Refresh the group WP
	}
	//Spawn to zone
	else
	{
		//Failsafe NO group selected
		if ((lbCurSel UNIT_CLASS) == -1) exitWith {player sidechat "Cannot spawn an empty group"}; 
		
		//Failsafe incase we trying to spawn something without making a zone first
		if (count mcc_zone_pos == 0) exitWith {hint "Create a zone first"};	
		
		//Failsafe incase we trying to spawn something without making a zone first
		_zonePos = (mcc_zone_pos select (lbCurSel ((uiNamespace getVariable "MCC_groupGen_Dialog") displayCtrl 1023))+1);
		if (isnil "_zonePos") exitWith {hint "Create a zone first"};

		mcc_spawnwithcrew = (MCC_spawn_empty select (lbCurSel MCC_GGUNIT_EMPTY)) select 1;	//let's add the behavior/awerness
		MCC_empty_index = (lbCurSel MCC_GGUNIT_EMPTY);

		mcc_spawnbehavior = (MCC_spawn_behaviors select (lbCurSel MCC_GGUNIT_BEHAVIOR)) select 1;
		MCC_behavior_index = (lbCurSel MCC_GGUNIT_BEHAVIOR);

		mcc_awareness = "default";
		
		_nul=[4] execVM MCC_path + "mcc\general_scripts\mcc_SpawnStuff.sqf";
		sleep 1; 
		[west,east,resistance,civilian] execVM format ["%1mcc\general_scripts\groupGen\group_manage.sqf",MCC_path];	//Refresh the group WP
	};
};
