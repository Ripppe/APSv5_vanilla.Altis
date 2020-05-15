execVM "autoPatrolSystem\missionParams.sqf";
execVM "autoPatrolSystem\tasks\attack.sqf";
execVM "autoPatrolSystem\actions\common.sqf";

RAP_fnc_missionControlStart = {
	RAP_MISSION_CONTROL_HANDLE = [] spawn RAP_fnc_missionControl;
};

RAP_fnc_missionControlTerminate = {
	if (!isNil "RAP_MISSION_CONTROL_HANDLE" && 
	!scriptDone RAP_MISSION_CONTROL_HANDLE) then {
		terminate RAP_MISSION_CONTROL_HANDLE;
	};
};

RAP_fnc_missionControl = {
	while {true} do {
		waitUntil {
			sleep 30;
			!([] call RAP_fnc_isPatrolInProgress);
		};

		[] call RAP_fnc_initializePatrol;
		
	};
};

[] call RAP_fnc_missionControlStart;