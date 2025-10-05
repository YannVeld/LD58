extends Camera2D

@onready var noise = FastNoiseLite.new()
@onready var origOffset = offset

var _shakeTimer : float
var _shakeMagnitude : float
var _roughness : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if _shakeTimer > 0:
		_shakeTimer -= delta
		var newOffset = Vector2(0,0)
		newOffset.x = origOffset.x + _shakeMagnitude * noise.get_noise_2d(10, _shakeTimer*_roughness)
		newOffset.y = origOffset.y + _shakeMagnitude * noise.get_noise_2d(434, _shakeTimer*_roughness)
		set_offset(newOffset)
	elif _shakeTimer < 0:
		_shakeTimer = 0
		set_offset(origOffset)
	

func shake(duration: float=0.5, magnitude: float=5, roughness=5000) -> void:
	_shakeTimer = duration
	_shakeMagnitude = magnitude
	_roughness = roughness


func is_shaking() -> bool:
	return _shakeTimer > 0
