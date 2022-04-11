extends TileMap

onready var Player = get_parent().get_parent().get_node("Player")
onready var posMemory = Player.position
onready var velMemory = Player._velocity
var delay = 0
	
func _process(delta: float) -> void:
	if (Player._velocity.y <= 0):
		set_collision_mask_bit(0, false)
		set_collision_layer_bit(0, false)
	else:
		if (posMemory.y == Player.position.y and velMemory.y < Player._velocity.y):
			set_collision_mask_bit(0, false)
			set_collision_layer_bit(0, false)
		else:
			set_collision_mask_bit(0, true)
			set_collision_layer_bit(0, true)
	
	posMemory = Player.position
	velMemory = Player._velocity
