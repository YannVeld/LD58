extends Node2D

@export var timePickupPositionNode: Node2D
@export var speedPickupPositionNode: Node2D

@onready var new_powerup_timer: Timer = $newPowerupTimer

func _ready():
	activate_powerup()

func activate_powerup():
	var types = ['Extra Time', 'Speed Up']
	types.shuffle()
	if types[0]=='Extra Time':
		print("instantiating extra time now")
		var newScene = load("res://Scenes/ExtraTime.tscn") #reference to the loaded resource
		var newInstance = newScene.instantiate() #creates a new node
		get_parent().add_child.call_deferred((newInstance))
		newInstance.position = timePickupPositionNode.position
		
	if types[0]=='Speed Up':
		print("instantiating speed up now")
		var newScene = load("res://Scenes/SpeedUp.tscn") #reference to the loaded resource
		var newInstance = newScene.instantiate() #creates a new node
		get_parent().add_child.call_deferred((newInstance))
		newInstance.position = speedPickupPositionNode.position


func _on_new_powerup_timer_timeout() -> void:
	print("Activate!")
	activate_powerup() # Replace with function body.
