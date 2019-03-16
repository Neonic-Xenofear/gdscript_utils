extends CBaseCharacter
class_name CPawn

func _ready() -> void:
	_addComponent( UPlatformerMovement.new() );
	_addComponent( UBehaviorTree.new() );

func _className() -> String:
	return "CPawn";