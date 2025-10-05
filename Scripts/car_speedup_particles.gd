extends GPUParticles2D

@onready var body: CharacterBody2D = $"../CharacterBody2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = Vector3(0,0,0)
	pos.x = body.position.x
	pos.y = body.position.y
	process_material.set_emission_shape_offset(pos)
