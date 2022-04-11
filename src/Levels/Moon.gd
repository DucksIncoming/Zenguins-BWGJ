extends AnimatedSprite

var rotSpeed

func _ready() -> void:
	rotation_degrees = 0

func _process(delta: float) -> void:
	# Keep moon upright
	rotSpeed = get_parent().currentSpeed	
	rotation_degrees += (0.01 * rotSpeed)
