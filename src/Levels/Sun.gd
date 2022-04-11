extends AnimatedSprite

var rotSpeed
var winSize

func _ready() -> void:
	rotation_degrees = 0

func _process(delta: float) -> void:
	rotSpeed = get_parent().currentSpeed
	rotation_degrees += (0.01 * rotSpeed)
