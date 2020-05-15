RAP_fnc_tasksAttackInit = {
	params ["_originalObjPos", "_originalObjParams", "_force", "_commandMeta"];
	scriptName "RAP_fnc_taskAttack";

	_originalObjParams params ["_redZoneRadius"];
	/**
		PROCESS OF ATTACK
		(1) FIND FUP
		(2) MOVE FORCE TO FUP (action)
		(3) ATTACK FROM FUP TO OBJ (action)
		(4) SECURE OBJ (action)
		(5) RTB (action)
	*/

	// (1) FIND FUP
	private _fup = [_originalObjPos, _redZoneRadius] call RAP_fnc_tasksAttackSelectFUP;

	// (2) MOVE FORCE TO FUP
	private _actionMeta = [_commandMeta] call RAP_fnc_actionsInitMeta;
	[_force, _originalObjPos, _actionMeta] call RAP_fnc_actionsMoveInit;

	waitUntil {
		[_actionMeta, "COMPLETE"] call CBA_fnc_hashGet;
	};
	
};

RAP_fnc_tasksAttackSelectFUP = {
	params ["_originalObjPos", "_redZoneRadius"];

	private _baseDir = _originalObjPos getDir RAP_BASE_CENTER_LOCATION;
	private _intersection = _originalObjPos getPos [_redZoneRadius + 10, _baseDir];

	[_intersection, 0, 100, 1, 0, 0, 0, "ObjRedZone", [_intersection, nil]] call BIS_fnc_findSafePos;
};