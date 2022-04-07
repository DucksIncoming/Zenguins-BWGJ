extends Camera2D

export var zoomFactor := 1.0
var winSize = OS.get_window_size()

func _process(delta: float) -> void:
	# Adapt the camera size to the window size so everything stays the same.
	# I refuse to find a better way to do this
	winSize = OS.get_window_size()
	zoom.y = (600 / winSize.y) * (1 / zoomFactor)
	zoom.x = (600 / winSize.y) * (1 / zoomFactor)
