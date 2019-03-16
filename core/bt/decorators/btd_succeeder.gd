extends CBTDecorator
class_name CBTSucceder

func _onTick( tick : float ) -> int:
	child._tick( tick );
	return BTS_SUCCESS;