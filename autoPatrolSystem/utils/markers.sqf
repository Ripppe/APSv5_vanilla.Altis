RAP_fnc_initializePatrolMarker = {
	params ["_position", ["_radius", 500]];

	private _objMarker = "rap_patrol_marker";
	deleteMarker _objMarker;
	private _marker = createMarker [_objMarker, _position];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerAlpha 0.5;
	_marker setMarkerColor "ColorBlack";
	_marker setMarkerSize [_radius, _radius];

};