RAP_fnc_actions_move = {
	params ["_controlTrigger", "_targetPos"];

	private _enroute = _controlTrigger getVariable "moveOrderIssued";

	if (not _enroute) then {
		{
			_x params ["_group"];

			private _destination = [_targetPos, 10, 50] call BIS_fnc_findSafePos;

			private _wp = [_group, _destination, 10, "MOVE", "AWARE", "WHITE", "STAG COLUMN"] call CBA_fnc_addWaypoint;
			_wp setWaypointCompletionRadius 5;
		} forEach RAP_PATROL_GROUPS;

		_controlTrigger setVariable ["moveOrderIssued", true];
	};
};