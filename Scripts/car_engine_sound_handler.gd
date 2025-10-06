extends AudioStreamPlayer

@onready var carBody: CharacterBody2D = $"../CharacterBody2D"
@onready var stopSoundPlayer: AudioStreamPlayer = $"./EngineStopSoundPlayer"
@onready var startSoundPlayer: AudioStreamPlayer = $"./EngineStartSoundPlayer"

@export var pitchScaleWithBoost: float = 0.8
@onready var normalPitch = get_pitch_scale()

@export var pitchScaleChangeInTurn: float = -0.02
@export var pitchTurnHoldtime: float = 0.5
@export_range(0,1) var pitchChangeSmoothing: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _start_playing() -> void:
	if (not is_playing()) and (not startSoundPlayer.is_playing()):
		startSoundPlayer.play(0)

func _stop_playing() -> void:
	if is_playing():
		stopSoundPlayer.play()
	
	set_playing(false)
	startSoundPlayer.set_playing(false)

func _set_pitch() -> void:
	var _target_pitch = normalPitch

	# Change pitch on speed boost
	if carBody.speedupTimer and (carBody.speedupTimer.time_left > 0):
		_target_pitch = pitchScaleWithBoost
	
	# Change pitch on steering
	var _frac = carBody._timeSinceSteerPress / pitchTurnHoldtime
	_frac = clampf(_frac, 0, 1)
	var _pitch_change = lerpf(0, pitchScaleChangeInTurn, _frac)
	_target_pitch += _pitch_change
	
	# Smoothly change pitch
	var _current_pitch = get_pitch_scale()
	var _new_pitch = lerpf( _current_pitch, _target_pitch, pitchChangeSmoothing )
	
	# Set new pitch
	set_pitch_scale(_new_pitch)
	stopSoundPlayer.set_pitch_scale(_new_pitch)
	startSoundPlayer.set_pitch_scale(_new_pitch)
	

func _process(delta: float) -> void:
	_set_pitch()
	
	if (not Input.is_action_pressed("accelerate")) and (not Input.is_action_pressed("brake")):
		_stop_playing() 
		return
	
	if (Input.is_action_just_pressed("accelerate") or Input.is_action_just_pressed("brake")):
		_start_playing()
	

func _on_engine_start_sound_player_finished() -> void:
	set_playing(true)


func _on_finished() -> void:
	set_playing(true)
