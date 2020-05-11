RAP_fnc_actions_move = {
	params ["_controlObject", "_groups", "_targetPos"];
	/**
		The flow of move:

		1) Does group contain organic transportation?
		2) If does, move to troops to transport vehicles
		3) If not AND distance is >500 m, require transport
			- Wait for the results of request
			- If yes, wait for randevouz point
			- When randevouz point is received, link groups with transport vehicles
		4) When troops have embarked OR transpot has been denied OR distance is <500
		order move WP to destination
		5) When first group reaches destination order it to defend the area
		6) When all groups have reached the destination, actiion is completed
	 */

	_controlObject setVariable ["orderGroups", _groups];

	private _hasTranportCapability = _groups call RAP_fnc_hasTransportCapability;

	if (_hasTranportCapability) then {

	} else {
		_controlObject setVariable ["moveOrderIssued", true];
	};

	private _enroute = _controlObject getVariable "moveOrderIssued";

	if (not _enroute) then {

		_controlObject setVariable ["moveOrderIssued", true];
	};
};

RAP_fnc_hasTransportCapability = {
	false;
};

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
	params ["_force", "_targetLocation"];

	_force params ["_groups", "_attachedAssets"];

	// Measure each group's dist to target, sort them in descending order and take first
	private _farthestAway = ((_groups apply {[_x, _targetLocation] call CBA_fnc_getDistance}) sort false) select 0;

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
	params ["_forceIdentifier", "_targetLocation"];

	private _force = _forceIdentifier call RAP_fnc_getForce;
	_force params ["_groups"];
	private _preMoveHandle = [_force, _targetLocation] spawn RAP_fnc_preMove;

	waitUntil { scriptDone _preMoveHandle };

	private _groupsToMove = [_forceIdentifier, RAP_PATROL_ACTION_MOVE, "groupsToMove"];
	private _movementHandle = [_groupsToMove, _targetLocation] spawn RAP_fnc_move;
	private _movementMonitor = [_groups] spawn RAP_fnc_movementMonitor;
};

RAP_fnc_getForce = {
	params ["_forceIdentifier"];

	[RAP_PATROL_FORCES, _forceIdentifier] call CBA_fnc_hashGet;
};

RAP_fnc_createNewForce = {
	params ["_forceIdentifier", "_groups", "_attachedAssets"];

	[RAP_PATROL_FORCES, _forceIdentifier, [_groups, _attachedAssets]] call CBA_fnc_hashSet;
};

RAP_fnc_getActionParam = {
	params ["_forceIdentifier", "_task", "_param"];

	RAP_PATROL_ACTION_PARAMS;
};