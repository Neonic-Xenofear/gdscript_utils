extends Node
class_name CBTGlobals

var leafs : Dictionary = {
	"say": CBTSay,
	"follow": CBTFollow
}

var composits : Dictionary = {
	"sequence": CBTSequence,
	"memSequence": CBTMemSequence,
	"parallelSequens": CBTParallelSequence,
	"selector": CBTSelector,
	"statefulSelector": CBTStatefulSelector,
}

var decorators : Dictionary = {
	"failer": CBTFailer,
	"succeder": CBTSucceder,
	"inverter": CBTInverter,
	"repeater": CBTRepeater,
	"untilFailure": CBTUntilFailure,
	"untilSuccess": CBTUntilSuccess,
}

func regLeaf( name : String, type ) -> void:
	leafs[name] = type;

func regComposit( name : String, type ) -> void:
	composits[name] = type;

func regDecorator( name : String, type ) -> void:
	decorators[name] = type;