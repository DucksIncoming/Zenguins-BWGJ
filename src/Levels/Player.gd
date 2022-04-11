extends KinematicBody2D

# A million fuckin variables lmao
export var speed := 600
export var jumpPower := 400
export var gravity := 1000
export var coyoteDelta := 5
export var climbSpeed := 400
var _velocity = Vector2.ZERO
const UP_DIRECTION := Vector2.UP
var jump_attempted = false
var deltaSinceJump = 0
var floor_memory = coyoteDelta
var jumpFrame = 0
const ZenguinResource = preload("res://src/Scenes/Zenguin.tscn")
onready var sprite = $Sprite
onready var animTree = $AnimationTree
onready var animPlayer = $AnimationPlayer
onready var animState = animTree.get("parameters/playback")
onready var Spawnpoint = get_parent().get_node("Spawnpoint")
onready var iTimer = get_node("IFrames")
var inGoal = false
var inIframe = false
var curLevel = 0
var horizDir = 1
var test = 0
var delay = 0

func start() -> void:
	position = Spawnpoint.position
	iTimer.set_wait_time(5)

func playerDeath() -> void:
	if (not inGoal and (not inIframe)):
		var deathPoint = position
		var ZenguinInstance = ZenguinResource.instance()
		get_parent().add_child(ZenguinInstance)
		ZenguinInstance.position = deathPoint
		ZenguinInstance.isInstance = true
		ZenguinInstance._horizontal_direction = horizDir
		position = Spawnpoint.position
		inIframe = true
		iTimer.start()
	else:
		modulate.a = 0.5

func _process(delta: float) -> void:
	
	# General movement
	var _horizontal_direction = (
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	)
	horizDir = _horizontal_direction
	
	if (Input.get_action_strength("Interact") == 1 and not inGoal):
		var goal = get_parent().get_node("Goal")
		if (goal.goalAccessible == true):
			position = Vector2(goal.position.x, goal.position.y - 40)
			animState.travel("Goal")
			inGoal = true
			curLevel += 1
			
	if (not inGoal):
		if (_horizontal_direction != 0):
			sprite.flip_h = bool((_horizontal_direction + 1) / 2)
			if (is_on_wall() and floor_memory > 0):
				animState.travel("Wall Push")
			elif (floor(_velocity.y) == 0):
				animState.travel("Walk")
		elif (floor(_velocity.y) == 0):
			animState.travel("Idle")
		
		if (floor(_velocity.y) < 0 and floor_memory < coyoteDelta * 0.5):
			animState.travel("Jump Off Loop")
		elif (floor(_velocity.y) > 0 and floor_memory < coyoteDelta * 0.5):
			animState.travel("Jump Fall Loop")
		elif (animState.get_current_node() == "Jump Fall Loop" and is_on_floor()):
			animState.travel("Jump Land")
			
			
		#if (collision.collider is TileMap):
		#	var tileId = collision.collider.get_cellv(collision.collider.world_to_map(position) - collision.normal)
	
	_velocity.x = _horizontal_direction * speed + ((get_floor_velocity().x)/10)
	_velocity.y += gravity * delta * int(not is_on_floor())
	
	var is_falling = _velocity.y > 0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	floor_memory = max(coyoteDelta * int(is_on_floor()), floor_memory)
	jump_attempted = Input.is_action_just_pressed("jump") or jump_attempted
	deltaSinceJump = max(0, deltaSinceJump)
	
	# Collision handling
	add_collision_exception_with($CollisionShape2D)
	if (get_slide_count() != 0):
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if (collision.collider is TileMap):
				var tileMap = collision.collider
				if (tileMap.name == "JumpPad"):
					_velocity.y = -1 * tileMap.padPower
				elif (tileMap.name == "KillTiles"):
					playerDeath()
				elif (tileMap.name == "Rope"):
					_velocity.y = Input.get_action_strength("MoveUp") * -climbSpeed + Input.get_action_strength("MoveDown") * climbSpeed
					if (_velocity.y != 0):
						animState.travel("Climb")
					else:
						animState.travel("Climb Idle")
			elif (collision.collider is KinematicBody2D):
				if (collision.collider.name == "MovingPlatform"):
					_velocity.y += abs(get_floor_velocity().y)
			elif (collision.collider.has_method("isConveyor")):
				_velocity.x += collision.collider.convSpeed
	
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
	
	if (not inGoal):
		_velocity = move_and_slide(_velocity, UP_DIRECTION, false)

func win() -> void:
	get_parent().get_node("UI").get_node("UI").get_node("WinLabel").win()

func _on_IFrames_timeout() -> void:
	inIframe = false
	modulate.a = 1
