extends CGameBasePawn
class_name CTestEnemy

var target : Node2D = null;

func _ready():
	_addComponent( UFSM.new() );
	getComponent( "UPlatformerMovement" ).bLongJumpEnable = false;
	
	getComponent( "UBehaviorTree" ).loadBTFile( "res://ext_files/ai/test.sgl" );
	getComponent( "UBehaviorTree" ).behaviorTree.blackboard.setVar( "parent", self );
	getComponent( "UBehaviorTree" ).behaviorTree.blackboard.setVar( "target", globals.player );

func _onTick( delta ) -> void:
	direction.x = getComponent( "UPlatformerMovement" ).direction.x;
	$WallCheck.cast_to.x = 20 * direction.x;

func _onHit( from ) -> void:
	getComponent( "UHealth" ).minHP( 50 );

func _onDie() -> void:
	queue_free();

#Настраивает FSM, вызывается автоматически
func configFSMComponent() -> Dictionary:
	return {
		"states": [
			{ "id": "stand", "state": CTEStandState },
			{ "id": "baseRun", "state": CTEBaseRunState },
			{ "id": "fall", "state": CTEFallState },
			{ "id": "jump", "state": CTEJumpState },
		],
		"transitions": [
			{ "id": "stand", "toStates": ["baseRun", "fall", "jump"] },
			{ "id": "baseRun", "toStates": ["stand", "fall", "jump"] },
			{ "id": "fall", "toStates": ["stand", "baseRun"] },
			{ "id": "jump", "toStates": ["fall"] },
		],
		"currentState": "fall"
	};

func _className():
	return "CTestEnemy";