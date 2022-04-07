extends AnimatedSprite

var rotSpeed
var winSize

func _ready() -> void:
	rotSpeed = get_parent().rotSpeed	

func _process(delta: float) -> void:
	rotation_degrees += (0.01 * rotSpeed)
