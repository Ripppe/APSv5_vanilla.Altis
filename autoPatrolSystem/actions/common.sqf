RAP_fnc_actionsInitMeta = {
	params ["_commandMeta"];

	private _actionMeta = [[["COMPLETE", false]]] call CBA_fnc_hashCreate;
	[_commandMeta, "ACTION", _actionMeta] call CBA_fnc_hashSet;

	_actionMeta;
};

execVM "autoPatrolSystem\actions\move.sqf";