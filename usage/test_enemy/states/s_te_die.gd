extends CStateImpl.CDefaultState
class_name CTEDeadState

var player : KinematicBody2D = null;

func _ready() -> void:
	pass;

func _onEnter() -> void:
	if ( player == null ):
		player = parent as KinematicBody2D;
		player.get_node( "Sprite" ).self_modulate = Color( 1.0, 0.0, 0.0, 1.0 );

func _onLeave() -> void:
	pass

func _onTick( delta ) -> void:
	pass

func _onInput( event ) -> void:
	player.get_node( "Sprite" ).self_modulate = Color( 1.0, 0.0, 0.0, 1.0 );
	