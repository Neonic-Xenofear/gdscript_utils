extends Node

const verMajor = 0;
const verMinor = 1;
const verPath = 0;

var settings : CCoreSettings = CCoreSettings.new();
var bt_globals : CBTGlobals = CBTGlobals.new();
var levels : CLevelsManager = CLevelsManager.new();
var sglModules : CSGLMModules = CSGLMModules.new();
var translation : CTranslation = CTranslation.new();

var player = null;
var playerNode : Node2D = null;

var inheritance : Dictionary = {};

func getGameVersion() -> Array:
	return [verMajor, verMinor, verPath];

func getGameVersionAsString() -> String:
	return str( verMajor, ".", verMinor, ".", verPath );

func isType( obj, checkName : String ) -> bool:
	if ( obj != null ):
		if ( obj.has_method( "_className" ) ):
			return obj.call( "_className" ) == checkName;
	
	return false;

func isInheritance( obj, checkName : String ) -> bool:
	if ( obj != null ):
		var inh : Array = [];
		if ( obj.has_method( "_className" ) ):
			inh = inheritance[obj._className()];
			return inh.has( checkName );
	
	return false;

func _init():
	var confFile : File = File.new();
	if ( confFile.open( settings.getVar( "inheritance_file" ), confFile.READ ) != 0 ):
		printerr( "[GAME] Cannot load inheritance config file!" );
		get_tree().quit();
	
	inheritance = parse_json( confFile.get_as_text() );
	confFile.close();
	
	translation._setup( settings.getVar( "translations_path" ) );