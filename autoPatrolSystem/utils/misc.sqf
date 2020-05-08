RAP_fnc_debugLog = {
	params ["_message", ["_arguments", []]];
	if (RAP_DEBUG_ON) then {
		private _formattedMsg = if ([_arguments] call RAP_fnc_isEmptyArray) then {
		_message;
	} else {
		format ([_message] append _arguments);
	};
	_formattedMsg = ["DEBUG",  _formattedMsg] joinString " --- ";

		if (isMultiplayer) then {
		_formattedMsg remoteExec ["systemChat", 0, true];
		} else {
			systemChat _formattedMsg;
		};
	};
};
};