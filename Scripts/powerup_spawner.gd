extends Node2D

@export var timePickupPositionNodes: Array[Node2D]
@export var speedPickupPositionNodes: Array[Node2D]

@onready var new_powerup_timer: Timer = $newPowerupTimer

func _ready():
	activate_powerup()

func activate_powerup():
	var types = ['Extra Time', 'Speed Up']
	types.shuffle()
	if types[0]=='Extra Time':
		if get_node_or_null("../ExtraTime"):
			print("Time already exists!")
			return
		
		print("instantiating extra time now")
		var newScene = load("res://Scenes/ExtraTime.tscn") #reference to the loaded resource
		var newInstance = newScene.instantiate() #creates a new node
		get_parent().add_child.call_deferred((newInstance))
		newInstance.position = timePickupPositionNodes.pick_random().position
		
	if types[0]=='Speed Up':
		if get_node_or_null("../SpeedUp"):
			print("SpeedUp already exists!")
			return
		
		print("instantiating speed up now")
		var newScene = load("res://Scenes/SpeedUp.tscn") #reference to the loaded resource
		var newInstance = newScene.instantiate() #creates a new node
		get_parent().add_child.call_deferred((newInstance))
		newInstance.position = speedPickupPositionNodes.pick_random().position


func _on_new_powerup_timer_timeout() -> void:
	print("Activate!")
	activate_powerup() # Replace with function body.
