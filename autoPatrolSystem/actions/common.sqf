RAP_fnc_actionsInitMeta = {
	params ["_taskMeta"];

	private _actionMeta = [[["COMPLETE", false]]] call CBA_fnc_hashCreate;
	[_taskMeta, "ACTIONS", _actionMeta] call RAP_fnc_pushBackToHash;

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

RAP_fnc_actionsSubtractUnitsFromAction = {
	params ["_numberOfUnits", "_actionMeta"];
};

RAP_fnc_actionsReinforceActionWithUnits = {
	params ["_units", "_actionMeta"];
};

execVM "autoPatrolSystem\actions\move.sqf";