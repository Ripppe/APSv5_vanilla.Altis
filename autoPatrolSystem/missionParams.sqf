// "ammo1" is a fixed 'named asset' in the mission itself - it is both the VA arsenal and also acts as a anchor point for the main Blufor base.
RAP_BASE_CENTER_LOCATION = getPos ammo1;

RAP_PATROL_INITIALIZED = false;
RAP_DEBUG_ON = true;

// Triggers
RAP_G_TRIGGERS_BASE = nil;
RAP_G_TRIGGERS_PATROL_MONITOR = nil;

//Available patrol types
RAP_G_PATROL_TYPE_ATTACK = ["ATTACK", [["Name", "Hill", "NameVillage"], [1000, 5000]]];
RAP_G_PATROL_TYPE_DATA = [[RAP_G_PATROL_TYPE_ATTACK]] call CBA_fnc_hashCreate;
RAP_G_PATROL_TYPES = [RAP_G_PATROL_TYPE_DATA] call CBA_fnc_hashKeys;
RAP_G_PATROL_ZONE_DISTANCE = [1000, 5000];