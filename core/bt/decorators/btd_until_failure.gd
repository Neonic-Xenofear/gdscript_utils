extends CBTDecorator
class_name CBTUntilFailure

func _onTick( tick : float ):
	while ( true ):
		var stat : int = child._tick( tick );
		
		if ( stat == BTS_FAILURE ):
			return BTS_FAILURE;