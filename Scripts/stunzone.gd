extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("building ready")
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	print("A building has just been collided with" )
	body.handle_collision()
	pass # Replace with function body.
