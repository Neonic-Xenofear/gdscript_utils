extends CCSNode
class_name CCSNWait

export( int ) var frames = 0;

func _onStart( _manager ) -> void:
	manager = _manager;

func _onEnd() -> void:
	manager.commandsNow.pop_front()
	manager.commands.pop_front()
	manager.work()

func _process( delta ):
	if ( frames <= 0 ):
		_onEnd();
	else:
		frames -= 1;