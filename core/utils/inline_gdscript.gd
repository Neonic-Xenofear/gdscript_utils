class_name CInlineGDScript

static func getScriptByString( code : String ) -> Reference:
	var script : GDScript = GDScript.new();
	var ref : Reference = Reference.new();
	
	script.source_code = code;
	script.reload();
	
	ref.set_script( script );
	return ref;

static func execFromFile( path : String, execName : String = "main" ) -> Reference:
	return execFromString( CFileUtil.getFileDataAsText( path ), execName );

static func execFromString( code : String, execName : String = "main" ) -> Reference:
	var script : GDScript = GDScript.new();
	var ref : Reference = Reference.new();
	
	script.source_code = code;
	script.reload();
	
	ref.set_script( script );
	ref.call( "main" )
	
	return ref;