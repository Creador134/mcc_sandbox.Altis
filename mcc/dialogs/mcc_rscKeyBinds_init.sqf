private ["_key","_x","_text"];
disableSerialization;
//Show key Binds
for [{_x=8415},{_x<=8420},{_x=_x+1}]  do 
{
	_key = MCC_keyBinds select (_x-8415);

	_text = "";
	if (_key select 0) then {_text = "Shift + "}; 
	if (_key select 1) then {_text = _text + "Ctrl + "}; 
	if (_key select 2) then {_text = _text + "Alt + "}; 
	
	_text = format ["%1%2",_text,keyName (_key select 3)];

	ctrlsettext [_x, _text];
};