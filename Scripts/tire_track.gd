extends Line2D

@onready var body = $"../CharacterBody2D"
@export var pieceLength: float = 16.0
@export var pieceCount: int = 16

@export var piecesOffset: Vector2 = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for _n in range(pieceCount):
		var _pos = body.position
		add_point(_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _prevPiecePos = get_point_position(0)
	var _carPos = body.position + piecesOffset.rotated(body.rotation)
	var _dist = _prevPiecePos.distance_to(_carPos)
	
	if _dist >= pieceLength:
		_extend_track(_carPos)
	
func _extend_track(pos: Vector2) -> void:
	for _n in range(pieceCount,0,-1):
		set_point_position(_n, get_point_position(_n-1))
	
	set_point_position(0, pos)
	
