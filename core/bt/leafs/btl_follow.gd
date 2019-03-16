extends CBTLeaf
class_name CBTFollow

var parentObj : CBaseCharacter = null;
var parent : Node2D = null;
var target : Node2D = null;
var acceptRadius : float = 100;

func _initialize( args : Dictionary ) -> void:
	#target = args["args"];
	pass

func _onTick( tick : float ) -> int:
	var nPar = blackboard.getVar( "parent" );
	if ( parent != nPar ):
		parent = nPar;
	
	var nTarget = blackboard.getVar( "target" );
	if ( target != nTarget ):
		target = nTarget;
	
	if ( parent != null && target != null ):
		if ( ( parent.position - target.position ).length() <= acceptRadius ):
			parent.target = null;
		else:
			parent.target = target;
	
	return BTS_RUNNING;