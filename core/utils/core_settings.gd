extends Node
class_name CCoreSettings

var variables : Dictionary = {};

func _init():
	var interpreter = CSGLScriptInterpreterImpl.CSGLScriptInterpreter.new();
	interpreter.bAutoStart = true;
	interpreter.parent = self;
	interpreter.loadFile( "res://code/core/cfg.sgl" );
	
	variables = interpreter.script.variables;

func getVar( name : String ):
	if ( variables.has( name ) ):
		return variables[name];
	
	return null;

func setVar( name : String, val ) -> void:
	variables[name] = val;