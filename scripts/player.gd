extends CharacterBody2D

@export var speed: int = 200

func _ready() -> void:
	add_to_group("player")

	# Create a placeholder white square texture for the player
	var img := Image.create(32, 32, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	# Draw simple eyes
	for y in range(8, 13):
		img.set_pixel(8, y, Color.BLACK)
		img.set_pixel(22, y, Color.BLACK)
	img.set_pixel(12, 18, Color.BLACK)
	img.set_pixel(18, 18, Color.BLACK)
	var tex := ImageTexture.create_from_image(img)
	$Sprite2D.texture = tex

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	move_and_slide()
