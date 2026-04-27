extends TileMapLayer

## Populates the map with cells. Call generate() or enable auto_generate.

@export var auto_generate: bool = true

const TILE_SIZE := 32

enum T {
	NONE  = -1,
	GRASS = 0,
	TALL_GRASS = 1,
	DIRT = 2,
	WATER = 3,
	SAND = 4,
	TRUNK = 5,
	TREE_TOP = 6,
	WALL = 7,
	ROOF = 8,
	DOOR = 9,
	FENCE_H = 10,
	FENCE_V = 11,
}

const SOLID_TILES: Array[int] = [
	T.WATER, T.TRUNK, T.TREE_TOP, T.WALL, T.ROOF, T.FENCE_H, T.FENCE_V
]

const MAP_DATA: Array[Array] = [
	[3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
	[3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
	[0,0,0,0,0,0,6,0,6,6,0,0,0,6,6,0,0,0,6,6,0,6,6,0,0,0,0,0,0,0],
	[0,0,0,6,6,6,6,0,0,6,6,6,6,6,0,6,6,6,6,0,6,6,0,6,6,0,0,0,0,0],
	[0,0,6,6,0,0,0,6,6,6,0,0,0,6,6,6,0,0,0,6,6,0,6,6,6,6,0,0,0,0],
	[0,0,5,0,0,0,0,0,5,0,0,2,2,2,2,2,0,0,5,0,0,0,0,0,5,0,0,0,0,0],
	[0,0,5,0,0,0,0,0,5,0,0,2,2,2,2,2,0,0,5,0,0,0,0,0,5,0,0,0,0,0],
	[0,0,5,0,0,0,0,0,5,4,4,4,4,4,4,4,4,4,5,7,7,7,7,7,5,0,0,0,0,0],
	[0,0,5,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,7,7,7,7,7,5,0,0,0,0,0],
	[0,0,5,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,9,9,7,7,7,5,0,0,0,0,0],
	[0,0,5,2,2,2,2,2,5,0,0,1,1,1,0,0,5,2,2,7,7,7,7,7,5,0,0,0,0,0],
	[0,0,5,0,0,5,0,0,5,0,0,1,1,1,0,0,5,2,2,2,2,2,2,2,5,0,0,0,0,0],
	[0,0,0,0,0,5,0,0,5,0,0,1,1,1,0,0,5,0,0,5,0,0,0,0,5,0,0,0,0,0],
	[0,0,0,0,0,5,0,0,5,0,0,0,0,0,0,0,5,0,0,5,2,2,2,2,2,0,0,0,0,0],
	[0,0,0,0,0,5,2,2,2,0,0,0,0,0,0,0,5,0,0,5,2,2,2,2,2,0,0,0,0,0],
	[0,0,0,0,0,5,2,2,2,0,0,1,1,1,0,0,5,0,0,5,0,5,0,0,5,0,0,0,0,0],
	[0,0,0,0,0,0,0,5,0,0,1,1,1,1,1,0,0,0,0,5,2,2,2,2,2,0,0,0,0,0],
	[0,0,0,6,6,6,6,5,0,1,1,1,1,1,1,1,0,0,0,5,0,0,0,0,0,0,0,0,0,0],
	[0,0,6,6,0,0,0,5,0,0,1,1,1,1,1,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0],
	[0,0,5,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
]


func _ready() -> void:
	if auto_generate and tile_set:
		_setup_collisions()
		generate()


func _setup_collisions() -> void:
	# Add physics collision to solid tiles (the .tres lost hand-edited data)
	var ts := tile_set
	if ts.get_source_count() == 0:
		return
	var src_id := 0
	for tile_id: int in SOLID_TILES:
		var coords := Vector2i(tile_id, 0)
		var td: TileData = ts.get_tile_data(src_id, coords, 0)
		if td == null:
			td = TileData.new()
		td.set_collision_polygons_count(0, 1)
		td.set_collision_polygon_points(0, 0, PackedVector2Array([
			Vector2(0, 0),
			Vector2(TILE_SIZE, 0),
			Vector2(TILE_SIZE, TILE_SIZE),
			Vector2(0, TILE_SIZE),
		]))
		ts.set_tile_data(src_id, coords, td)


func generate() -> void:
	clear()
	for y: int in range(MAP_DATA.size()):
		var row: Array = MAP_DATA[y]
		for x: int in range(row.size()):
			var tile_id: int = row[x]
			if tile_id == T.NONE:
				continue
			set_cell(Vector2i(x, y), 0, Vector2i(tile_id, 0))
