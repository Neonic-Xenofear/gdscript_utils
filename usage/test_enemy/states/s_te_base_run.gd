extends CStateImpl.CDefaultState
class_name CTEBaseRunState

var enemy : KinematicBody2D = null;

func _ready() -> void:
	pass;

func _onEnter() -> void:
	if ( enemy == null ):
		enemy = parent as KinematicBody2D;

func _onTick( delta ) -> void:
	if ( !enemy.is_on_floor() ):
		transition( "fall" );
		return;
	
	if ( getMovementComponent() != null && parent.target != null ):
		if ( enemy.get_node( "WallCheck" ).is_colliding() ):
			transition( "jump" );
		
		var dir : Vector2 = ( enemy.position - parent.target.position ).normalized();
		if ( dir.x > 0 ):
			dir.x = -1;
		elif ( dir.x < 0 ):
			dir.x = 1;
		
		getMovementComponent().move( Vector2( dir.x, 0 ), delta );