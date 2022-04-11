extends Button
var isHover = false

func _process(delta: float) -> void:
	if (isHover):
		modulate.a = 0.7
	else:
		modulate.a = 0.3

func _on_Die_mouse_entered() -> void:
	isHover = true
	
func _on_Die_mouse_exited() -> void:
	isHover = false
