extends UComponent
class_name UBehaviorTree

var behaviorTree : CBTBehaviorTree = null;

func _onBegin() -> void:
	pass

func loadBTFile( path : String ) -> void:
	var builder : CBTBuilder = CBTBuilder.new();
	builder.loadConfigFile( path );
	behaviorTree = builder.behaviorTree;

func _onShutdown() -> void:
	behaviorTree = null;

func _onTick( delta ) -> void:
	if ( behaviorTree != null ):
		behaviorTree._tick( delta );

func _className() -> String:
	return "UBehaviorTree";