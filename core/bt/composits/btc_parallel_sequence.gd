extends CBTComposite
class_name CBTParallelSequence

var bUseSuccessFailPolicy : bool = false;
var bSuccessOnAll : bool = true;
var bFailOnAll : bool = true;
var minSuccess : int = 0;
var minFail : int = 0;

func _onTick( tick : float ) -> int:
	var minimumSuccess : int = minSuccess;
	var minimumFail : int = minFail;
	
	if ( bUseSuccessFailPolicy ):
		if ( bSuccessOnAll ):
			minimumSuccess = children.size();
		else:
			minimumSuccess = 1;
		
		if ( bFailOnAll ):
			minimumFail = children.size();
		else:
			minimumFail = 1;
	
	var totalSucces : int = 0;
	var totalFail : int = 0;
	
	for child in children:
		var stat : int = child._tick( tick );
		
		if ( stat == BTS_SUCCESS ):
			totalSucces += 1;
		elif ( stat == BTS_FAILURE ):
			totalFail += 1;
	
	if ( totalSucces >= minimumSuccess ):
		return BTS_SUCCESS;
	elif ( totalFail >= minimumFail ):
		return BTS_FAILURE;
	
	return BTS_RUNNING;