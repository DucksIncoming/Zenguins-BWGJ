extends Node2D

onready var bg = get_node("ParallaxBackground").get_node("Background")
var timeOfDay = "day"
var timeMemory = "day"
var day = 0
onready var RestartButton = get_node("UI").get_node("UI").get_node("Restart")
onready var MenuOpenButton = get_node("UI").get_node("UI").get_node("Menu")
var delay = 0

func _ready() -> void:
	invert("w")
	VisualServer.set_default_clear_color(Color(255, 255, 255, 1))

# Invert the colors when the time of day changes
func invert(color: String) -> void:
	
	if (color == "w"):
		# Change background
		bg.modulate.a = 0.2
		material.set_shader_param("invert", false)
		timeOfDay = "day"
	else:
		# Change background
		if (timeMemory == "day"):
			$Player.playerDeath()
			day += 1
		bg.modulate.a = 0.8
		material.set_shader_param("invert", true)
		timeOfDay = "night"
	timeMemory = timeOfDay

func _process(delta: float) -> void:
	if (RestartButton.pressed and delay > 0.5):
		restartLevel()
		delay = 0
	if (MenuOpenButton.pressed and delay > 0.5):
		openMenu()
		delay = 0
	
	delay += delta

func restartLevel() -> void:
	if (not $Player.inGoal):
		for child in get_children():
			if (child.has_method("deleteZenguin")):
				child.deleteZenguin()
			elif (child.name == "TileMaps"):
				for tileChild in child.get_children():
					if (tileChild.has_method("resetPlatform")):
						tileChild.resetPlatform()
		
		get_node("Player").start()
		get_node("ParallaxBackground").get_node("Sky").start()
		timeOfDay = "day"
		timeMemory = "day"
		day = 0
		
func nextLevel() -> void:
	get_tree().change_scene("res://src/Levels/Level 3.tscn")

func openMenu() -> void:
	pass
