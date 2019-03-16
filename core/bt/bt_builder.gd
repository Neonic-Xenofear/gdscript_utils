class_name CBTBuilder

class CBTCompositeBuilder:
	var parent = null;
	var node : CBTComposite = null;
	var blackboard = null;
	
	func _initialize( iParent, iNode, iBlackboard ):
		parent = iParent;
		node = iNode;
		blackboard = iBlackboard;
	
	func leaf( args ) -> Object:
		var dec = globals.bt_globals.leafs[args["type"]].new();
		dec._initialize( args );
		dec.blackboard = blackboard;
		node.addChild( dec );
		return self;
	
	func decorator( args ) -> Object:
		var dec = globals.bt_globals.decorators[args["type"]].new();
		dec._initialize( args );
		node.addChild( dec );
		
		var decBuilder = CBTDecoratorBuilder.new();
		decBuilder._initialize( self, dec, blackboard );
		return decBuilder;
	
	func composite( args ) -> Object:
		var dec = globals.bt_globals.composits[args["type"]].new();
		dec._initialize( args );
		node.addChild( dec );
		
		var decBuilder = CBTCompositeBuilder.new();
		decBuilder._initialize( self, dec, blackboard );
		return decBuilder;
	
	func end() -> Object:
		return parent;

class CBTDecoratorBuilder:
	var parent = null;
	var node : CBTDecorator = null;
	var blackboard = null;
	
	func _initialize( iParent, iNode, iBlackboard ):
		parent = iParent;
		node = iNode;
		blackboard = iBlackboard;
	
	func leaf( args ) -> Object:
		var dec = globals.bt_globals.leafs[args["type"]].new();
		dec._initialize( args );
		dec.blackboard = blackboard;
		node.setChild( dec );
		return self;
	
	func decorator( args ) -> Object:
		var dec = globals.bt_globals.decorators[args["type"]].new();
		dec._initialize( args );
		node.setChild( dec );
		
		var decBuilder = CBTDecoratorBuilder.new();
		decBuilder._initialize( self, dec, blackboard );
		return decBuilder;
	
	func composite( args ) -> Object:
		var dec = globals.bt_globals.composits[args["type"]].new();
		dec._initialize( args );
		node.setChild( dec );
		
		var decBuilder = CBTCompositeBuilder.new();
		decBuilder._initialize( self, dec, blackboard );
		return decBuilder;
	
	func end() -> Object:
		return parent;

var interpreter : CSGLScriptInterpreterImpl.CSGLScriptInterpreter = CSGLScriptInterpreterImpl.CSGLScriptInterpreter.new();
var behaviorTree : CBTBehaviorTree = CBTBehaviorTree.new();
var currBuilder = null;

func _init():
	interpreter.parent = self;
	interpreter.bAutoStart = true;

func loadConfigFile( path : String ) -> void:
	interpreter._reset();
	interpreter.loadFile( path );

func dc_decorator( args ) -> void:
	if ( currBuilder == null ):
		behaviorTree.root = globals.bt_globals.decorators[args["type"]].new();
		currBuilder = CBTDecoratorBuilder.new();
		currBuilder._initialize( self, behaviorTree.root, behaviorTree.blackboard );
	
	currBuilder = currBuilder.decorator( args );

func dc_composite( args ) -> void:
	if ( currBuilder == null ):
		behaviorTree.root = globals.bt_globals.composits[args["type"]].new();
		currBuilder = CBTCompositeBuilder.new();
		currBuilder._initialize( self, behaviorTree.root, behaviorTree.blackboard );
	
	currBuilder = currBuilder.composite( args );

func dc_leaf( args ) -> void:
	currBuilder.leaf( args );

func dc_end( args ) -> void:
	currBuilder = currBuilder.end();

#Blackboard commands
func dc_blackboard( args ) -> void:
	if ( behaviorTree.blackboard == null ):
		behaviorTree.blackboard = CBTBlackboard.new();

func dc_bb_var( args : Dictionary ) -> void:
	behaviorTree.blackboard.setVar( args.keys()[0], args[args.keys()[0]] );

func getBehaviorTree() -> CBTBehaviorTree:
	return behaviorTree;