extends UComponent
class_name UPlatformerMovement

var bApplyGravity : bool = true;
var gravity : Vector2 = Vector2( 0, 10800 );
var maxMoveSpeed : int = 1300;
var maxJumpMoveSpeed : int = maxMoveSpeed / 3;
var minMoveSpeed : int = 450;               #Minival value for movement x to set 0
var walkWeightFallof : float = 0.09;
var maxFallSpeed : int = 2500;

var enableMove : Vector2 = Vector2( 1, 1 );

var jumpMaxForce : int = 2800;
var jumpMoveFallof : float = 2;
var fallSpeedFallof : float = 1.5;          #Используется для уменьшения скоростей при определённых действиях

var bLongJumpEnable : bool = true;
var jumpLastPressedMax : int = 40;
var jumpFallofTimes : int = 20;

var direction : Vector2 = Vector2( 0, 0 );
var velocity : Vector2 = Vector2( 0, 0 );
var jumpLastPressed : int = 0;

func _onTick( delta ) -> void:
	if ( bLongJumpEnable && bApplyGravity ):
		if ( Input.is_action_pressed( "a_jump" ) ):
			if ( velocity.y >= -jumpMaxForce && velocity.y <= 0 && jumpLastPressed < jumpLastPressedMax ):
				velocity.y = clamp( velocity.y, velocity.y, velocity.y + velocity.y / jumpLastPressedMax );
				jumpLastPressed += 1;
		elif ( jumpLastPressed < jumpFallofTimes && velocity.y <= 0 && parent.get_floor_velocity() == Vector2( 0, 0 ) ):
			velocity.y = velocity.y / fallSpeedFallof;
	

func move( iDirection : Vector2, delta : float ) -> void:
	direction = iDirection;
	if ( velocity.y > 0 || parent.is_on_floor() ):
		jumpLastPressed = 0;
	
	if ( parent.get_floor_velocity() == Vector2( 0, 0 ) ):
		#abs( velocity.x ) <= minMoveSpeed / 100 &&
		if ( velocity.x != 0 ):
			var linearVelNegative : bool = CMath.normAbs( velocity.x ) != direction.x;
			var noNullTargetSpeed : bool = direction.x != 0;
			var minSpeedCheck : bool     = abs( velocity.x ) < minMoveSpeed;
			
			var resVal = ( linearVelNegative && noNullTargetSpeed ) || ( minSpeedCheck && !noNullTargetSpeed );
			
			if ( resVal ):
				velocity.x = 0;
				return;
	elif ( velocity.x == 0 ):
		velocity += parent.get_floor_velocity() / 2;
	
	if ( bApplyGravity ):
		velocity += gravity * delta;
		
		if ( velocity.y > maxFallSpeed ):
			velocity.y = maxFallSpeed;
	
	if ( velocity.x > maxMoveSpeed ):
		velocity.x = maxMoveSpeed / 2;
	
	velocity *= enableMove;
	velocity = parent.move_and_slide( velocity, Vector2( 0, -1 ), 25 );
	
	var targetSpeed : float = direction.x;
	if ( targetSpeed != 0 ):
		targetSpeed *= maxMoveSpeed;
		if ( parent.get_floor_velocity() != Vector2( 0, 0 ) ):
			targetSpeed /= 2;
		
		velocity.x = lerp( velocity.x, targetSpeed, 0.1 );
	else:
		var resWeightFallof : float = walkWeightFallof;
		if ( velocity.y != 0 ):
			resWeightFallof *= jumpMoveFallof;
		
		velocity.x = lerp( velocity.x, 0, resWeightFallof );

func jump( xStr : float = 1.0 ) -> void:
	velocity.y = -jumpMaxForce * xStr;

func _className() -> String:
	return "UPlatformerMovement";

