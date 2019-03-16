extends UComponent
class_name UCamera

const heightSeeStrength : int = 250;
const DELTA_SPEED : Vector2 = Vector2( 6, 7 );

var viewportStartSize : Vector2 = Vector2( 1920 * 2, 1080 * 2 );

var bounds : CCameraBounds = null;
var camera = null;

func _onBegin() -> void:
	pass

func _onTick( delta ) -> void:
	processPosition( delta );

func processPosition( delta ):
	if ( parent != null ):
		var canvasTransform = parent.get_viewport().canvas_transform;
		var newPos : Vector2 = Vector2( 0, 0 );
		var yDir : int = 0;
		
		if ( Input.is_action_pressed( "a_camLookUp" ) ):
			yDir = -1;
		
		if ( Input.is_action_pressed( "a_camLookDown" ) ):
			yDir = 1;
		
		var pos = ( -parent.position + viewportStartSize / 2 - ( Vector2( parent.direction.x * 200, yDir * 150 ) ) );
		
		newPos.x = lerp( canvasTransform.get_origin().x, pos.x, delta * DELTA_SPEED.x );
		newPos.y = lerp( canvasTransform.get_origin().y, pos.y, delta * DELTA_SPEED.y );
		
		if ( camera ):
			var nP = calcBounds( newPos );
			
			camera.position.x = -nP.x;
			camera.position.y = -lerp( -camera.position.y, nP.y, delta * 3 );

func calcBounds( pos_ : Vector2 ) -> Vector2:
	if ( bounds == null ):
		return pos_;
	
	var pos : Vector2 = pos_;
	
	if ( -pos.x <= bounds.getLeft() ):
		pos.x = -bounds.getLeft();
	
	if ( -pos.x + viewportStartSize.x >= bounds.getRight() ):
		pos.x = -bounds.getRight() + viewportStartSize.x;
	
	if ( -pos.y <= bounds.getTop() ):
		pos.y = -bounds.getTop();
	
	if ( -pos.y + viewportStartSize.y >= bounds.getBottom() ):
		pos.y = -bounds.getBottom() + viewportStartSize.y;
	
	return pos;


func _className():
	return "UCamera";