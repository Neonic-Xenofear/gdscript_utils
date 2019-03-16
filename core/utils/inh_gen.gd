tool
extends EditorScript

const configPath = "res://code/core/cfg.sgl";

var interpreter : CSGLScriptInterpreterImpl.CSGLScriptInterpreter = CSGLScriptInterpreterImpl.CSGLScriptInterpreter.new();
var inheritance : Dictionary = {};

func _run():
	interpreter.bEnableModules = false;
	interpreter.bAutoStart = true;
	interpreter.loadFile( configPath );
	
	var files : Array = [];
	for dir in interpreter.script.variables["inheritance_folders"]:
		for file in CFileUtil.listFilesInDir( dir, true, true, true ):
			if ( file.get_extension() == "gd" ):
				files.append( file );
	
	for file in files:
		_processSingleFile( file );
	
	for objClass in inheritance:
		for singleInh in inheritance[objClass]:
			if ( inheritance.has( singleInh ) ):
				for item in inheritance[singleInh]:
					if ( !inheritance[objClass].has( item ) ):
						inheritance[objClass].append( item );
	
	var confFile : File = File.new();
	confFile.open( interpreter.script.variables["inheritance_file"], confFile.WRITE );
	confFile.store_line( to_json( inheritance ) );
	confFile.close();

func _genDir() -> void:
	var dir = Directory.new();
	dir.open( "res://" );
	dir.make_dir( "core.config" );

func _processSingleFile( path : String ) -> void:
	var baseClass : String = "";
	var className : String = "";
	var src : String = "";
	
	var file : File = File.new();
	file.open( path, file.READ );
	src = file.get_as_text();
	file.close();
	
	var arraySrc = src.split( "\n" );
	
	for item in arraySrc:
		if ( item.begins_with( "extends" ) ):
			baseClass = item.split( " " )[1];
		elif ( item.begins_with( "class_name" ) ):
			className = item.split( " " )[1];
		elif ( baseClass != "" && className != "" ):
			break;
	
	if ( className == "" ):
		return;
	
	inheritance[className] = [];
	
	if ( inheritance.has( baseClass ) ):
		for inh in inheritance[baseClass]:
			inheritance[className].append( inh );
	
	if ( baseClass != "" ):
		inheritance[className].append( baseClass );

