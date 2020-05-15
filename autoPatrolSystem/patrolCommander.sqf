RAP_fnc_patrolCommanderInit = {
	params ["_objective", "_force"];

	_objective params ["_originalObjType", "_originalObjPos", "_originalObjParams"];

	/** 
		Commander should supervise what info tasks give back and act accordingly.
		In normal case, a task is conducted from start to finish and when done, patrol is finished

		However, during some phase of a task, a need to change the task arises. For example, attacking
		force moving to FUP encounters so big enemy force, that it must be dealt with "outside" the normal
		movement contingency plan.
	*/

	private _tasksCompleted = false;
	
	while {!_tasksCompleted} do {
		private _taskHandle = nil;
		switch (_originalObjType) do {
			case RAP_PATROL_TASK_ATTACK: {
				_taskHandle = [_originalObjPos, _originalObjParams, _force, RAP_PATROL_FORCE_META] spawn RAP_fnc_patrolCommanderTaskAttack;
				[_taskHandle] call RAP_fnc_patrolCommanderAddHandle;
			};
			default { };
		};

		waitUntil {
			
			sleep 10;
			if (scriptDone _taskHandle) then {
				_tasksCompleted = true;
			};

			_tasksCompleted;
		};
	};
};

RAP_fnc_patrolCommanderTerminateTask = {
	params ["_commandMeta"];

	{
		if (!scriptDone _x) then {
			terminate _x;
		};
	} forEach ([_commandMeta, "HANDLES"] call CBA_fnc_hashGet);

	private _taskMeta = [_commandMeta, "ACTION"] call CBA_fnc_hashGet;

	{
		if (!scriptDone _x) then {
			terminate _x;
		};
	} forEach ([_taskMeta, "HANDLES"] call CBA_fnc_hashGet);

	[_commandMeta, "ACTION", nil] call CBA_fnc_hashSet;
	[_commandMeta, "HANDLES", nil] call CBA_fnc_hashSet;
};

RAP_fnc_patrolCommanderTaskAttack = {
	params ["_originalObjPos", "_originalObjParams", "_force", "_commandMeta"];
	scriptName "patrolCommanderAttack";

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
	private _fup = [_originalObjPos, _redZoneRadius] call RAP_fnc_patrolCommanderSelectFUP;

	// (2) MOVE FORCE TO FUP
	private _actionMeta = [_commandMeta] call RAP_fnc_actionsInitMeta;
	[_force, _originalObjPos, _actionMeta] call RAP_fnc_actionsMoveInit;

	waitUntil {
		[_actionMeta, "COMPLETE"] call CBA_fnc_hashGet;
	};
	
};

RAP_fnc_patrolCommanderSelectFUP = {
	params ["_originalObjPos", "_redZoneRadius"];

	private _baseDir = _originalObjPos getDir RAP_BASE_CENTER_LOCATION;
	private _intersection = _originalObjPos getPos [_redZoneRadius + 10, _baseDir];

	[_intersection, 0, 100, 1, 0, 0, 0, "ObjRedZone", [_intersection, nil]] call BIS_fnc_findSafePos;
};

RAP_fnc_patrolCommanderAddHandle = {
	params ["_handle"];

	[RAP_PATROL_FORCE_META, "HANDLES", _handle] call RAP_fnc_pushBackToHash;
};