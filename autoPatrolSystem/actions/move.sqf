RAP_fnc_hasTransportCapability = {
	false;
};

RAP_fnc_move = {
	params ["_group", "_targetPos"];

	private _destination = [_targetPos, 10, 50] call BIS_fnc_findSafePos;

	private _wp = [_group, _destination, 10, "MOVE", "AWARE", "WHITE", "STAG COLUMN"] call CBA_fnc_addWaypoint;
	_wp setWaypointStatements ["true", "hint 'hello'; hint 'goodbye'"];
	//_wp setWaypointCompletionRadius 5;
};

RAP_fnc_preMove = {
	params ["_group", "_targetPos", "_attachedTransportation"];


	// Measure each group's dist to target, sort them in descending order and take first
	private _distance = [_group, _targetPos] call CBA_fnc_getDistance;

	if (_distance > 500) then {
		// We really should call a transport...
	};
};

RAP_fnc_movementMonitor = {
	params ["_group", "_movementHandle", "_meta"];

	// This check will run until a near target is revealed or the script is terminated from outside
	private _nearestEnemy = nil;
	waitUntil {
		sleep 10;

		_nearestEnemy = [_group, _meta] call RAP_fnc_identifyThreatForMovement;
		!isNil "_nearestEnemy";
	};

	// Possibly dangerous target is recognized, what to do?

	[_meta, "movementCompromised", true] call CBA_fnc_hashSet;
	// Terminate movement handling, movement must be resumed after the threat has been dealt with
	terminate _movementHandle;
	// Delete remaining waypoints
	for [{private _index = (count (waypoints _group)) - 1}, {_index > 0}, {_index = _index - 1}] do {
		deleteWaypoint [_group, _index];
	}; 

	private _neutralizeHandle = [_group, _nearestEnemy] spawn RAP_fnc_neutralizeMovementThreat;

	// Add script handle to meta hash map so that it can also be terminated from outside
	[_meta, "neutralizeHandle", _neutralizeHandle] call CBA_fnc_hashSet;
	// Wait for the neutralization
	waitUntil { scriptDone _neutralizeHandle };

	[_meta, "neutralizeHandle"] call CBA_fnc_hashRem;
};

RAP_fnc_identifyThreatForMovement = {
	params ["_group", "_meta"];
	private _threat = _group findNearestEnemy _group;

	if (!isNil "_threat" && ([_group, _threat] call CBA_fnc_getDistance <= 400)) then {
		_threat;
	};
};

RAP_fnc_neutralizeMovementThreat = {
	params ["_group", "_nearestTarget"];
};

RAP_fnc_moveController = {
	params ["_group", "_targetPos", "_meta"];

	/**
		The flow of move:

		1) Does group contain organic transportation?
		2) If does, continue from 4)
		3) If not AND distance is >500 m, require transport
			- Wait for the results of request
			- If yes, wait for randevouz point
			- When randevouz point is received, link groups with transport vehicles
		4) When troops have embarked OR transpot has been denied OR distance is <500
		order move WP to destination
		5) When first group reaches destination order it to defend the area
		6) When all groups have reached the destination, actiion is completed
	 */


	private _preMoveHandle = [_group, _targetPos] spawn RAP_fnc_preMove;

	waitUntil { scriptDone _preMoveHandle };

	private _movementHandle = [_group, _targetPos] spawn RAP_fnc_move;
	private _movementMonitor = [_group, _movementHandle] spawn RAP_fnc_movementMonitor;
};

RAP_fnc_getForce = {
	params ["_forceIdentifier"];

	[RAP_PATROL_FORCE, _forceIdentifier] call CBA_fnc_hashGet;
};

RAP_fnc_createNewForce = {
	params ["_forceIdentifier", "_groups", "_attachedAssets"];

	[RAP_PATROL_FORCE, _forceIdentifier, [_groups, _attachedAssets, nil]] call CBA_fnc_hashSet;
};

RAP_fnc_getActionParam = {
	params ["_forceIdentifier", "_task", "_param"];

	RAP_PATROL_ACTION_PARAMS;
};


// SAVED FOR POSSIBLE LATER USE
/**
RAP_fnc_move = {
	params ["_groups", "_targetPos"];

	{
		_x params ["_group"];

		private _destination = [_targetPos, 10, 50] call BIS_fnc_findSafePos;

		private _wp = [_group, _destination, 10, "MOVE", "AWARE", "WHITE", "STAG COLUMN"] call CBA_fnc_addWaypoint;
		_wp setWaypointStatements ["true", "hint 'hello'; hint 'goodbye'"];
		_wp setWaypointCompletionRadius 5;
	} forEach _groups;
};

RAP_fnc_preMove = {
	params ["_force", "_targetPos"];

	_force params ["_groups", "_attachedAssets", "_attachedTransportation"];

	// Measure each group's dist to target, sort them in descending order and take first
	private _farthestAway = ((_groups apply {[_x, _targetPos] call CBA_fnc_getDistance}) sort false) select 0;

	if (_farthestAway > 500) then {
		// We really should call a transport...
	};
};

RAP_fnc_movementMonitor = {
	params ["_groups", "_movementHandle"];

	waitUntil {
		sleep 10;

		private _expression = _groups findIf {
			(_x nearTargets 400) findIf {
				(_x select 2) == east;
			};
		};
		!isNil "_expression" && { _expression != -1 };
	};
};

RAP_fnc_moveController = {
	params ["_forceIdentifier", "_targetPos", "_meta"];

	private _force = _forceIdentifier call RAP_fnc_getForce;
	_force params ["_groups"];

	private _preMoveHandle = [_force, _targetPos] spawn RAP_fnc_preMove;

	waitUntil { scriptDone _preMoveHandle };

	private _groupsToMove = [_forceIdentifier, RAP_PATROL_ACTION_MOVE, "groupsToMove"];
	private _movementHandle = [_groupsToMove, _targetPos] spawn RAP_fnc_move;
	private _movementMonitor = [_groups, _movementHandle] spawn RAP_fnc_movementMonitor;
};
 */