class_name CFileUtil

static func listFilesInDir( path : String, bAppPath : bool = false, bDeepMode : bool = false, b1D : bool = false ) -> Array:
	var files : Array = [];
	var dir : Directory = Directory.new();
	
	if ( path.ends_with( "/" ) ):
		dir.open( path );
	else:
		dir.open( path + "/" );
	
	dir.list_dir_begin();
	
	while ( true ):
		var file : String = dir.get_next();
		if ( file == "" ):
			break;
		
		#Process files inside other dirs
		if( dir.dir_exists( file ) && bDeepMode && !file.begins_with( "." ) ):
			var otherFiles = listFilesInDir( path + file + "/", bAppPath, bDeepMode, b1D )
			if ( b1D ): #Generate single dimention array of objects
				for item in otherFiles:
					files.append( item );
			else:
				files.append( listFilesInDir( path + file + "/", bAppPath, bDeepMode, b1D ) );
		elif ( !file.begins_with( "." ) ):
			if ( bAppPath ):
				files.append( path + file );
			else:
				files.append( file );
	
	dir.list_dir_end();
	
	return files;

static func getFileDataAsText( path : String ) -> String:
	var file : File = File.new();
	var data : String = "";
	
	file.open( path, file.READ );
	data = file.get_as_text();
	file.close();
	
	return data;

static func parseJsonFromFile( path : String ) -> Dictionary:
	return parse_json( getFileDataAsText( path ) );


