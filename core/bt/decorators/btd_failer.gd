extends CBTDecorator
class_name CBTFailer

func _onTick( tick : float ) -> int:
	child._tick( tick );
	return BTS_FAILURE;