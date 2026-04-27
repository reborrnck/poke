extends Node

## Autoload singleton that manages scene transitions and spawn points.

var _pending_spawn: String = ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Events.request_scene_change.connect(_on_scene_change_requested)
	# After scene changes, position the player
	get_tree().tree_changed.connect(_on_tree_changed)


func change_scene(path: String, spawn_point: String = "") -> void:
	_pending_spawn = spawn_point
	get_tree().change_scene_to_file(path)


func _on_scene_change_requested(path: String, spawn: String) -> void:
	change_scene(path, spawn)


func _on_tree_changed() -> void:
	if _pending_spawn.is_empty():
		return
	# Use call_deferred to ensure the new scene's _ready has run
	call_deferred("_place_player_at_spawn")


func _place_player_at_spawn() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if not player:
		return
	var spawns := get_tree().get_nodes_in_group("spawn_point")
	for sp in spawns:
		if sp.name == _pending_spawn:
			player.global_position = (sp as Node2D).global_position
			_pending_spawn = ""
			return
	# Also check for spawn meta
	for sp in spawns:
		if sp.has_meta("spawn_name") and sp.get_meta("spawn_name") == _pending_spawn:
			player.global_position = (sp as Node2D).global_position
			_pending_spawn = ""
			return
	_pending_spawn = ""
