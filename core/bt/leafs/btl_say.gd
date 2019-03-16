extends CBTLeaf
class_name CBTSay

var printMessage : String = "";

func _initialize( args : Dictionary ) -> void:
	printMessage = args["args"];

func _onTick( tick : float ) -> int:
	print( printMessage );
	return BTS_SUCCESS;
