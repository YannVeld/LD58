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

func _process(float) -> void:
	scoreLabel.text = 'Score: ' + str(score)
	game_time.text = 'Time left: ' + str(int(gameTimer.time_left))

func _ready():
		activate_mailbox()
		
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
	
func game_over():
	print("Game over! Your score is ", score)
