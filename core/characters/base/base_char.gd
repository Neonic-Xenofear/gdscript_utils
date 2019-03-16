extends CBaseObject
class_name CBaseCharacter

var direction : Vector2 = Vector2( 1, 0 );
var velocity : Vector2 = Vector2( 0, 0 );
var parent = null;
var components : Array = []


#methods
func _onTick( delta ) -> void: pass
func _onInput( event ) -> void: pass

func _ready() -> void:
	if ( get_node( "COMPONENTS" ) ):
		for child in get_node( "COMPONENTS" ).get_children():
			_addComponent( child );
	else:
		for child in get_children():
			if ( globals.isInheritance( child, "UComponent" ) ):
				_addComponent( child );

func _process( delta ):
	for com in components:
		com._onTick( delta );
	
	_onTick( delta );

func _input( event ):
	for com in components:
		com._onInput( event );
	
	_onInput( event );

func _addComponent( i_component : UComponent ) -> void:
	if ( components.find( i_component ) == -1 ):
		i_component.initialize( self );
		components.push_back( i_component );
		
		if ( !i_component.get_owner() != self ):
			.add_child( i_component );

func getComponent( name ) -> UComponent:
	for comp in components:
		if( globals.isType( comp, name ) ):
			return comp;
	
	return null;

func _className() -> String:
	return "CBaseCharacter";