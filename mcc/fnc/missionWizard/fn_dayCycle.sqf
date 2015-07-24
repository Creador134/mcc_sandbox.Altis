//======================================================MCC_fnc_dayCycle=================================================================================================
//Control day and night cycle gain tickets and change weather every day
//==============================================================================================================================================================================
private ["_startDate","_goingUp","_overcast","_WindForce","_Waves","_Rain","_Lightnings","_fog","_time","_sidePlayer","_evac","_sideRep","_sidePlayer2","_CompleteText","_ticketsGain","_resources"];
waitUntil {time >0};

_sidePlayer = [_this, 0, west, [west]] call BIS_fnc_param;
_sidePlayer2 = [_this, 1, sideLogic, [sideLogic]] call BIS_fnc_param;

_startDate = dateToNumber date;
_sideRep = 0;

while {true} do {
	while {(dateToNumber date - _startDate) < 0.00273973} do {sleep 1};
	_startDate = dateToNumber date;

	_CompleteText =         "<t align='center' size='1.8' color='#FFCF11'> Day End</t><br/>"
								+"____________________<br/>";

	//Turn food and meds into tickets
	{
		_resources = missionNamespace getvariable [format ["MCC_res%1",_x],[500,500,200,200,100]];
		_ticketsGain = floor ((_resources select 3)/50 + (_resources select 4)/10);

		if (_ticketsGain > 0) then {
			_CompleteText = _CompleteText 	+ "Good job you have survived another day<br/>"
											+ format ["You have enough <img image='%1data\IconFood.paa'/> food and <img image='%1data\IconMed.paa'/> meds to support additional troops<br/>",MCC_path]
											+ format ["HQ sends you %1 additional soldiers (tickets) as reinforcements<br/>",_ticketsGain]
											+ "____________________<br/><br/>";

		} else {
			_CompleteText = _CompleteText 	+ "You have survived another day<br/>"
											+ format ["You don't have enough <img image='%1data\IconFood.paa'/> food and <img image='%1data\IconMed.paa'/> meds to support additional troops<br/>",MCC_path]
											+ "HQ is unable to send you additional soldiers (tickets) at this time<br/>"
											+ "____________________<br/><br/>";
		};


		//Zero down meds and food
		_resources set [3,0];
		_resources set [4,0];

		missionNamespace setvariable [format ["MCC_res%1",_x],_resources];
		publicVariable format ["MCC_res%1",_x];

		//add tickets
		[_x, _ticketsGain] call BIS_fnc_respawnTickets;

		//Respawn EVAC
		private ["_varName","_evacVehicles"];
		_varName = format ["MCC_campaignEvac_%1", _x];
		_evacVehicles = missionNamespace getVariable [_varName,[]];

		if (count _evacVehicles > 0) then {
			{
				_evac = _x select 0;

				if (!(alive _evac) || !(alive driver _evac) || isNull _evac) then {
					[_x select 1, _x select 2, true] spawn MCC_fnc_evacSpawn;
					_CompleteText = _CompleteText 	+  "<t align='center' size='1.2' color='#FFCF11'> EVAC</t><br/>"
													+ "HQ Sends you some new evac vehicles try to keep it safe this time<br/>"
													+ "____________________<br/><br/>";
				};
			} forEach _evacVehicles;
		};

		//War effort
		if !(_x in [sideLogic,_sidePlayer2]) then {
			_sideRep = (missionNamespace getvariable [format ["campaignRep_%1",_x],0])*0.9; //rep decrease by 10% every day
			_sideRep = (_sideRep + _ticketsGain*2) min 90;

			if (random 100 < _sideRep) then {
				MCC_GAIA_AC = true;
				_CompleteText = _CompleteText 	+  "<t align='center' size='1.2' color='#FFCF11'> Infamous Level</t><br/>"
													+ "Warning, Your actions did not go unnoticed, enemy forces are now actively hunting your forces. <br/>"
													+ "____________________<br/><br/>";
			} else {
				MCC_GAIA_AC = false;
				_CompleteText = _CompleteText 	+  "<t align='center' size='1.2' color='#FFCF11'> Infamous Level</t><br/>"
													+ "Enemy forces are not searching for your forces<br/>"
													+ "____________________<br/><br/>";

			};
			missionNamespace setvariable [format ["campaignRep_%1",_x],_sideRep];
			publicVariable format ["campaignRep_%1",_x];
			publicVariable "MCC_GAIA_AC";

			//Change weather
			_goingUp =  if ((date select 1) in [11,12,1,2,3,4]) then {random 1 > 0.3} else {random 1 > 0.7};

			_time = 60;
			if (_goingUp) then {
				_overcast = (overcast +0.2) min 1;
				_WindForce = (windStr +0.2) min 1;
				_Waves = (Waves +0.2) min 1;
				_Rain = (Rain +0.2) min 1;
				_Lightnings = (Lightnings +0.2) min 1;
				_fog = (fog +0.2) min 0.6;
			} else {
				_overcast = (overcast -0.2) max 0;
				_WindForce = (windStr -0.2) max 0;
				_Waves = (Waves -0.2) max 0;
				_Rain = (Rain -0.2) max 0;
				_Lightnings = (Lightnings -0.2) max 0;
				_fog = (fog -0.2) max 0;
			};
			[[[_overcast, _WindForce, _Waves, _Rain, _Lightnings,_fog,_time]],"MCC_fnc_setWeather",true,false] spawn BIS_fnc_MP;


			_CompleteText = _CompleteText 	+  "<t align='center' size='1.2' color='#FFCF11'> Weather</t><br/>"
												+ format ["It seems like today weather is goint to get %1<br/>", if (_goingUp) then {"worse"} else {"better"}]
												+ "____________________<br/><br/>";
		};


		//Send hint
		[[_CompleteText,true],"MCC_fnc_globalHint",_x,false] spawn BIS_fnc_MP;

	} forEach [_sidePlayer,_sidePlayer2];

	sleep 0.1;
};