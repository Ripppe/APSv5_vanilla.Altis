RAP_fnc_patrolCommanderInit = {
	params ["_objective", "_force", "_side"];

	private _patrolUnits = [];
	{
		_patrolUnits append (units _x);
	} forEach _force;

	private _commandMeta = [[["UNITS", _patrolUnits],
	["SIDE", _side]]] call CBA_fnc_hashCreate;

	[_objective, _commandMeta] spawn RAP_fnc_patrolCommanderProcess;
	
};

RAP_fnc_patrolCommanderProcess = {
	params ["_objective", "_commandMeta"];

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
				_taskHandle = [_originalObjPos, _originalObjParams, RAP_PATROL_FORCE_META] 
				spawn RAP_fnc_tasksAttackInit;
				[_taskHandle] call RAP_fnc_patrolCommanderAddHandle;
			};
			default { };
		};

		waitUntil {
			
			sleep 10;
			if (scriptDone _taskHandle || isNil "_taskHandle") then {
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

	private _actionMeta = [_commandMeta, "ACTION"] call CBA_fnc_hashGet;

	[_actionMeta] call RAP_fnc_actionsResetHandles;

	[_commandMeta, "ACTION", nil] call CBA_fnc_hashSet;
	[_commandMeta, "HANDLES", nil] call CBA_fnc_hashSet;
};

RAP_fnc_patrolCommanderAddHandle = {
	params ["_handle", "_commandMeta"];

	[_commandMeta, "HANDLES", _handle] call RAP_fnc_pushBackToHash;
};

RAP_fnc_patrolCommanderTerminate = {
	params ["_commanderHandle", "_commandMeta"];

	[_commandMeta] call RAP_fnc_patrolCommanderTerminateTask;

	if (!scriptDone _commanderHandle) then {
		terminate _commanderHandle;
	};
};