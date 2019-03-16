extends CBaseObject
class_name CStateImpl

class CState extends CBaseObject:
	const enterName = "_onEnter";
	const leaveName = "_onLeave";
	
#warning-ignore:unused_class_variable
	var id;
	var parent;
	var machine = null;
	
	func _onEnter() -> void: pass
	func _onLeave() -> void: pass
	
	func transition( nTransition : String ) -> void:
		machine.transition( nTransition );
	
	func autoUpdateDirection() -> void:
		var currDir : Vector2 = getInputDirection();
		
		if ( currDir.x != 0 ):
			parent.direction.x = currDir.x;
		
		parent.direction.y = currDir.y;
	
	func getInputDirection() -> Vector2:
		var targetDir : Vector2 = Vector2( 0, 0 );
		
		if ( Input.is_action_pressed( "a_moveRight" ) ):
			targetDir.x = 1;
		
		if ( Input.is_action_pressed( "a_moveLeft" ) ):
			targetDir.x = -1;
		
		if ( Input.is_action_pressed( "a_lookDown" ) ):
			targetDir.y = 1;
		
		if ( Input.is_action_pressed( "a_lookUp" ) ):
			targetDir.y = -1;
		
		return targetDir;
	
	func getMovementComponent() -> UPlatformerMovement:
		return parent.getComponent( "UPlatformerMovement" );

class CDefaultState extends CState:
#warning-ignore:unused_argument
	func _process( delta ): pass
	
#warning-ignore:unused_argument
	func _physics_process( delta ): pass
	
	#func _tick( delta ) -> void: pass
	
#warning-ignore:unused_argument
	func _input( event ) -> void: pass