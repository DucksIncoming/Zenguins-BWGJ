extends Node2D

func _ready() -> void:
	invert("w")

# Invert the colors when the time of day changes
func invert(color: String) -> void:
	
	if (color == "w"):
		# Change background
		VisualServer.set_default_clear_color(Color(255, 255, 255))
		material.set_shader_param("invert", false)
	else:
		# Change background
		VisualServer.set_default_clear_color(Color(0, 0, 0))
		material.set_shader_param("invert", true)
