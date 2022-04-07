extends AnimatedSprite

var rotSpeed

func _ready() -> void:
	rotSpeed = get_parent().rotSpeed	

func _process(delta: float) -> void:
	# Keep moon upright
	rotation_degrees += (0.01 * rotSpeed)
