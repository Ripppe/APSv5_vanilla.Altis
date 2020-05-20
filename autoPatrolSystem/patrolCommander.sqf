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
	params ["_objective", "_objectiveParams", "_commandMeta"];

	/** 
		Commander should supervise what info tasks give back and act accordingly.
		In normal case, a task is conducted from start to finish and when done, patrol is finished

		However, during some phase of a task, a need to change the task arises. For example, attacking
		force moving to FUP encounters so big enemy force, that it must be dealt with "outside" the normal
		movement contingency plan.
	*/

	private _allTasksCompleted = false;
	[_commandMeta, _objective, _objectiveParams] call RAP_fnc_patrolCommanderInitTask;
	
	while {!_allTasksCompleted} do {
		waitUntil {
			sleep 10;

			private _firstUndoneTask = ([_commandMeta, "TASKS"] call CBA_fnc_hashGet) findIf { !scriptDone _x };
			if (_firstUndoneTask == -1) then {
				_allTasksCompleted = true;
			};

			_allTasksCompleted;
		};
	};
};

RAP_fnc_patrolCommanderInitTask = {
	params ["_commandMeta", "_units", "_taskType", ["_taskParams", []]];

	private _newTaskParams = +_taskParams;
	private _taskMeta = [[["TYPE", _taskType], ["PARAMS", _newTaskParams], ["UNITS", _units]]] call CBA_fnc_hashCreate;
	private _taskHandle = nil;
	switch (_taskType) do {
		case RAP_PATROL_TASK_ATTACK: {
			_taskHandle = _newTaskParams spawn RAP_fnc_tasksAttackInit;
		};
		default { };
	};

	[_taskMeta, "HANDLE", _taskHandle] call CBA_fnc_hashSet;
	[_commandMeta, _taskMeta] call RAP_fnc_patrolCommanderAddTask;
};

/** Terminating a task involves:
	- terminating all action handles (possibly an own function for each action type?)
	- terminating task handle
 */
RAP_fnc_patrolCommanderTerminateTask = {
	params ["_commandMeta"];

	// {
	// 	if (!scriptDone _x) then {
	// 		terminate _x;
	// 	};
	// } forEach ([_commandMeta, "HANDLES"] call CBA_fnc_hashGet);

	// private _actionMeta = [_commandMeta, "ACTION"] call CBA_fnc_hashGet;

	// [_actionMeta] call RAP_fnc_actionsResetHandles;

	// [_commandMeta, "ACTION", nil] call CBA_fnc_hashSet;
	// [_commandMeta, "HANDLES", nil] call CBA_fnc_hashSet;
};

RAP_fnc_patrolCommanderAddTask = {
	params ["_commandMeta", "_taskMeta"];

	[_commandMeta, "TASKS", _taskMeta] call RAP_fnc_pushBackToHash;
};

RAP_fnc_patrolCommanderTerminate = {
	params ["_commanderHandle", "_commandMeta"];

	[_commandMeta] call RAP_fnc_patrolCommanderTerminateTask;

	if (!scriptDone _commanderHandle) then {
		terminate _commanderHandle;
	};
};