RAP_fnc_hasTransportCapability = {
	false;
};

RAP_fnc_move = {
	params ["_group", "_targetPos", "_actionMeta"];

	[_actionMeta, "PHASE", "EXE"] call CBA_fnc_hashSet;
	private _movementType = [_actionMeta, "movementType"] call CBA_fnc_hashGet;
	private _destination = [_targetPos, 0, 50, 2] call BIS_fnc_findSafePos;

	private _wp = [_group, _destination, 10, "MOVE", "AWARE", "WHITE", "STAG COLUMN"] call CBA_fnc_addWaypoint;
	_wp setWaypointStatements ["true", "[_actionMeta, ""moveCompleted"", true] call CBA_fnc_hashSet"];
	//_wp setWaypointCompletionRadius 5;
};

RAP_fnc_preMove = {
	params ["_group", "_targetPos", "_actionMeta"];

	/**
		PRE-MOVE should consider the following

		Does group have organic transportation?
		If group has organic transportation, does it provide enough space? If not, request resupply
		If group hasn't organic transportation, check if transportation has been asked and granted
		If transportation has been granted, does it provide enough space? If not, and there is no need for ride
		disband transportation back. Otherwise request resupply.
		If transportation hasn't been granted, continue.

		The need for external transportation is relevant to the distance to the objective.
		If transportation has been granted, link up the group with it
		Once transportation and the group are close enough, get in if necessary? (If transportation is attached
		to the group, do they automatically use it?)
	*/

	private _movementType = [_actionMeta, "movementType"] call CBA_fnc_hashGet;

	if (["STEALTH", "LINK-UP"] find _movementType != -1) exitWith {
		true;
	};

	private _transportationAllowed = [_actionMeta, "transportationAllowed"] call CBA_fnc_hashGet;

	// Measure group's dist to target pos
	private _distance = [_group, _targetPos] call CBA_fnc_getDistance;

	if (_distance > 1000) then {

	};
};

RAP_fnc_identifyThreatForMovement = {
	params ["_group", "_threatDistance", "_actionMeta"];

	private _threat = nil;
	private _unit = (units _group) findIf {
		private _closestThreat = _x findNearestEnemy _group;
		if (!isNil "_closestThreat" && ([_group, _closestThreat] call CBA_fnc_getDistance <= _threatDistance)) then {
			_threat = _closestThreat;
		};
	};
	
	// Group knows about an enemy, check if they are nearer than a treshold
	if (_unit != -1) then {
		_threat;
	};
	
};

RAP_fnc_neutralizeMovementThreat = {
	params ["_group", "_nearestTarget", "_actionMeta"];

	private _startTimestamp = diag_tickTime;
	[_actionMeta, "COMPROMISE-ELAPSED", 0] call CBA_fnc_hashSet;
	// Possibly dangerous target is recognized, what to do?

	// Clear waypoints...
	[_group] call CBA_fnc_clearWaypoints;

	//Attack or defend?
	[_group, _group, 50, 3, 0.25, 0.5] call CBA_fnc_taskDefend;

	private _threat = nil;
	waitUntil { 
		sleep 10;

		[_actionMeta, "COMPROMISE-ELAPSED", diag_tickTime - _startTimestamp] call CBA_fnc_hashSet;
		// Check targets, if none, all known threats have been dealt with -> continue
		_threat = [_group, 500, _actionMeta] call RAP_fnc_identifyThreatForMovement;
		!isNil "_threat";
	};

	[_group] call CBA_fnc_clearWaypoints;
};

RAP_fnc_moveController = {
	params ["_group", "_targetPos", "_actionMeta"];

	scriptName "RAP_fnc_moveController";
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

	[_actionMeta, "PHASE", "INIT"] call CBA_fnc_hashSet;
	// Start by clearing any waypoints
	[_group] call CBA_fnc_clearWaypoints;

	//Defend the current location while pre movement phase is being processed
	[_group, _group, 50, 3, 0.25] call CBA_fnc_taskDefend;

	[_group, _targetPos, _actionMeta] call RAP_fnc_preMove;

	// AFter pre-move, group should be inside a transportation if such was available
	[_group] call CBA_fnc_clearWaypoints;

	[_group, _targetPos, _actionMeta] call RAP_fnc_move;

	waitUntil {
		sleep 5;
		private _moveCompleted = [_actionMeta, "moveCompleted"] call CBA_fnc_hashGet;
		!isNil "_moveCompleted" && _moveCompleted;
	};

	[_actionMeta, "PHASE", "POST"] call CBA_fnc_hashSet;
	// TODO: Secure end point for a set amount of time
	[_actionMeta, "COMPLETE", true] call CBA_fnc_hashSet;
};

RAP_fnc_moveContingencyController = {
	params ["_group", "_targetPos", "_moveHandle", "_actionMeta"];
	scriptName "RAP_fnc_moveContingencyController";
	private _threat = nil;

	waitUntil {
		_threat = [_group, 400, _actionMeta] call RAP_fnc_identifyThreatForMovement;
		!isNil "_threat";
	};

	// A threat has been identified, deal with it
	[_actionMeta, "COMPROMISED", true] call CBA_fnc_hashSet;
	// Terminate move handle
	terminate _moveHandle;
	[_group, _threat, _actionMeta] call RAP_fnc_neutralizeMovementThreat;

	// Threats have been neutralized, should init move again
	[_actionMeta, "COMPROMISED"] call CBA_fnc_hashRem;
	[_actionMeta, "COMPROMISE-ELAPSED"] call CBA_fnc_hashRem;
	[_group, _targetPos, _actionMeta] call RAP_fnc_actionsMoveInit;
};

RAP_fnc_actionsMoveInit = {
	params ["_units", "_targetPos", "_actionMeta"];

	/**
		INITING MOVE ACTION

		(*) Check if all of the units are within certain distance from each other
			-> make groups accrodingly and init separate move actions for each
		(*) Start actual move
			- As a pre-move phase, check if groups are in contact (and do they need to disengage)
		(*) Start contingency controller
	*/

	[_actionMeta] call RAP_fnc_actionsResetHandles;
	private _group = [_units, nil, [_actionMeta, "SIDE"] call CBA_fnc_hashGet] call RAP_fnc_actionsCombineUnitsToGroup;
	private _moveHandle = [_group, _targetPos, _actionMeta] spawn RAP_fnc_moveController;
	[_actionMeta, "HANDLES", _moveHandle] call RAP_fnc_pushBackToHash;
	private _contingencyHandle = [_group, _moveHandle, _actionMeta] spawn RAP_fnc_moveContingencyController;
	[_actionMeta, "HANDLES", _contingencyHandle] call RAP_fnc_pushBackToHash;
};