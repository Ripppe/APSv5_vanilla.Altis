RAP_fnc_createBaseTrigger = {
	if (isNil "RAP_G_TRIGGERS_BASE" && isServer) then {
		["Create Base trigger at pos (%1)", [RAP_BASE_CENTER_LOCATION]] call RAP_fnc_debugLog;
		RAP_G_TRIGGERS_BASE = ([RAP_BASE_CENTER_LOCATION, 
		"AREA:", 
		[100, 100, 0, false],
		"ACT:",
		["NONE", "PRESENT", true],
		"STATE:",
		["[] call RAP_fnc_isPatrolInProgress",
		"[] call RAP_fnc_initializePatrol",
		"hint 'base deinitialized'"],
		"NAME:",
		"RAP_G_TRIGGERS_BASE"] call CBA_fnc_createTrigger) select 0;

		RAP_G_TRIGGERS_BASE setTriggerInterval 60;
	};
};

RAP_fnc_createAttackTaskControlTrigger = {
	params ["_attackTarget"];

	if (isServer) then {
		private _controller = ([RAP_BASE_CENTER_LOCATION, 
		"AREA:", 
		[0, 0, 0, false],
		"ACT:",
		["NONE", "PRESENT", true],
		"STATE:",
		["true",
		"[] call RAP_fnc_taskAttackController",
		"[""Deleting attack task controller trigger""] call RAP_fnc_debugLog"],
		"NAME:",
		"RAP_TRIGGER_TASK_ATTACK_CONTROL"] call CBA_fnc_createTrigger) select 0;

		_controller setVariable ["attackTarget"];
		_controller setTriggerInterval 10;

		RAP_PATROL_TASK_TRIGGERS pushBack _controller;
	};
};