class_name CBTNode

const BTS_FAILURE = -1;
const BTS_INVALID = 0;
const BTS_SUCCESS = 1;
const BTS_RUNNING = 2;

var status : int = BTS_INVALID;

func _initialize( args : Dictionary ) -> void:
	pass

func _tick( tick : float ) -> int:
	if ( status != BTS_RUNNING ):
		_onInit();
	
	status = _onTick( tick );
	
	if ( status != BTS_RUNNING ):
		_onTerminate( status );
	
	return status;

#virtual funcs
func _onInit() -> void:
	pass

func _onTerminate( stat : int ) -> void:
	pass

func _onTick( tick : float ) -> int:
	return BTS_SUCCESS;