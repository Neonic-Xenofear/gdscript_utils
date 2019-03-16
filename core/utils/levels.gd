extends Node
class_name CLevelsManager

var scenes = {
	"TEST" : "res://maps/test/test.tscn",
}

func changeScene( newSceneName : String ) -> void:
	if ( newSceneName in scenes ):
		Console.Log.info( "Scene change to: " + scenes[newSceneName] );
		get_tree().change_scene( scenes[newSceneName] );
	else:
		Console.Log.error( "Invalid scene name to change: " + newSceneName );