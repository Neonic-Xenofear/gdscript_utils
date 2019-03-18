extends CStateImpl.CDefaultState
class_name CTEJumpState

var enemy : KinematicBody2D = null;

func _ready() -> void:
	pass;

func _onEnter() -> void:
	if ( enemy == null ):
		enemy = parent as KinematicBody2D;
	
	getMovementComponent().jump();

func _onTick( delta ) -> void:
	if ( getMovementComponent().velocity.y > 0 ):
		transition( "fall" );
	
	if ( getMovementComponent() != null && parent.target != null ):
		var dir : Vector2 = ( parent.position - parent.target.position ).normalized();
		if ( dir.x > 0 ):
			dir.x = -1;
		elif ( dir.x < 0 ):
			dir.x = 1;
		
		getMovementComponent().move( Vector2( dir.x, 0 ), delta );
	else:
		getMovementComponent().move( Vector2( 0, 0 ), delta );