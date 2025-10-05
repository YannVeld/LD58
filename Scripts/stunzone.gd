extends Area2D


# Called when the node enters the scene tree for the first time

func _on_body_entered(body: Node2D) -> void:
	#print("Something has just been collided with" )
	
	body.handle_collision(self)
	pass # Replace with function body.
