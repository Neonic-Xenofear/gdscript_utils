""" 
The StatefulSelector composite ticks each child node in order, and remembers what child it prevously tried to tick.
If a child succeeds or runs, the stateful selector returns the same status.
In the next tick, it will try to run the next child or start from the beginning again.
If all children fails, only then does the stateful selector fail.
"""
extends CBTComposite
class_name CBTStatefulSelector

func _onTick( tick : float ) -> int:
	while ( iter < children.size() ):
		var stat : int = children[iter]._tick( tick );
		
		if ( stat != BTS_FAILURE ):
			return stat;
		
		iter += 1;
	
	iter = 0;
	return BTS_FAILURE;