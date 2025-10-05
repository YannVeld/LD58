extends Node2D
	
@onready var countdownTimer: Timer = $"./CountdownTimer"
@onready var car = $"../Car/CharacterBody2D"

@export var dontDespawnDistance: float

func _on_pickup_body_entered(body: Node2D) -> void:
	queue_free()
	
func _on_countdown_timer_timeout() -> void:
	var distToCar = position.distance_to(car.position)
	
	if distToCar <= dontDespawnDistance:
		countdownTimer.set_wait_time(1) # Wait for the player to leave
	else:
		queue_free()
