RAP_fnc_createBaseTrigger = {
	if (isNil "RAP_BASE_TRIGGER" && isServer) then {
		RAP_G_TRIGGERS_BASE = ([RAP_BASE_CENTER_LOCATION, 
		"AREA:", 
		[100, 100, 0, false],
		"ACT:",
		["NONE", "PRESENT", true],
		"STATE:",
		["[] call RAP_fnc_isPatrolInProgress",
		"[] call RAP_fnc_initializePatrol",
		"hint 'base deinitialized'"]] call CBA_fnc_createTrigger) select 0;

		RAP_G_TRIGGERS_BASE setTriggerInterval 60;
	};
};