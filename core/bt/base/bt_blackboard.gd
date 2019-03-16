class_name CBTBlackboard

var variables : Dictionary = {};

func setVar( name : String, val ) -> void:
	variables[name] = val;
	
func getVar( name : String ):
	var resName = name.to_lower();
	if ( variables.has( resName ) ):
		return variables[resName];
	
	return null;