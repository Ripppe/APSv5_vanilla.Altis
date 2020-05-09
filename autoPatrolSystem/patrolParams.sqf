/**
	Each item represents one group attached to the current patrolPointsTaken

	Format will be:

	[<group>, [<group initial size>, <group last location>]]
 */
RAP_PATROL_GROUPS = [];
RAP_PATROL_LOCATION = nil;
RAP_PATROL_TYPE = nil;
RAP_PATROL_CURRENT_TASK = nil;
RAP_PATROL_TASKS = [];

// Format [<control trigger>, <phase termination trigger>]
RAP_PATROL_TASK_TRIGGERS = [];

RAP_fnc_resetPatrolParams = {
	RAP_PATROL_GROUPS = [];
	RAP_PATROL_LOCATION = nil;
	RAP_PATROL_TYPE = nil;
	RAP_PATROL_CURRENT_TASK = nil;
	RAP_PATROL_TASKS = [];
	RAP_PATROL_TASK_TRIGGERS = [];

	// Reset patrol triggers
	{
		
	} forEach (allMissionObjects "EmptyDetector");
};

RAP_PATROL_TASK_ATTACK = "TASK-ATTACK";

RAP_PATROL_TASK_PHASE_MOVE_TO_FUP = "PHASE-MOVE-TO-FUP";
RAP_PATROL_TASK_PHASE_ATTACK = "PHASE-ATTACK";
RAP_PATROL_TASK_PHASE_SECURE = "PHASE-SECURE";
RAP_PATROL_TASK_PHASE_RTB = "PHASE-RETURN-TO-BASE";

RAP_PATROL_ATTACK_PHASES = [RAP_PATROL_TASK_PHASE_MOVE_TO_FUP, RAP_PATROL_TASK_PHASE_ATTACK, RAP_PATROL_TASK_PHASE_SECURE];
RAP_PATROL_PHASES = [[RAP_G_PATROL_TYPE_ATTACK, [RAP_PATROL_ATTACK_PHASES]]] call CBA_fnc_hashCreate;