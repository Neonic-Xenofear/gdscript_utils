extends Node
class_name CCSNode

var manager = null;

func _onStart( _manager ) -> void:
	pass

func _onEnd() -> void:
	pass

func _skip() -> void:
	_onEnd();

func shoudWaitEnd() -> bool:
	return false;