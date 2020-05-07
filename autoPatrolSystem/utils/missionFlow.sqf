RAP_fnc_isPatrolInProgress = {
	["Checking if patrol is initialized (%1)", [RAP_PATROL_INITIALIZED]] call RAP_fnc_debugLog;
	RAP_PATROL_INITIALIZED;
};

RAP_fnc_initializePatrol = {
	["Initializing new patrol"] call RAP_fnc_debugLog;
	RAP_PATROL_INITIALIZED = true;
};