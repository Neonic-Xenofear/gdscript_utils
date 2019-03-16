class_name CBTBehaviorTree

var root = null;
var blackboard = CBTBlackboard.new();

func _tick( tick : float ) -> int:
	return root._tick( tick );