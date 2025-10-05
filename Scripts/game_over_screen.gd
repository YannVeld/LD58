extends Control

@onready var score_label: Label = $ScoreLabel

func _ready():
	score_label.text += str(Global.score)

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://StartScreen.tscn")
