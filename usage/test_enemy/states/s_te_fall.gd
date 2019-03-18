extends CStateImpl.CDefaultState
class_name CTEFallState

var enemy : KinematicBody2D = null;

func _ready() -> void:
	pass;

func _onEnter() -> void:
	if ( enemy == null ):
		enemy = parent as KinematicBody2D;

func _onTick( delta ) -> void:
	if ( enemy.is_on_floor() ):
		if ( abs( getMovementComponent().velocity.x ) < getMovementComponent().minMoveSpeed ):
			transition( "stand" );
		else:
			transition( "baseRun" );
		return;
	
	if ( getMovementComponent() != null && parent.target != null ):
		var dir : Vector2 = ( enemy.position - parent.target.position ).normalized();
		if ( dir.x > 0 ):
			dir.x = -1;
		elif ( dir.x < 0 ):
			dir.x = 1;
		
		getMovementComponent().move( Vector2( dir.x, 0 ), delta );
	else:
		getMovementComponent().move( Vector2( 0, 0 ), delta );