sleep 10;

// Load functions
execVM "autoPatrolSystem\utils\misc.sqf";
execVM "autoPatrolSystem\utils\triggers.sqf";
execVM "autoPatrolSystem\utils\markers.sqf";
execVM "autoPatrolSystem\patrolParams.sqf";
execVM "autoPatrolSystem\missionFlow.sqf";

// initialise APS
execVM "autoPatrolSystem\missionControl.sqf";
execVM "autoPatrolSystem\patrolCommander.sqf";

waitUntil {
	!isNil "RAP_BASE_CENTER_LOCATION";
};

[] call RAP_fnc_createBaseTrigger;