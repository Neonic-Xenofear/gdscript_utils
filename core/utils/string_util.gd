extends CBaseObject
class_name CStringUtil

static func arrToString( arr : Array, separator : String = "") -> String:
	var result : String = "";
	
	for s in arr:
		result += str( s ) + separator;
	
	result = result.left( result.length() - separator.length() );
	
	return result;
