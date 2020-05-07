RAP_fnc_debugLog = {
	params ["_message", ["_arguments", []]];
	private _formattedMsg = if (count _arguments == 0) then {
		_message;
	} else {
		format ([_message] append _arguments);
	};
	_formattedMsg = ["DEBUG",  _formattedMsg] joinString " --- ";

	if (RAP_DEBUG_ON) then {
		if (isMultiplayer) then {
		_formattedMsg remoteExec ["systemChat", 0, true];
		} else {
			systemChat _formattedMsg;
		}
	}
};