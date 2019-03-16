extends CBaseObject
class_name CSGLMModules

var modules : Array = [];

func regModule( module ) -> void:
	if ( globals.isInheritance( module, "CSGLModule" ) ):
		modules.append( module );
