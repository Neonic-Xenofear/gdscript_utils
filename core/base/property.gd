class_name CProperty

enum EPropertyType {
	PT_NONE = -1,
	PT_STRING = 0,
	PT_BOOL = 1,
	PT_INT = 2,
	PT_FLOAT = 3,
}

var type : int = EPropertyType.PT_NONE;
var value = null;