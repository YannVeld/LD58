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

@onready var new_powerup_timer: Timer = $newPowerupTimer

func _process(float) -> void:
	scoreLabel.text = str(score)
	game_time.text = str(int(gameTimer.time_left))

func _ready():
		activate_mailbox()
		activate_powerup()
		
func activate_mailbox():
	if len(inactive_mailboxes)>0:
		var idx = inactive_mailboxes.pick_random()
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
		score += 10
	else:
		score += 5
	print("score = ", score )

func _on_game_timer_timeout() -> void:
	game_over()
	
func add_time():
	gameTimer.start(gameTimer.time_left + 5.0)
	
func activate_powerup():
	var types = ['Extra Time', 'Speed Up']
	types.shuffle()
	if types[0]=='Extra Time':
		print("instantiating extra time now")
		var newScene = load("res://Scenes/ExtraTime.tscn") #reference to the loaded resource
		var newInstance = newScene.instantiate() #creates a new node
		get_parent().add_child.call_deferred((newInstance))
	if types[0]=='Speed Up':
		print("instantiating speed up now")
		var newScene = load("res://Scenes/SpeedUp.tscn") #reference to the loaded resource
		var newInstance = newScene.instantiate() #creates a new node
		get_parent().add_child.call_deferred((newInstance))
	
func game_over():
	Global.score = score
	print("Game over! Your score is ", score)
	get_tree().change_scene_to_file("res://GameOverScreen.tscn")

func _on_new_powerup_timer_timeout() -> void:
	activate_powerup() # Replace with function body.
