//==================================================================fnc_DoInfPatrol===============================================================================================
// Generate some stuff to do for our awesome patrol
// Example: [_group,_zone] call fnc_DoFortify
// spirit 11-2-2014
//===========================================================================================================================================================================	
private ["_group","_TargetPos"];

_group 			= _this select 0; 
_TargetPos	=	_this select 1;

[leader _group ,50,true,[60,3],false,false] spawn gaia_garrison_script;

//Lets set the current Order.
_group setVariable ["GAIA_Order"							, "DoFortify", false];
//Also note when we gave that order and where the unit was. It gives us a chance to check his progress and to 'unstuck' him if needed.
//Also all orders have a lifespan. MCC_GAIA_ORDERLIFETIME
_group setVariable ["GAIA_OrderTime"					, Time, false];
_group setVariable ["GAIA_OrderPosition"			, _TargetPos, false];

true


