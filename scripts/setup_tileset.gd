@tool
extends EditorScript

## Run this once: File > Run Script (or right-click in Scripts panel)
## It generates res://resources/tileset.tres for use with TileMapLayer.

const TILE_SIZE := 32

# Tile indices in the tileset.png strip
enum Tile {
	GRASS = 0,
	TALL_GRASS = 1,
	DIRT_PATH = 2,
	WATER = 3,
	SAND = 4,
	TREE_TRUNK = 5,
	TREE_TOP = 6,
	HOUSE_WALL = 7,
	HOUSE_ROOF = 8,
	DOOR = 9,
	FENCE_H = 10,
	FENCE_V = 11,
}

# Which tiles should have physics collision
const SOLID_TILES := [
	Tile.WATER,
	Tile.TREE_TRUNK,
	Tile.TREE_TOP,
	Tile.HOUSE_WALL,
	Tile.HOUSE_ROOF,
	Tile.FENCE_H,
	Tile.FENCE_V,
]


func _run() -> void:
	var ts := TileSet.new()

	# Create atlas source from the tileset texture
	var tex := load("res://assets/tiles/tileset.png") as Texture2D
	if not tex:
		printerr("ERROR: tileset.png not found at res://assets/tiles/tileset.png")
		return

	var atlas := TileSetAtlasSource.new()
	atlas.texture = tex
	atlas.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)

	var src_id := ts.add_source(atlas)

	# Create tiles for each cell in the atlas
	for i in range(12):
		var coords := Vector2i(i, 0)
		ts.set_tile_script(i)

	# Add physics collision to solid tiles
	for tile_idx in SOLID_TILES:
		var coords := Vector2i(tile_idx, 0)
		# Create a simple rectangular collision matching the tile size
		var physics_data := TileData.new()
		var collision := RectangleShape2D.new()
		collision.size = Vector2(TILE_SIZE, TILE_SIZE)
		physics_data.add_collision_rect(0, Rect2(Vector2.ZERO, Vector2(TILE_SIZE, TILE_SIZE)))
		# Physics layers 0: full collision
		ts.set_tile_data(src_id, coords, physics_data)

	# Save
	var save_path := "res://resources/tileset.tres"
	var err := ResourceSaver.save(ts, save_path)
	if err == OK:
		print("TileSet saved to: ", save_path)
		print("  %d tiles, %d solid" % [12, SOLID_TILES.size()])
	else:
		printerr("Failed to save TileSet, error: ", err)
