RAP_fnc_createBaseTrigger = {
	if (isNil "RAP_G_TRIGGERS_BASE" && isServer) then {
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
		"RAP_TRIGGER_BASE"] call CBA_fnc_createTrigger) select 0;

		RAP_G_TRIGGERS_BASE setTriggerInterval 60;
	};
};

RAP_fnc_createMoveOrderSuccessTrigger = {
	params ["_targetLocation", "_groups", "_controlObject"];

	private _trigger = ([_targetLocation, 
		"AREA:", 
		[100, 100, 0, false],
		"ACT:",
		["GUER", "PRESENT", false],
		"STATE:",
		["(_thisList arrayIntersect _groups)",
		"_controlObject setVariable [""moveCompleted"", true]",
		""],
		"NAME:",
		"RAP_TRIGGER_BASE"] call CBA_fnc_createTrigger) select 0;

	_trigger setTriggerTimeout [3, 5, 7, false];
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