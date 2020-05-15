RAP_fnc_initializePatrolMarkers = {
	params ["_position", "_type", ["_radius", 500]];

	private _objAreaMarker = "rap_patrol_area";
	deleteMarker _objAreaMarker;
	private _marker = createMarker [_objAreaMarker, _position];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerAlpha 0.5;
	_marker setMarkerColor "ColorBlack";
	_marker setMarkerSize [_radius, _radius];

	private _objPositionMarker = "rap_patrol_obj";
	deleteMarker _objPositionMarker;
	_marker = createMarker [_objPositionMarker, _position];
	_marker setMarkerShape "hd_objective";
};