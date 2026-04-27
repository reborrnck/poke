extends CharacterBody2D

@export var npc_name: String = "NPC"
@export var dialogue_lines: Array[String] = ["Hello, Trainer!", "Good luck on your journey!"]
@export var look_direction: Vector2 = Vector2.DOWN

var player_nearby: bool = false
var _current_line: int = 0

func _ready() -> void:
	# Create a simple colored rectangle for NPC visual
	var img := Image.create(28, 32, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.3, 0.5, 0.8, 1.0))
	# Draw a simple face
	for y in range(6, 12):
		for x in range(8, 12):
			img.set_pixel(x, y, Color.WHITE)
		for x in range(16, 20):
			img.set_pixel(x, y, Color.WHITE)
	for x in range(10, 18):
		img.set_pixel(15, x, Color.WHITE)

	var tex := ImageTexture.create_from_image(img)
	$Sprite2D.texture = tex

	# Collision shape
	var shape := RectangleShape2D.new()
	shape.size = Vector2(28, 32)
	$CollisionShape2D.shape = shape


func _physics_process(_delta: float) -> void:
	if not player_nearby:
		return

	if Input.is_action_just_pressed("ui_accept"):
		_talk()


func _talk() -> void:
	if _current_line >= dialogue_lines.size():
		_current_line = 0
		return

	var line := dialogue_lines[_current_line]
	_current_line += 1
	if _current_line >= dialogue_lines.size():
		_current_line = 0

	# Signal to dialogue system
	Events.show_dialogue.emit(npc_name, line)


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		_current_line = 0
