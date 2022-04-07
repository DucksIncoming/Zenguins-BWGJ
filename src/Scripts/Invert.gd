extends Node

var col
var playerParticles

func _ready() -> void:
	invert("w")
	var playerParticles = get_node("Player/ParticleEmitter")

# Invert the colors when the time of day changes
func invert(color: String) -> void:
	if (color == "w"):
		VisualServer.set_default_clear_color(Color(255, 255, 255))
	else:
		VisualServer.set_default_clear_color(Color(0, 0, 0))
