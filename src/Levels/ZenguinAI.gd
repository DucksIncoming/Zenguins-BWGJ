extends KinematicBody2D

var _velocity = Vector2.ZERO
export var baseSpeed = 50
export var targetingRatio = 1.5
export var decayPeriod = 5
export var jumpPower = 300
export var pushSpeed = 1000
var speed = baseSpeed
var _horizontal_direction = 1
onready var sprite = get_node("Sprite")
onready var Player = get_parent().get_node("Player")
onready var FloorRaycast = get_node("FloorRaycast")
onready var HorizontalRaycast = get_node("HorizontalRaycast")
onready var HeadRaycast = get_node("HeadRaycast")
var delay = 0
onready var animTree = $AnimationTree
onready var animPlayer = $AnimationPlayer
onready var animState = animTree.get("parameters/playback")
onready var particles = $CPUParticles2D
var timeOfDay = "day"
onready var LivingCollision = $LivingCollision
onready var DeadCollision = $DeadCollision
onready var startingPosition = position
var isInstance = false
var dead = false
var deathDate
var posMemory = Vector2.ZERO
var posDelay = 0
var jumpMemory = Vector2.ZERO

func deleteZenguin() -> void:
	if (isInstance):
		queue_free()
	else:
		dead = false
		name = "Zenguin"
		position = startingPosition

func _process(delta: float):
	if (not dead):
		LivingCollision.disabled = false
		DeadCollision.disabled = true
		
		timeOfDay = get_parent().timeOfDay
		
		if (timeOfDay == "night"):
			_velocity.x = speed * _horizontal_direction + (get_floor_velocity().x/8)
			particles.emitting = true
			if ((abs(position.x - posMemory.x) - 1 < 0.5) and posDelay > 0.4 and _horizontal_direction != 0 and _velocity.y == 0):
				if (not (abs(jumpMemory.x - position.x) < 5)):
					_velocity.y = -jumpPower
					jumpMemory = position
				else:
					_horizontal_direction = -_horizontal_direction
				
			# Collision handling
			add_collision_exception_with($CollisionShape2D)
			if (get_slide_count() != 0):
				for i in get_slide_count():
					var collision = get_slide_collision(i)
					if (collision.collider is TileMap):
						var tileMap = collision.collider
						if (tileMap.name == "JumpPad"):
							_velocity.y = -1 * tileMap.padPower
					elif (collision.collider is KinematicBody2D):
						if (collision.collider.name == "MovingPlatform"):
							_velocity.y += abs(get_floor_velocity().y)
		else:
			_velocity.x =  (get_floor_velocity().x/8)
			particles.emitting = false
			animState.travel("Frozen")
		
		if (_velocity.x != 0):
			if (timeOfDay == "night"):
				animState.travel("Walk")
		else:
			if (timeOfDay == "night"):
				animState.travel("Idle")
		
		if (_horizontal_direction != 0):
			sprite.flip_h = bool((_horizontal_direction + 1) / 2)
			FloorRaycast.position.x = 23.0 * _horizontal_direction
			HorizontalRaycast.set_cast_to(Vector2(300 * _horizontal_direction, 0))
		
		if ((not FloorRaycast.is_colliding() and delay > 0.5)):
			delay = 0
			_horizontal_direction = -_horizontal_direction
		
		if (HorizontalRaycast.is_colliding()):
			# print(HorizontalRaycast.get_collider().name)
			
			if (HorizontalRaycast.get_collider() != null):
				if (HorizontalRaycast.get_collider().name == "Player"):
					var playerMemory = true
					speed = baseSpeed * targetingRatio
					
			else:
				speed = baseSpeed
				#print(abs(HorizontalRaycast.get_collision_point().x - position.x))
				if (HorizontalRaycast.get_collider() != null):
					if ((HorizontalRaycast.get_collider().name == "TileMap") and (abs(HorizontalRaycast.get_collision_point().x - position.x) < 15)):
						if (delay > 0.3):
							_horizontal_direction = -_horizontal_direction
							delay = 0
						pass
		else:
			speed = baseSpeed
		
		delay += delta
		posDelay += delta
		
		if (HeadRaycast.is_colliding()):
			if (HeadRaycast.get_collider().name == "Player" and timeOfDay == "night"):
				dead = true
				animState.travel("Dead")
				particles.emitting = false
				LivingCollision.disabled = true
				DeadCollision.disabled = false
				name = "DeadZenguin"
				deathDate = get_parent().day
				HeadRaycast.get_collider()._velocity.y = -0.5 * HeadRaycast.get_collider().jumpPower
	else:
		_velocity.x = 0
		if ((get_parent().day - deathDate) >= decayPeriod - 1):
			queue_free()
			
	_velocity.y += Player.gravity * delta * int(not is_on_floor())
	_velocity = move_and_slide(_velocity)
	if (posDelay > 1):
		posMemory = position
		posDelay = 0
