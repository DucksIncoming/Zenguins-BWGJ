extends Camera2D

onready var Player = get_parent()
var dynamic = true

func _process(delta: float) -> void:
	if (dynamic):
		var lookDir = Input.get_action_strength("MoveUp") - Input.get_action_strength("MoveDown")
		if (lookDir > 0):
			position.y = -100
		elif (lookDir < 0):
			position.y = 100
		else:
			position.y = 0
