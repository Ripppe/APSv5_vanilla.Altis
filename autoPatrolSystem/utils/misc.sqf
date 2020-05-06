RAP_fnc_debugLog = {
	params ["_message"];
	private _formattedMsg = ["DEBUG", format _message] joinString " --- ";

	systemChat _formattedMsg;
};