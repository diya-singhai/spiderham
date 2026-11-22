extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -600.0
@onready var RCBottomLeft = $raycasts/bottomleft
@onready var RCBottomRight = $raycasts/bottomright
var wallDirection = 0.0
var walljumped = 12923823

func _physics_process(delta: float) -> void:

	walljumped += delta * 60

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Wall detection
	var wallDirection = 0.0

	if is_on_wall():
		wallDirection = get_wall_normal().x

	# Jump
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

		elif is_on_wall():
			velocity.y = JUMP_VELOCITY
			velocity.x = wallDirection * 600
			walljumped = 0

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction < 0:
		$Sprite2D.flip_h = true
	elif direction > 0:
		$Sprite2D.flip_h = false
	


	if walljumped > 30:
		velocity.x = move_toward(velocity.x, direction * SPEED * 2.5, SPEED * 0.5)	

	move_and_slide()
