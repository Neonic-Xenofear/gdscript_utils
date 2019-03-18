extends CStateImpl.CDefaultState
class_name CTEHittedState

var enemy : KinematicBody2D = null;

var newMoveSpeed : float = 80;
var basicMoveSpeed : float = 0;

var endTime : Timer = Timer.new();
var hitTime : float = 1;

func _ready() -> void:
	pass;

func _onEnter() -> void:
	if ( enemy == null ):
		enemy = parent as KinematicBody2D;
		
		endTime.connect( "timeout", self, "t_timerEnd" );
		endTime.wait_time = hitTime;
		.add_child( endTime );
	
	enemy.getComponent( "UHealth" ).minHP( 1 );
	
	basicMoveSpeed = getMovementComponent().maxMoveSpeed;
	getMovementComponent().maxMoveSpeed = newMoveSpeed;
	
	getMovementComponent().jump( 0.5 );
	
	endTime.start();
	
	enemy.get_node( "Sprite" ).self_modulate = Color( 0.0, 1.0, 0.0, 1.0 );

func _onLeave() -> void:
	endTime.stop();
	
	getMovementComponent().maxMoveSpeed = basicMoveSpeed;
	enemy.get_node( "Sprite" ).self_modulate = Color( 1.0, 1.0, 1.0, 1.0 );

func _onTick( delta ) -> void:
	if ( enemy.getComponent( "UHealth" ).currHealth == 0 ):
		transition( "dead" );
		return;
	
	if ( getMovementComponent() != null ):
		getMovementComponent().move( Vector2( -enemy.direction.x, 0 ), delta );

func t_timerEnd() -> void:
	transition( "fall" );

