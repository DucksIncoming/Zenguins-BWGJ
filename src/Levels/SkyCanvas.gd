extends CanvasLayer

onready var camNode = get_parent().get_node("Player").get_node("Camera2D")

func _process(delta: float) -> void:
	# Adapt moon and sun size to camera size
	var zoomFactor = camNode.zoomFactor
	set_scale(Vector2((zoomFactor), (zoomFactor)))
