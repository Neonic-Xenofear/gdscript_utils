extends CBaseObject
class_name CStringUtil

static func arrToString( arr : Array, separator : String = "") -> String:
	return PoolStringArray(arr).join(separator);
