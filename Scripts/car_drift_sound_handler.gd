extends AudioStreamPlayer

@onready var carBody: CharacterBody2D = $"../CharacterBody2D"
@onready var standardVolume = get_volume_linear()

@export var driftSoundHoldTime: float = 0.5
@export var volumeChangeSmoothing: float = 0.5
@export var minSpeedForDriftSound: float = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_drifting_sound()
	play()


func _get_target_volume() -> float:
	# If not moving
	if carBody.velocity.length() < minSpeedForDriftSound:
		return 0
	
	# If not holding gas
	if not Input.is_action_pressed("accelerate"):
		return 0
	
	# Set volume when drifting
	var _frac = carBody._timeSinceSteerPress / driftSoundHoldTime
	_frac = clampf(_frac, 0, 1)
	var _target_volume = lerpf(0, standardVolume, _frac)
	return _target_volume

func _drifting_sound() -> void:
	# Smoothly change volume
	var _target_volume = _get_target_volume()
	var _current_volume = get_volume_linear()
	var _new_volume = lerpf( _current_volume, _target_volume, volumeChangeSmoothing )
	set_volume_linear(_new_volume)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_drifting_sound()


func _on_finished() -> void:
	play() # Keep the drifting sound playing
