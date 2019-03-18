extends CStateImpl.CDefaultState
class_name CTEStandState

var enemy : KinematicBody2D = null;

func _onEnter() -> void:
	if ( enemy == null ):
		enemy = parent as KinematicBody2D;
	
	enemy.connect( "onHit", self, "_onHit" );

func _onLeave() -> void:
	enemy.disconnect( "onHit", self, "_onHit" );

func _onTick( delta ) -> void:
	if( parent.target != null ):
		transition( "baseRun" );
		return;
	
	if ( !parent.is_on_floor() ):
		transition( "fall" );
		return;

func _onHit( from ) -> void:
	transition( "hitted" );