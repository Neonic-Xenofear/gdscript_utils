extends CBaseObject
class_name CFSM

#variables
var statesParent = null;
var states : Dictionary = {};
var transitions : Dictionary = {};
var currentState = null; #: CStateImpl.CState

#methods
func loadConfig( config : Dictionary = {} ) -> void:
	if ( "states" in config ):
		setStates( config.states );
	
	if ( "transitions" in config ):
		setTransitions( config.transitions );
	
	if ( "currentState" in config ):
		setCurrentState( config.currentState );
	
	Console.Log.info( str( statesParent ) + "FSM: Config loaded" );

func setState( stateId : String, state ) -> void:
	states[stateId] = state;
	state.id = stateId;
	state.parent = statesParent;
	state.machine = self;
	
	.add_child( state );

func getState( stateId : String ) -> CStateImpl.CState:
	return states[stateId];

func setStates( nStates : Array ) -> void:
	for st in nStates:
		if( st.id && st.state ):
			setState( st.id, st.state.new() );

func transition( idTransition : String ) -> void:
	if ( !avaibleTransition( idTransition ) ):
		return;
	
	var from = getState( currentState.id );
	var to = getState( idTransition );
	
	if ( from.has_method( CStateImpl.CState.leaveName ) ):
		from.call( CStateImpl.CState.leaveName );
	
	setCurrentState( idTransition );

func avaibleTransition( idTransition : String ) -> bool:
	if ( transitions.has( currentState.id ) ):
		return idTransition in states && idTransition in transitions[currentState.id].toStates;
	
	return false;

func addTransition( idFrom : String, idTo : String ) -> void:
	if ( !idFrom in states || !idTo in states ):
		print( statesParent,
		"FSM: Cannot add transition, invalid state(s): \n",
		"idFrom: ", idFrom, "\n",
		"idTo: ", idTo );
		return;
	
	if( idFrom in transitions ):
		transitions[idFrom].toStates.append( idTo );
	else:
		transitions[idFrom] = { "toStates" : [idTo] };

func setTransition( idState : String, idToStates : Array ) -> void:
	if ( idState in states ):
		transitions[idState] = { "toStates": idToStates };
	else:
		print( statesParent, "FSM: Cannot set transition, invalid state: ", idState );

func getTransition( idState : String ) -> Dictionary:
	if ( idState in transitions ):
		return transitions[idState];
	else:
		print( statesParent, "FSM: Cannot get transition, invalid state: ", idState );
		return {};

func setTransitions( nTransitions : Array ) -> void:
	for tr in nTransitions:
		if ( tr.id && tr.toStates ):
			setTransition( tr.id, tr.toStates );

func setCurrentState( stateId : String ) -> void:
	if ( stateId in states ):
		states[stateId].call( CStateImpl.CState.enterName );
		currentState = states[stateId];

func _onTick( delta : float ) -> void:
	if ( currentState == null ):
		return;
	if ( currentState.has_method( "_onTick" ) ):
		currentState._onTick( delta );

func _input( event ) -> void:
	if ( currentState == null ):
		return;
	if ( currentState.has_method( "_onInput" ) ):
		currentState._onInput( event );

