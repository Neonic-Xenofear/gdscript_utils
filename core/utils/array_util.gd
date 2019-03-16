extends CBaseObject
class_name CArrayUtil

static func insertArray( index : int, array : Array, val : Array ) -> void:
	var i : int = index;
	var resSize : int = array.size() + val.size();
	
	while ( val.size() != 0 ):
		array.insert( i, val[0] );
		val.remove( 0 );
	