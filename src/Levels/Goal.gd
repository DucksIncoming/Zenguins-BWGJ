extends Node2D

var goalAccessible = false

func _process(delta: float) -> void:
	var playerPosition = get_parent().get_node("Player").position
	
	if (playerPosition.distance_to(position) < 50):
		show()
		goalAccessible = true
	else:
		hide()
		goalAccessible = false
