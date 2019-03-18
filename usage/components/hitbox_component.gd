extends UComponent
class_name UHitboxComponent

signal onHit( from );

func _init():
	pass

func attack( from ) -> void:
	emit_signal( "onHit", from );

func _className() -> String:
	return "UHitboxComponent";