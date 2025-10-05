extends Node2D

@export var puffCount: int = 0
@export var puffSprites: Array[Texture2D]

@export var roadTileMapLayer: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var screenSize = get_viewport_rect().size
	
	for _i in range(puffCount):
		var sprite2d = Sprite2D.new()
		add_child(sprite2d)
		sprite2d.texture = puffSprites.pick_random()

		# Avoid spawning on the road
		var cell = 0
		while not (cell == null):
			var pos = Vector2(rng.randi_range(-screenSize.x/2,screenSize.x/2), rng.randi_range(-screenSize.y/2,screenSize.y/2))
			sprite2d.global_position = pos

			var posRelToTilemap = roadTileMapLayer.to_local(pos)
			var cellCoords = roadTileMapLayer.local_to_map(posRelToTilemap)
			cell = roadTileMapLayer.get_cell_tile_data(cellCoords)
		
