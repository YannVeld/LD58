extends Node2D

@export var sprites: Array[Texture2D]
@export var offset: float = 1.0
@export var myScale: Vector2 = Vector2(1,1)
@export var reverseOrder: bool = false
@export var layerCopies: int = 1

var myRenderers: Array[Sprite2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if reverseOrder: sprites.reverse()
	
	myRenderers.resize((sprites.size() * layerCopies))
	for _n in range(sprites.size() * layerCopies):
		var sprite2d = Sprite2D.new()
		add_child(sprite2d)
		
		sprite2d.global_position = global_position
		
		var spriteInd: int = floor( _n / layerCopies )
		sprite2d.texture = sprites[spriteInd]
		sprite2d.position.y -= offset * _n
		sprite2d.scale = myScale
		sprite2d.flip_h = true
	
		myRenderers[_n] = sprite2d
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	for _n in myRenderers.size():
		var sprite2d = myRenderers[_n]
		sprite2d.global_position = global_position
		sprite2d.global_position.y -= offset * _n
		
		sprite2d.scale = myScale
	
	pass
