extends Sprite
onready var Invert = get_parent().get_parent()

func _ready():
	show()

func _process(delta: float) -> void:
	#var zoomFactor = (get_parent().get_parent().get_node("Player").get_node("Camera2D").zoom.x) / 0.5
	var zoomFactor = 1
	
	# Rescales the background to fit the screen
	# an unimaginably stupid way to do this but it took me forever bc im stupid so im not changing it
	scale.y = (1 / zoomFactor*2)
	scale.x = (1 / zoomFactor*2)
	position.x = (512 / zoomFactor)
	position.y = (600 / zoomFactor)
	
	# Essentially just to cap the variable, didn't want it getting to like a million if u took too long
