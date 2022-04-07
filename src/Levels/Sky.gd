extends Node2D
export var rotSpeed := 30
var winSize = OS.get_window_size()

func _process(delta: float) -> void:
	rotation_degrees -= (0.01 * rotSpeed)
	var zoomFactor = (get_parent().get_parent().get_node("Player").get_node("Camera2D").zoom.x) / 0.5
	
	# Rescales the sun/moon to fit the screen
	# an unimaginably stupid way to do this but it took me forever bc im stupid so im not changing it
	scale.y = (1 / zoomFactor*2)
	scale.x = (1 / zoomFactor*2)
	position.x = (512 / zoomFactor)
	position.y = (600 / zoomFactor)
	
	
	# Essentially just to cap the variable, didn't want it getting to like a million if u took too long
	rotation_degrees = fmod(rotation_degrees, 360)
	
	# Invert colors when time of day changes
	if ( abs(fmod(rotation_degrees, 360)) < 180 ):
		Invert.invert("w")
	else:
		Invert.invert("b")
