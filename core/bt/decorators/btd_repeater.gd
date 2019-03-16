extends CBTDecorator
class_name CBTRepeater

var limit : int = 0;
var counter : int = 0;

func _onInit() -> void:
	counter = 0;

func _onTick( tick : float ) -> int:
	child._tick( tick );
	if ( limit > 0 && ++counter == limit ):
		return BTS_SUCCESS
	
	return BTS_RUNNING;