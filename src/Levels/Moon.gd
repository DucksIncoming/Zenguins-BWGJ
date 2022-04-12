extends AnimatedSprite
	
func _process(delta: float) -> void:
	# Keep moon upright
	rotation_degrees = -get_parent().rotation_degrees
