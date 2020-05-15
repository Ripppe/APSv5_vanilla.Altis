RAP_fnc_actionsInitMeta = {
	params ["_commandMeta"];

	private _actionMeta = [[["COMPLETE", false]]] call CBA_fnc_hashCreate;
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

execVM "autoPatrolSystem\actions\move.sqf";