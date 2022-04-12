extends Node

onready var track1 = $BackgroundTrack1 
onready var track2 = $BackgroundTrack2

func _ready() -> void:
	track1.play()


func _on_BackgroundTrack1_finished() -> void:
	track1.play()
