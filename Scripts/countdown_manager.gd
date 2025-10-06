extends Label

@onready var gameManager = %"Game manager"
@onready var gameTimer: Timer = gameManager.get_node("gameTimer")
@onready var countdownSoundPlayer: AudioStreamPlayer = $"./CountdownSoundPlayer"

@export var numberAppearTime: float = 0.9
@export var startCountingTime: int = 3

var _prevNum: int = 0

func _set_text(frac: float) -> void:
	var _col = self["theme_override_colors/font_color"]
	_col.a = frac
	self["theme_override_colors/font_color"] = _col
	text = str( int( floor(gameTimer.time_left) ) + 1 )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (gameTimer.time_left > startCountingTime) or (gameTimer.time_left <= 0):
		_set_text(0)
		return
	
	var _timeDiff = gameTimer.time_left - floor(gameTimer.time_left)
	var _frac = _timeDiff / numberAppearTime
	_frac = clampf(_frac, 0, 1)
	_set_text(_frac)
	
	# Play countdown sound
	var _curNum = int( floor(gameTimer.time_left) ) + 1
	if _prevNum != _curNum:
		countdownSoundPlayer.play()
	
	_prevNum = _curNum
	
	
	
	
	
