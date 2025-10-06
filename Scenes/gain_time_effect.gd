extends Sprite2D

@export var nodeToFollow: Node2D
@export var markerOffset: Vector2 = Vector2(0,0)
@onready var animTimer: Timer = $animTimer
@onready var textLabel = $Label

@export var yshift: float = 1.0

var numberToShow = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animTimer.start()
	print(textLabel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var timeLeft = animTimer.time_left
	var timePassed = animTimer.wait_time
	var frac = timeLeft / timePassed
	
	global_position = markerOffset + nodeToFollow.global_position
	global_position.y += yshift * frac
	self_modulate.a = frac
	
	var _col = textLabel["theme_override_colors/font_color"]
	_col.a = frac
	textLabel["theme_override_colors/font_color"] = _col
	textLabel.text = "+"+str(numberToShow)
	
	if frac <= 0:
		queue_free()
