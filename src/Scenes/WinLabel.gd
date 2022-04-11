extends TextureRect

onready var LabelTweenNode = $Tween
onready var FadeTweenNode = get_parent().get_node("CanvasLayer/Black/Fade")
onready var WaitTimer = $Delay

func _ready() -> void:
	LabelTweenNode.get_parent().rect_position = Vector2(1200, 268)
	FadeTweenNode.interpolate_property(get_parent().get_node("CanvasLayer/Black"), "modulate", (Color(1,1,1,1)), Color(1,1,1,0), 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_parent().get_node("CanvasLayer").layer = 100
	FadeTweenNode.start()

func win() ->  void:
	LabelTweenNode.interpolate_property(self, "rect_position", Vector2(1200,268), Vector2(448, 268), 5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	LabelTweenNode.start()
	WaitTimer.start()

func _on_Delay_timeout() -> void:
	FadeTweenNode.interpolate_property(get_parent().get_node("CanvasLayer/Black"), "modulate", (Color(1,1,1,0)), Color(1,1,1,1), 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_parent().get_node("CanvasLayer/Black").show()
	get_parent().get_node("CanvasLayer").layer = 100
	FadeTweenNode.start()
	#FadeTweenNode.get_parent()dddddd


func _on_Fade_tween_completed(object: Object, key: NodePath) -> void:
	if (FadeTweenNode.get_parent().modulate.a == 0):
		get_parent().get_node("CanvasLayer").layer = -100
		get_parent().get_node("CanvasLayer/Black").hide()
	else:
		get_parent().get_parent().get_parent().nextLevel()
