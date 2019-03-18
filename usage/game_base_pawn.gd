extends CPawn
class_name CGameBasePawn

func _ready() -> void:
	_addComponent( UPlatformerMovement.new() );
	_addComponent( UFSM.new() );
	_addComponent( UHealth.new() );
	
	getComponent( "UHealth" ).connect( "onCurrentHPUpdated", self, "_onHPUpdated" );
	getComponent( "UHealth" ).connect( "onDie", self, "_onDie" );
	
	if ( get_node( "COMPONENTS/UHitboxComponent" ) != null ):
		get_node( "COMPONENTS/UHitboxComponent" ).connect( "onHit", self, "_onHit" );

func _onHPUpdated( newVal : float ) -> void:
	pass

func _onHit( from ) -> void:
	pass

func _onDie() -> void:
	pass

func _className() -> String:
	return "CGameBasePawn";