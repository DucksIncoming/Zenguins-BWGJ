extends Button

var isHover = false

func _process(delta: float) -> void:
	if (isHover):
		modulate.a = 0.7
	else:
		modulate.a = 0.3

func _on_Menu_mouse_entered() -> void:
	isHover = true

func _on_Menu_mouse_exited() -> void:
	isHover = false


func _on_Menu_pressed() -> void:
	pass # Replace with function body.
