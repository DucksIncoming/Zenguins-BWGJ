extends Path2D

export var speed = 100
onready var Platform = get_node("PathFollow2D/MovingPlatform")
onready var Player = get_parent().get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	$PathFollow2D.set_offset($PathFollow2D.get_offset()+(speed * delta))

func resetPlatform() -> void:
	$PathFollow2D.set_offset(0)
