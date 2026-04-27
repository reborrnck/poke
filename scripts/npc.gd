extends CharacterBody2D

@export var npc_name: String = "NPC"
@export var dialogue_lines: Array[String] = ["Hello, Trainer!", "Good luck on your journey!"]

var _player_nearby: bool = false


func _ready() -> void:
	var img := Image.create(28, 32, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.3, 0.5, 0.8, 1.0))
	for y in range(6, 12):
		for x in range(8, 12):
			img.set_pixel(x, y, Color.WHITE)
		for x in range(16, 20):
			img.set_pixel(x, y, Color.WHITE)
	for x in range(10, 18):
		img.set_pixel(x, 15, Color.WHITE)
	$Sprite2D.texture = ImageTexture.create_from_image(img)

	var shape := RectangleShape2D.new()
	shape.size = Vector2(28, 32)
	$CollisionShape2D.shape = shape


func _physics_process(_delta: float) -> void:
	if not _player_nearby:
		return
	if Events.dialogue_active:
		return
	if Input.is_action_just_pressed("ui_accept"):
		Events.show_dialogue.emit(npc_name, dialogue_lines)


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_nearby = true


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_nearby = false
