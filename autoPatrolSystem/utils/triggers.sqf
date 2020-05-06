RAP_fnc_createBaseTrigger = {
	if (isNil "RAP_BASE_TRIGGER") then {
		RAP_BASE_TRIGGER = ([RAP_BASE_CENTER_LOCATION, 
		"AREA:", 
		[100, 100, 0, false],
		"ACT:",
		["NONE", "PRESENT", true],
		"STATE:",
		["[] call RAP_fnc_isPatrolinProgress",
		"hint 'base initialized'",
		"hint 'base deinitialized'"]] call CBA_fnc_createTrigger) select 0;

		RAP_BASE_TRIGGER setTriggerInterval 60;
	};
};