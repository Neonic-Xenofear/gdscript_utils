extends CBaseObject
class_name CTranslation

var translations : Dictionary = {};

func _setup( path : String ) -> void:
	var dir : Directory = Directory.new();
	if ( !dir.dir_exists( path ) ):
		dir.make_dir( path );

func loadFile() -> void:
	translations = CCSVLoader.load_csv_translation( "" );