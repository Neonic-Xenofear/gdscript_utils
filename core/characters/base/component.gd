extends CBaseObject
class_name UComponent

var parent : CBaseObject = null;

func initialize( i_parent : CBaseObject ) -> void:
	if ( i_parent != null ):
		parent = i_parent;
		_onBegin();

func _onBegin() -> void:
	pass

func _onShutdown() -> void:
	pass

func _onTick( delta ) -> void:
	pass

func _onInput( event ):
	pass

func _className():
	return "UComponent";