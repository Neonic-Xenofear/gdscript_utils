extends Node
class_name CMath

#Return normalized absolute value
#   normAbs( -10 ) == -1
#   normAbs( 10 ) == 1
static func normAbs( val ):
	if ( val != 0 ):
		return val / abs( val );
	
	return val;