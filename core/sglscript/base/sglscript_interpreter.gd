extends CBaseObject
class_name CSGLScriptInterpreterImpl

class CSGLScriptInterpreter extends CBaseObject:
	var parser = CSGLScriptParserImpl.CSGLScriptParser.new();
	var bAutoStart : bool = false;
	var parent : Object = null;
	
	var filepath : String = "";
	var scriptText : String = "";
	var script = CSGLScriptParserImpl.CSGLScript.new()
	
	#Functions process
	var funcCommands : Array = [];
	
	var bPause : bool = true;
	var pauseCode : int = -1;
	var bInCommandLoop : bool = false;
	var labelCommand : Object = null;
	var labelIndex : int = 0;
	var bEnableModules : bool = true;
	
	var configFilepath : String = "";
	var scripts : Dictionary = {};
	
	func _reset() -> void:
		script = CSGLScriptParserImpl.CSGLScript.new();
		
		bPause = true;
		pauseCode = -1;
		bInCommandLoop = false;
		labelCommand = null;
		labelIndex = 0;
	
	func loadConfig( fp : String ) -> void:
		configFilepath = fp;
		var file : File = File.new();
		file.open( configFilepath, file.READ );
		if ( file == null ):
			return;
		
		var src : String = file.get_as_text();
		file.close();
		
		var dict : Dictionary = parse_json( src );
		for item in dict:
			scripts[item] = [dict[item].type, dict[item].src];
		
		print( "Dialog: Loaded config file" );
	
	func loadScript( name : String ) -> bool:
		if ( scripts.has( name ) ):
			if ( scripts[name][0] == "path" ):
				loadFile( scripts[name][1] );
			else:
				loadText( scripts[name][1] );
			return true;
		else:
			print( "Dialog Warning: Invalid script name for loading!" );
			return false;
	
	func loadFile( fp : String ) -> void:
		filepath = fp;
		
		var file : File = File.new();
		file.open( filepath, file.READ );
		scriptText = file.get_as_text();
		file.close();
		
		prepareScript();
	
	func loadText( text : String ) -> void:
		filepath = "";
		scriptText = text;
		
		prepareScript();
	
	func prepareScript() -> void:
		script = parser.parse( scriptText );
		
		if ( bAutoStart ):
			script.index = 0;
			advance();
		else:
			script.index = -1;
	
	func inBounds() -> bool:
		return script.index < script.code.size();
	
	func getCurrent():
		return script.code[script.index];
	
	func isCurrentCommand() -> bool:
		return script.code[script.index] is CSGLScriptParserImpl.CSGLScriptCommand;
	
	func isCurrentText() -> bool:
		return typeof( script.code[script.index] ) == TYPE_STRING;
	
	func next() -> void:
		script.index += 1;
	
	func prev() -> void:
		if ( script.index - 1 > 0 ):
			script.index -= 1;
	
	func pause( val ) -> void:
		bPause = true;
		pauseCode = val;
	
	func advance() -> void:
		var current;
		
		bPause = false;
		pauseCode = 0;
		
		bInCommandLoop = true;
		
		while ( inBounds() ):
			current = getCurrent();
			
			if ( isCurrentText() ):
				handleText( current );
			elif ( isCurrentCommand() ):
				if ( current.name == "label" ):
					labelCommand = current;
					labelIndex = script.index;
				else:
					handleCommand( current );
			else:
				pass
			
			next();
			
			if ( bPause ):
				break;
		
		bInCommandLoop = false;
	
	func processFunction() -> void:
		while ( funcCommands.size() != 0 ):
			var current = funcCommands[0];
			
			if ( typeof( current ) == TYPE_STRING ):
				handleText( current );
			else:
				handleCommand( current );
			
			funcCommands.remove( 0 );
	
	func handleText( text ) -> bool:
		if ( parent.has_method( "handleText" ) ):
			parent.call( "handleText", text );
			return true;
		
		printerr( "Dialog Warning: No 'handle_text' method available. All text is being ignored" );
		return false;
	
	func handleCommand( command ) -> bool:
#		if ( globals ):
#			if ( globals.settings.getVar( "sglscript_ignore_commands" ).has( command.name ) ):
#				return false;
		
		var commandName : String = str("dc_", command.name.replace( " ", "_" ) );
		
		if ( parent != null ):
			if ( parent.has_method( commandName ) ):
				parent.call( commandName, command.args );
				return true;
		
		if ( globals && bEnableModules ):
			for mod in globals.sglModules.modules:
				if ( mod.has_method( commandName ) ):
					mod.call( commandName, command.args, self );
					return true;
		
		if ( script.has_method( commandName ) ):
			script.call( commandName, command.args );
			return true;
		
		#Process user defined functions
		if ( script.funcs.has( command.name ) ):
			funcCommands = script.funcs[command.name].code;
			processFunction();
			return true;
		
		printerr( "Dilaog Warning: No such command '", command.name, "'. Ignoring it" );
		return false;

