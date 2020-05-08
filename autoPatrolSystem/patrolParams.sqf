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

RAP_PATROL_TASK_MOVE_TO_FUP = "MOVE-TO-FUP";
RAP_PATROL_TASK_ATTACK = "ATTACK";
RAP_PATROL_TASK_SECURE = "SECURE";
RAP_PATROL_TASK_RTB = "RETURN-TO-BASE";

RAP_PATROL_ATTACK_PHASING = [RAP_PATROL_TASK_MOVE_TO_FUP, RAP_PATROL_TASK_ATTACK, RAP_PATROL_TASK_SECURE, RAP_PATROL_TASK_MOVE_TO_FUP];
RAP_PATROL_PHASING = [[RAP_G_PATROL_TYPE_ATTACK, [RAP_PATROL_ATTACK_PHASING]]] call CBA_fnc_hashCreate;