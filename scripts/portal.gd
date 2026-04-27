extends Area2D

@export var target_scene: String = ""       # e.g. "res://scenes/house_interior.tscn"
@export var target_spawn: String = "spawn"  # spawn point name in target scene
@export var transition_fade: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if target_scene.is_empty():
		return

	Events.request_scene_change.emit(target_scene, target_spawn)
