""" 
The Selector composite ticks each child node in order.
If a child succeeds or runs, the selector returns the same status.
In the next tick, it will try to run each child in order again.
If all children fails, only then does the selector fail.
"""
extends CBTComposite
class_name CBTSelector

func _onTick( tick : float ) -> int:
	while ( iter < children.size() ):
		var stat : int = children[iter]._tick( tick );
		
		if ( stat != BTS_FAILURE ):
			return stat;
		
		iter += 1;
	
	return BTS_FAILURE;