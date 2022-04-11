extends TileMap
onready var Player = get_parent().get_parent().get_node("Player")

func isTileMap() -> bool:
	return true
