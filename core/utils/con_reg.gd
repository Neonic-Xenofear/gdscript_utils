extends Node

func _init():
	Console.Log.setLogLevel();
	
	Console.register('reloadScene', {
		'description': 'Reload currentScene.',
		'target': self
	});
	
	Console.register('changeScene', {
		'description': 'Change scene to new.',
		'args': [ TYPE_STRING ],
		'target': self
	});

func reloadScene() -> void:
	get_tree().reload_current_scene();
	Console.Log.info( "Current scene reloaded" );

func changeScene( name ) -> void:
	globals.levels.changeScene( name );