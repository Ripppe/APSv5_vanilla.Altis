

sleep 10;

// Load functions
execVM "autoPatrolSystem\utils\misc.sqf";
execVM "autoPatrolSystem\utils\triggers.sqf";
execVM "autoPatrolSystem\patrolParams.sqf";
execVM "autoPatrolSystem\utils\missionFlow.sqf";

// initialise APS
execVM "autoPatrolSystem\missionControl.sqf";
// systemchat "debug --- APS ACTIVATED";
sleep 0.5;

// initialise Heli Systems
// execVM "autoPatrolSystem\heliSystems\heliSystemsInit.sqf";
// // systemchat "debug --- Heli Systems ACTIVATED";
// sleep 0.5;

// initialise debug UAV
// execVM "autoPatrolSystem\UAV\uav.sqf";
// systemchat "debug --- UAV Systems ACTIVATED";
// sleep 0.5;

// initialise debug counter system - comment this out to turn off 
// execVM "autoPatrolSystem\debuggingSystems\debugCounter.sqf";


// initialise flybys - add bombs later 
// execVM "autoPatrolSystem\ambientSystems\randomFlybys.sqf";