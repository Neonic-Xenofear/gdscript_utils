extends Node
class_name CCutsceneManager

var commands : Array = [];
var commandsNow : Array = [];

func _ready():
	for command in get_children():
		commands.append( command );
	
	for command in get_children():
		commandsNow.append( command );
		
		if ( command.shoudWaitEnd ):
			break;
	
	
	work();

func work() -> void:
	if ( commands.size() > 0 ):
		commands.front()._onStart( self );