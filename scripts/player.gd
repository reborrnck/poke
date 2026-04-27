extends CharacterBody2D

@export var speed: int = 200

var _can_move: bool = true


func _ready() -> void:
	add_to_group("player")
	Events.toggle_player.connect(_on_toggle_player)

	var img := Image.create(32, 32, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	for y in range(8, 13):
		img.set_pixel(8, y, Color.BLACK)
		img.set_pixel(22, y, Color.BLACK)
	img.set_pixel(12, 18, Color.BLACK)
	img.set_pixel(18, 18, Color.BLACK)
	$Sprite2D.texture = ImageTexture.create_from_image(img)


func _physics_process(_delta: float) -> void:
	if not _can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	move_and_slide()


func _on_toggle_player(active: bool) -> void:
	_can_move = active
