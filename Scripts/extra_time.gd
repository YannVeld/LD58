extends Node2D
	

func _on_pickup_body_entered(body: Node2D) -> void:
	queue_free()
	
func _on_countdown_timer_timeout() -> void:
	queue_free() # Replace with function body.
