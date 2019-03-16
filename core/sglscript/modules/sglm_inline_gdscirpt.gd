extends CSGLModule
class_name CSGLMInlineGDScript

#Please change with care!
const SCRIPT_BASE = \
"""
var script;
var interpreter;
""";

func dc_inline_gdscript( args : Dictionary, callInterpreter = null ) -> void:
	if ( args.has( "code" ) ):
		var script = CInlineGDScript.getScriptByString( SCRIPT_BASE + "\n" + args["code"] );
		
		script.script = callInterpreter.script;
		script.interpreter = callInterpreter;
		
		script.main();
		
	elif ( args.has( "path" ) ):
		var script = CInlineGDScript.getScriptByString( SCRIPT_BASE + "\n" + CFileUtil.getFileDataAsText( args["path"] ) );
		
		script.script = callInterpreter.script;
		script.interpreter = callInterpreter;
		
		script.main();
		
	else:
		print( _className() + ": Unsupported loading type!" );

func _className() -> String:
	return "CSGLMInlineGDScript";
