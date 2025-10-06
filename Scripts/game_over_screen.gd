extends Control

@onready var score_label: Label = $"./TextBackground/ScoreLabel"

func _ready():
	var _txt = str(Global.score) + " pieces of mail collected"
	score_label.text = _txt
	
	#score_label.text += str(Global.score)

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://StartScreen.tscn")


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMap.tscn")
