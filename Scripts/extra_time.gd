extends Node2D

func _on_pickup_body_entered(body: Node2D) -> void:
	queue_free()
