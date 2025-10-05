extends Area2D

@export var type = 'Extra Time'

func _on_body_entered(body: Node2D) -> void:
	body.pickup(type, self)
	
	
