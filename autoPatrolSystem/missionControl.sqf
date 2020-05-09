execVM "autoPatrolSystem\missionParams.sqf";
execVM "autoPatrolSystem\tasks\attack.sqf";
execVM "autoPatrolSystem\actions\move.sqf";

[] call RAP_fnc_createBaseTrigger;