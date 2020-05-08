/**
	Each item represents one group attached to the current patrolPointsTaken

	Format will be:

	[<group>, [<group initial size>, <group last location>]]
 */
RAP_PATROL_GROUPS = [];
RAP_PATROL_LOCATION = nil;
RAP_PATROL_TYPE = nil;

RAP_fnc_resetPatrolParams = {
	RAP_PATROL_GROUPS = [];
	RAP_PATROL_LOCATION = nil;
	RAP_PATROL_TYPE = nil;
};

RAP_PATROL_TASKS = ["MOVE-SECURE", "ATTACK", "SECURE", "MOVE"];