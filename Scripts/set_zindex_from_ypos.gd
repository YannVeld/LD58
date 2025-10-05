extends Sprite2D


func _process(delta: float) -> void:
	var screenHeight = get_viewport_rect().size.y
	self.z_index = screenHeight/2 + global_position.y
