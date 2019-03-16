extends CBTNode
class_name CBTComposite

var children : Array = [];
var iter : int = 0;
	
func addChild( child : CBTNode ) -> void:
	children.push_back( child );