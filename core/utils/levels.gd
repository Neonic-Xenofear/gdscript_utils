extends Node
class_name CLevelsManager

var scenes = {
	"TEST" : "res://maps/test/test.tscn",
}

func changeScene( newSceneName : String ) -> void:
	if ( newSceneName in scenes ):
		get_tree().change_scene( scenes[newSceneName] );
