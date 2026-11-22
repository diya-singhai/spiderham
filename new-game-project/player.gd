extends CharacterBody2D

#region player variables

# nodes
@onready var RCBottomLeft = $raycasts/walljump/bottomleft
@onready var RCBottomRight = $raycasts/walljump/bottomright

# physics variables
const RUN_SPEED = 300
const ACCELERATION = 60
const DECELERATION = 50
const GRAVITY = 600
const JUMP_VELOCITY = -300
const MAX_JUMPS = 2


const AIR_ACCELERATION = 30
const AIR_DECELERATION = 40

const WALL_KICK_ACCELERATION = 8
const WALL_KICK_DECELERATION = 10
const WALL_JUMP_Y_SPEED_PEAK = 0
const WALL_JUMP_VELOCITY = -380
const WALL_JUMP_H_SPEED = 240

var moveSpeed = RUN_SPEED
var moveDirectionX = 0
var jumps = 0
var facing = 1
var wallDirection = Vector2.ZERO

# input variables
var keyUp = false
var keyDown = false
var keyLeft = false
var keyRight = false
var keyJump = false
var keyJumpPressed = false

#endregion

func _physics_process(delta: float) -> void:
	GetInputStates()
	
	# handle movements
	HandleGravity(delta)
	HorizontalMovement()
	HandleJump()
	HandleWallJump()
	
	# commit movement
	move_and_slide()

func GetInputStates():
	keyUp = Input.is_action_pressed("KeyUp")
	keyDown = Input.is_action_pressed("KeyDown")
	keyLeft = Input.is_action_pressed("KeyLeft")
	keyRight = Input.is_action_pressed("KeyRight")
	keyJump = Input.is_action_pressed("KeyJump")
	keyJumpPressed = Input.is_action_just_pressed("KeyJump")
	
	if (keyRight): facing = 1
	if (keyLeft): facing = -1

func HorizontalMovement(acceleration: float = ACCELERATION, deceleration: float = DECELERATION):
	moveDirectionX = Input.get_axis("KeyLeft", "KeyRight")
	if (moveDirectionX != 0):
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, moveDirectionX * moveSpeed, DECELERATION)

func HandleGravity(delta):
	if (!is_on_floor()):
		velocity.y += GRAVITY * delta
	else:
		jumps = 0
		
func HandleJump():
	if (keyJumpPressed):
		if (jumps < MAX_JUMPS):
			velocity.y = JUMP_VELOCITY
			jumps += 1

func HandleWallJump():
	GetWallDirection()
	if keyJumpPressed and wallDirection != Vector2.ZERO:
		velocity.y = WALL_JUMP_VELOCITY
		velocity.x = -wallDirection.x * WALL_JUMP_H_SPEED
		jumps = 1

func GetWallDirection():
	if (RCBottomRight.is_colliding()):
		wallDirection = Vector2.RIGHT
	elif (RCBottomLeft.is_colliding()):
		wallDirection = Vector2.LEFT
	else:
		wallDirection = Vector2.ZERO
