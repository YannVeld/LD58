extends Node

@onready var mailboxes = $"../Mailboxes"
@onready var num_mailboxes = mailboxes.get_child_count()
@onready var inactive_mailboxes = range(num_mailboxes)
@onready var active_mailboxes = Array([])
@onready var score: int = 0

@onready var newColectionTimer = $newCollectionTimer
@onready var gameTimer = $gameTimer
@onready var scoreLabel: Label = $"../UI Overlay/Score"
@onready var game_time: Label = $"../UI Overlay/GameTime"

@export var scoreThreshold = 2

@onready var car = %"Car"
@onready var carBody = car.get_node("CharacterBody2D")
@onready var letterEffectScene = preload("res://Scenes/gain_letter_effect.tscn")

@export var minimalDistToCarForMailboxActivation: float = 0.0


func _process(float) -> void:
	scoreLabel.text = str(score)
	game_time.text = str(int(gameTimer.time_left) + 1)

func _ready():
		activate_mailbox()
		
func activate_mailbox():
	if len(inactive_mailboxes)>0:
		var idx
		var _distToCar = 0.0
		var _iter = 0
		
		# Find a postbox that is far enough away from car
		while _distToCar < minimalDistToCarForMailboxActivation:
			idx = inactive_mailboxes.pick_random()
			var _boxPos = mailboxes.get_child(idx).global_position
			_distToCar = _boxPos.distance_to(carBody.global_position)
			
			_iter += 1
			if _iter > 100:
				print("WARNING: Could not find a postbox that is far away from car!")
				break
		
		inactive_mailboxes.erase(idx)
		active_mailboxes.append(idx)
		
		mailboxes.get_child(idx).activate(idx)
		
func deactivate_mailbox(idx):
	active_mailboxes.erase(idx)
	inactive_mailboxes.append(idx)

func _on_new_collection_timer_timeout() -> void:
	activate_mailbox()
	
func score_collection(timeLeft):
	if timeLeft>scoreThreshold:
		score += 2
	else:
		score += 1
	pickup_effect()
	#print("score = ", score )

func _on_game_timer_timeout() -> void:
	game_over()
	
func add_time():
	gameTimer.start(gameTimer.time_left + 5.0)
	
func game_over():
	Global.score = score
	#print("Game over! Your score is ", score)
	get_tree().change_scene_to_file("res://GameOverScreen.tscn")

func pickup_effect():
	var _scene = letterEffectScene.instantiate()
	car.add_child(_scene)
	_scene.nodeToFollow = car.get_node("CharacterBody2D")
