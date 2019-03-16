extends CBTDecorator
class_name CBTUntilSuccess

func _onTick( tick : float ):
	while ( true ):
		var stat : int = child._tick( tick );
		
		if ( stat == BTS_SUCCESS ):
			return BTS_SUCCESS;