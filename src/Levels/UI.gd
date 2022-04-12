extends Control
onready var Pause = get_parent().get_node("Pause")
onready var CreditsPanel = Pause.get_node("CreditsPanel")
var pressMemory = false

func _process(delta: float) -> void:
	if (Input.get_action_strength("Pause") != 0 and pressMemory == false):
		_on_Menu_pressed()
		pressMemory = true
	elif (Input.get_action_strength("Pause") == 0):
		pressMemory =  false

func _on_Menu_pressed() -> void:
	get_tree().paused = !get_tree().paused
	if (Pause.visible == true):
		Pause.hide()
		CreditsPanel.hide()
	else:
		Pause.show()


func _ready() -> void:
	show()


func _on_Resume_pressed() -> void:
	get_tree().paused = false
	Pause.hide()
	CreditsPanel.hide()


func _on_MenuExit_pressed() -> void:
	get_tree().change_scene("res://src/Levels/MainMenu.tscn")


func _on_Credits_pressed() -> void:
	CreditsPanel.show()
