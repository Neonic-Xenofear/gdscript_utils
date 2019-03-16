""" 
The Sequence composite ticks each child node in order.
If a child fails or runs, the sequence returns the same status.
In the next tick, it will try to run each child in order again.
If all children succeeds, only then does the sequence succeed.
"""
extends CBTComposite
class_name CBTSequence

func _onTick( tick : float ) -> int:
	while ( iter < children.size() ):
		var stat : int = children[iter]._tick( tick );
		
		if ( stat != BTS_SUCCESS ):
			return stat;
		
		iter += 1;
	
	return BTS_SUCCESS;