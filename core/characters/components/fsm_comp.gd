extends UComponent
class_name UFSM

#variables
var fsm : CFSM = null;

func _onBegin() -> void:
	fsm = CFSM.new();
	fsm.statesParent = parent;
	callFSMConfigInit();
	
	.add_child( fsm );

func _onShutdown() -> void:
	fsm.queue_free();

func _onTick( delta ) -> void:
	fsm._onTick( delta );

func _onInput( event ):
	fsm._input( event );

#methods
#Autocall from parent character
func callFSMConfigInit() -> void:
	if ( parent.has_method( "configFSMComponent" ) ):
		fsm.loadConfig( parent.configFSMComponent() );

func _className():
	return "UFSM";
