extends Node2D
export var daySpeed := 30
export var nightSpeed := 30
export var startRot := -90
onready var Invert = get_parent().get_parent()
var timeOfDay = "day"
var currentSpeed = daySpeed

func start() -> void:
	timeOfDay = "day"
	rotation_degrees = startRot
	get_node("Sun").rotation_degrees = 0
	get_node("Moon").rotation_degrees = 0

func _process(delta: float) -> void:
	timeOfDay = get_parent().get_parent().timeOfDay
	
	if (timeOfDay == "day"):
		rotation_degrees -= (0.01 * daySpeed)
		currentSpeed = daySpeed
	else:
		rotation_degrees -= (0.01 * nightSpeed)
		currentSpeed = nightSpeed
	# Essentially just to cap the variable, didn't want it getting to like a million if u took too long
	rotation_degrees = fmod(rotation_degrees, 360)
	
	# Invert colors when time of day changes
	if ( abs(fmod(rotation_degrees, 360)) < 180 ):
		Invert.invert("w")
	else:
		Invert.invert("b")
