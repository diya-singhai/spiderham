extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -600.0
@onready var RCBottomLeft = $raycasts/bottomleft
@onready var RCBottomRight = $raycasts/bottomright
var wallDirection = Vector2.ZERO
var walljumped = 12923823

func _physics_process(delta: float) -> void:
	walljumped += delta * 60
	
	#print(delta, walljumped)
	GetWallDirection();
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or wallDirection != Vector2.ZERO):
		velocity.y = JUMP_VELOCITY
		velocity.x = wallDirection.x * 400
		if (wallDirection != Vector2.ZERO):
			walljumped = 0
		print(velocity.x)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and walljumped > 30:
		velocity.x += direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED * 0.1 * delta)
		# velocity.x += (velocity.x * 0.6 - velocity.x) * delta
		# velocity.x *= 0.6

	#print(velocity)
	#print(walljumped)
	move_and_slide()
	print(velocity)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)	
		print("Collided with: ", collision.get_collider().name)
	#print(walljumped)


func GetWallDirection():
	if (RCBottomRight.is_colliding()):
		wallDirection = Vector2.RIGHT
	elif (RCBottomLeft.is_colliding()):
		wallDirection = Vector2.LEFT
	else:
		wallDirection = Vector2.ZERO
