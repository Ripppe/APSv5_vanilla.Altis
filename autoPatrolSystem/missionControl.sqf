execVM "autoPatrolSystem\missionParams.sqf";
execVM "autoPatrolSystem\tasks\attack.sqf";
execVM "autoPatrolSystem\actions\move.sqf";

waitUntil {
	!isNil "RAP_BASE_CENTER_LOCATION";
};

[] call RAP_fnc_createBaseTrigger;