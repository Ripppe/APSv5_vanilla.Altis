RAP_fnc_isPatrolInProgress = {
	["Checking if patrol is initialized (%1)", [RAP_PATROL_INITIALIZED]] call RAP_fnc_debugLog;
	RAP_PATROL_INITIALIZED;
};

RAP_fnc_initializePatrol = {
	["Initializing new patrol"] call RAP_fnc_debugLog;
	RAP_PATROL_INITIALIZED = true;
	[] call RAP_fnc_resetPatrolParams;

	// Select patrol type/task
	RAP_PATROL_TYPE = [] call RAP_fnc_selectPatrolType;
	// Select patrol zone
	RAP_PATROL_LOCATION = [RAP_PATROL_TYPE] call RAP_fnc_selectPatrolZone;
	// Create patrol marker
	[RAP_PATROL_LOCATION] call RAP_fnc_initializePatrolMarker;

	// Create patrol initial group
	//[7] call RAP_fnc_createPatrolGroups;
	//[35] call RAP_fnc_createPatrolGroup;

	// Get phasing associated to the patrol type
	RAP_PATROL_TASKS = [RAP_PATROL_PHASES, RAP_PATROL_TYPE] call CBA_fnc_hashGet;
	
};

RAP_fnc_createPatrolGroups = {
	params ["_groupCount"];
	
	for [{private _counter = 0}, {_counter < _groupCount}, {_counter = _counter + 1}] do {
		[RAP_PATROL_GROUPS] call RAP_fnc_createSinglePatrolGroup;
	}; 
};

RAP_fnc_createPatrolGroup = {
	params ["_unitCount",
	["_composition", ["I_soldier_F", "I_support_MG_F", "I_Soldier_GL_F", "I_Soldier_M_F", "I_medic_F"]],
	["_location", RAP_BASE_CENTER_LOCATION]];
	
	["Create new patrol group at %1 from composition %2", [_location, _composition]] call RAP_fnc_debugLog;
	private _units = [];
	private _compositionCount = count _composition;
	for [{private _counter = 0}, {_counter <= _unitCount}, {_counter = _counter + 1}] do {
		private _index = if (_counter >= _compositionCount) then { _counter % _compositionCount; } else { _counter };
		_units pushBack (_composition select _index);
	};

	["Selected units: %1", [_units]] call RAP_fnc_debugLog;

	private _patrolGroup = [independent, _units, _location, 50] call RAP_fnc_createGroup;
	//_patrolGroup setName "PatrolMainForce";

	[RAP_PATROL_FORCE, "mainGroup", _patrolGroup] call CBA_fnc_hashSet;
};

RAP_fnc_createSinglePatrolGroup = {
	params ["_groupVariable", 
	["_groupMetaInfo", []], 
	["_composition", ["I_soldier_F", "I_support_MG_F", "I_Soldier_GL_F", "I_Soldier_M_F", "I_medic_F"]],
	["_location", RAP_BASE_CENTER_LOCATION]];

	private _newGroup = [independent, _composition, _location, 50] call RAP_fnc_createGroup;
	private _groupSize = count units _newGroup;
	private _lastPosition = getPos _newGroup;
	private _combinedMeta = [_groupSize, _lastPosition] append _groupMetaInfo;
	_groupVariable pushBack [_newGroup, _combinedMeta];
};

RAP_fnc_createGroup = {
	params ["_groupSide", "_units", "_spawnPos", "_area", "_initialOrder"];

	private _pos = [_spawnPos, 2, _area] call BIS_fnc_findSafePos;
	private _newGroup = createGroup _groupSide;
	//_newGroup setVariable ["reggsAPSAutoGenerated", true, true];

	private _fireTeam = [];

	{
		private _unit = _newGroup createUnit [_x, _pos, [], 0.1, "none"];
		_fireTeam pushBack _unit;
	} forEach _units;

	["Created new group for %1 with size of %2 and units %3", [_groupSide, count _units, _units]] 
	call RAP_fnc_debugLog;

	if _initialOrder then {
        ["Initial order received: %1", [_initialOrder]] call RAP_fnc_debugLog;
    };

	_newGroup;
};

RAP_fnc_selectPatrolType = {
	private _selectedPatrolType = selectRandom RAP_G_PATROL_TYPES;
	["Selected patrol type: %1", [_selectedPatrolType]] call RAP_fnc_debugLog;
};

RAP_fnc_selectPatrolZone = {
	params ["_patrolType"];

	RAP_G_PATROL_ZONE_DISTANCE params ["_minDist", "_maxDist"];
	([RAP_G_PATROL_TYPE_DATA, _patrolType] call CBA_fnc_hashGet) params ["_suitableLocations"];

	private _possibleLocations = nearestLocations [RAP_BASE_CENTER_LOCATION, _suitableLocations, _maxDist];
	
	//TODO: Backup mechanism for situations where there are no suitable locations found
	[_possibleLocations, true] call CBA_fnc_shuffle;
	private _selectedLocation = _possibleLocations findIf {
		private _dist = [RAP_BASE_CENTER_LOCATION, _x] call CBA_fnc_getDistance;
		_dist >= _minDist;
	};

	if (_selectedLocation == -1) then {
		selectRandom _possibleLocations;
	} else {
		_possibleLocations select [_selectedLocation];
	};
};

RAP_fnc_generateFlowTriggers = {
	params ["_tasks", "_patrolObjLocation"];

	RAP_PATROL_CURRENT_TASK = _tasks deleteAt 0;
	switch (RAP_PATROL_CURRENT_TASK) do {
		case RAP_PATROL_TASK_MOVE_TO_FUP: {};
	};
};

RAP_fnc_despawnForceGroup = {
	{
		private _group = [RAP_PATROL_FORCE, _x] call CBA_fnc_hashGet;
		{
			deleteVehicle _x;
		} forEach units _group;

		deleteGroup _group;
	} forEach ([RAP_PATROL_FORCE] call CBA_fnc_hashKeys);

	RAP_PATROL_FORCE = [] call CBA_fnc_hashCreate;;
};



MY_TEST_HASH = [] call CBA_fnc_hashCreate;
RAP_fnc_hashTest = {
	params ["_hash"];

	private _counter = 0;
	while {_counter < 100} do {
		_counter = _counter + 1;
		[_hash, "test", random [0, 50, 100]] call CBA_fnc_hashSet;
		sleep 5;
	};
};

RAP_fnc_hashTestStart = {
	[MY_TEST_HASH] spawn RAP_fnc_hashTest;
};