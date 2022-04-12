extends AnimatedSprite
	
func _process(delta: float) -> void:
	# Keep sun upright
	rotation_degrees = -get_parent().rotation_degrees
