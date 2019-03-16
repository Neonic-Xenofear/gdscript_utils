extends CBTDecorator
class_name CBTInverter

func _onTick( tick : float ) -> int:
	var stat : int = child._tick( tick );
	if ( stat == BTS_SUCCESS ):
		return BTS_FAILURE;
	elif ( stat == BTS_FAILURE ):
		return BTS_SUCCESS;
	
	return stat;