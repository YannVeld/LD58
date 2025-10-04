extends Area2D

@onready var gameManager = %"Game manager"
var isActive=false
@onready var ready_marker: Sprite2D = $readyMarker
@onready var mailboxRenderer: Sprite2D = $mailBoxRenderer
var given_idx : int

@export var activeSprite: Texture2D
@export var deactiveSprite: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var collectionTimer: Timer = $collectionTimer
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ready_marker.visible = isActive
	mailboxRenderer.texture = activeSprite if isActive else deactiveSprite
	
	if isActive:
		var scale = ($collectionTimer.time_left/$collectionTimer.wait_time)
		ready_marker.scale.x = scale
		ready_marker.scale.y = scale

func _on_body_entered(body: Node2D) -> void:
	print("car got to mailbox")
	if isActive:
		body.handle_mail_pickup()
		gameManager.deactivate_mailbox(given_idx)
		#gameManager.score()
		isActive = false
		
func activate(idx):
	given_idx = idx
	isActive = true
	$collectionTimer.start()

func _on_collection_timer_timeout() -> void:
	gameManager.deactivate_mailbox(given_idx)
	isActive=false
