RAP_fnc_debugLog = {
	params ["_message"];
	private _formattedMsg = ["DEBUG", format _message] joinString " --- ";

	if (isMultiplayer) then {
		_formattedMsg remoteExec ["systemChat", 0, true];
	} else {
		systemChat _formattedMsg;
	}
};