#ORIGINAL: https://medium.com/kitschdigital/2d-path-finding-with-astar-in-godot-3-0-7810a355905a
#Uses tile positions as coordinates!
extends TileMap
class_name CAStarTilemap

onready var astar = AStar.new();
onready var traversableTiles : Array = get_used_cells();
onready var usedRect : Rect2 = get_used_rect();

func _ready():
	_addTraversableTiles( traversableTiles );
	_connectTraversableTiles( traversableTiles );

# Returns a path from start to end
func _getPath( start : Vector2, end : Vector2 ) -> Array:
	var startId = _getIdForPoint( start );
	var endId = _getIdForPoint( end );
	if ( !astar.has_point( startId ) || !astar.has_point( endId ) ):
		return [];
	
	var pathMap = astar.get_point_path( startId, endId );
	var pathWorld = [];
	for point in pathMap:
		var pointWorld = point;
		pathWorld.append( pointWorld );
	
	return pathWorld;

# Determines a unique ID for a given point on the map
func _getIdForPoint( point : Vector2 ) -> int:
	var x = point.x - usedRect.position.x;
	var y = point.y - usedRect.position.y;
	
	return x + y * usedRect.size.x;

# Adds tiles to the A* grid but does not connect them
# ie. They will exist on the grid, but you cannot find a path yet
func _addTraversableTiles( traversableTiles : Array ) -> void:
	for tile in traversableTiles:
		var id = _getIdForPoint( tile );
		astar.add_point( id, Vector3( tile.x, tile.y, 0 ) );

# Connects all tiles on the A* grid with their surrounding tiles
func _connectTraversableTiles( traversableTiles ) -> void:
	for tile in traversableTiles:
		
		var id = _getIdForPoint( tile );
		for x in range( 3 ):
			
			for y in range( 3 ):
				var target = tile + Vector2( x - 1, y - 1 )
				var targetId = _getIdForPoint(target)
				
				if ( tile == target || !astar.has_point( targetId ) ):
					continue;
				
				astar.connect_points( id, targetId, true );