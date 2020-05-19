RAP_fnc_actionsInitMeta = {
	params ["_commandMeta"];

	private _actionMeta = [[
		["COMPLETE", false], 
		["SIDE", [_commandMeta, "SIDE"] call CBA_fnc_hashGet]]] call CBA_fnc_hashCreate;
	[_commandMeta, "ACTION", _actionMeta] call CBA_fnc_hashSet;

	_actionMeta;
};

RAP_fnc_actionsResetHandles = {
	params ["_actionMeta"];

	{
		if (!scriptDone _x) then {
			terminate _x;
		};
	} forEach ([_actionMeta, "HANDLES"] call CBA_fnc_hashGet);

	[_actionMeta, "HANDLES", []] call CBA_fnc_hashSet;
};

RAP_fnc_actionsCombineUnitsToGroup = {
	params ["_units", "_group", "_side"];

	if (isNil "_group") then {
		_group = createGroup _side;
	};

	_units join _group;
	_group;
};

execVM "autoPatrolSystem\actions\move.sqf";