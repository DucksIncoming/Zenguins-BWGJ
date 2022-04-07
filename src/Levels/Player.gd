extends KinematicBody2D

# A million fuckin variables lmao
export var speed := 600
export var jumpPower := 900
export var gravity := 4500
export var coyoteDelta := 1
var _velocity = Vector2.ZERO
const UP_DIRECTION := Vector2.UP
var jump_attempted = false
var deltaSinceJump = 0
var floor_memory = coyoteDelta

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	# General movement
	var _horizontal_direction = (
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	)
	
	_velocity.x = _horizontal_direction * speed
	_velocity.y += gravity * delta * int(not is_on_floor())
	
	var is_falling = _velocity.y > 0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	floor_memory = max(coyoteDelta * int(is_on_floor()), floor_memory)
	jump_attempted = Input.is_action_just_pressed("jump") or jump_attempted
	deltaSinceJump = max(0, deltaSinceJump)
	
	# Giant, poorly optimized coyote time shit
	if (jump_attempted and not is_jumping and floor_memory > 0):
		_velocity.y = -jumpPower
		floor_memory = 0
	elif (jump_attempted and not is_jumping):
		if (is_on_floor()):
			_velocity.y = -jumpPower
			jump_attempted = false
			floor_memory = 0
			deltaSinceJump = 0
		elif (deltaSinceJump < coyoteDelta):
			deltaSinceJump += 1
			floor_memory = max(0, (floor_memory - 1))
		else:
			jump_attempted = false
			floor_memory = 0
			deltaSinceJump = 0
	else:
		jump_attempted = false
		floor_memory = max(0, (floor_memory - 1))
		deltaSinceJump = 0
	
	if (is_jumping):
		_velocity.y = -jumpPower
	
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
