extends TileMapLayer

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
	var ts: TileSet = tile_set
	if ts.get_source_count() == 0:
		return

	# Ensure a physics layer exists on the TileSet
	if ts.get_physics_layers_count() == 0:
		ts.add_physics_layer()
		ts.set_physics_layer_collision_layer(0, 1)
		ts.set_physics_layer_collision_mask(0, 1)

	var atlas: TileSetAtlasSource = ts.get_source(0)
	if atlas == null:
		return

	const PHYSICS: int = 0
	var pts: PackedVector2Array = PackedVector2Array([
		Vector2(0, 0),
		Vector2(TILE_SIZE, 0),
		Vector2(TILE_SIZE, TILE_SIZE),
		Vector2(0, TILE_SIZE),
	])

	for tile_id: int in SOLID_TILES:
		var c: Vector2i = Vector2i(tile_id, 0)
		if not atlas.has_tile(c):
			atlas.create_tile(c, Vector2i(1, 1))
		var td: TileData = atlas.get_tile_data(c, 0)
		if td.get_collision_polygon_count(PHYSICS) == 0:
			td.add_collision_polygon(PHYSICS)
			td.set_collision_polygon_points(PHYSICS, 0, pts)


func generate() -> void:
	clear()
	for y: int in range(MAP_DATA.size()):
		var row: Array = MAP_DATA[y]
		for x: int in range(row.size()):
			var tile_id: int = row[x]
			if tile_id == T.NONE:
				continue
			set_cell(Vector2i(x, y), 0, Vector2i(tile_id, 0))
