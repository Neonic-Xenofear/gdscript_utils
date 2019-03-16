""" 
The MemSequence composite ticks each child node in order, and remembers what child it prevously tried to tick.
If a child fails or runs, the stateful sequence returns the same status.
In the next tick, it will try to run the next child or start from the beginning again.
If all children succeeds, only then does the stateful sequence succeed.
"""
extends CBTComposite
class_name CBTMemSequence

func _onTick( tick : float ) -> int:
	while ( iter < children.size() ):
		var stat : int = children[iter]._tick( tick );
		
		if ( stat != BTS_SUCCESS ):
			return stat;
		
		iter += 1;
	
	iter = 0;
	return BTS_SUCCESS;