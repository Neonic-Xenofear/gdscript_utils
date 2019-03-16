extends Node2D
class_name CBaseObject

var propertyes : Dictionary = {};

func getObjectSaveData():
	pass

func addProperty( iName : String, type : int, value = null ) -> void:
	var nProperty : CProperty = CProperty.new();
	nProperty.type = type;
	nProperty.value = value;
	
	propertyes[iName] = nProperty;

func getProperty( iName : String ) -> CProperty:
	if ( propertyes.has( iName ) ):
		return propertyes[iName];
	
	return null;

func _className() -> String:
	return "CBaseObject";