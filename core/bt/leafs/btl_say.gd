extends CBTLeaf
class_name CBTSay

var printMessage : String = "";

func _initialize( args : Dictionary ) -> void:
	printMessage = args["args"];

func _onTick( tick : float ) -> int:
	Console.Log.info( printMessage );
	return BTS_SUCCESS;