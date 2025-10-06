extends AudioStreamPlayer

@onready var carBody: CharacterBody2D = $"../CharacterBody2D"
@onready var stopSoundPlayer: AudioStreamPlayer = $"./EngineStopSoundPlayer"
@onready var startSoundPlayer: AudioStreamPlayer = $"./EngineStartSoundPlayer"

@export var pitchScaleWithBoost: float = 0.8
@onready var normalPitch = get_pitch_scale()

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
	set_pitch_scale(normalPitch)
	stopSoundPlayer.set_pitch_scale(normalPitch)
	startSoundPlayer.set_pitch_scale(normalPitch)
	
	if not carBody.speedupTimer:
		return
	if carBody.speedupTimer.time_left > 0:
		set_pitch_scale(pitchScaleWithBoost)
		stopSoundPlayer.set_pitch_scale(pitchScaleWithBoost)
		startSoundPlayer.set_pitch_scale(pitchScaleWithBoost)
	

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
