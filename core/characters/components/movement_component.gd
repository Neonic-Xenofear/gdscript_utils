extends UComponent
class_name UMovement

var maxMoveSpeed : int = 300;
var minMoveSpeed : int = 150;

var direction : Vector2 = Vector2( 0, 0 );
var velocity : Vector2 = Vector2( 0, 0 );

func move( iDirection : Vector2, delta : float ) -> void:
	direction = iDirection;
	
	if ( direction.x == 0 ):
		velocity.x = 0;
	
	if ( direction.y == 0 ):
		velocity.y = 0;
	
	velocity = parent.move_and_slide( velocity, Vector2( 0, -1 ), 25 );
	
	var targetSpeed : Vector2 = direction;
	if ( targetSpeed.x != 0 ):
		targetSpeed.x *= maxMoveSpeed;
		velocity.x = lerp( velocity.x, targetSpeed.x, 0.1 );
	
	if ( targetSpeed.y != 0 ):
		targetSpeed.y *= maxMoveSpeed;
		velocity.y = lerp( velocity.y, targetSpeed.y, 0.1 );

func _className() -> String:
	return "UMovement";