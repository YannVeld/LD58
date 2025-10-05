extends Sprite2D

@onready var car = %"Car"

@export var min_angle: float = -120
@export var max_angle: float = 120

@export var min_speed_show: float = 0
@export var max_speed_show: float = 100

@export_range(0,1) var rotation_smoothing: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var spd = _get_car_speed()
	var frac = (spd - min_speed_show) / (max_speed_show - min_speed_show)
	frac = clampf(frac, 0, 1)
	
	var wanted_angle = lerpf(min_angle, max_angle, frac)
	var cur_angle = get_rotation_degrees()
	
	var new_angle = lerpf( cur_angle, wanted_angle, rotation_smoothing )
	set_rotation_degrees(new_angle)
	



func _get_car_speed() -> float:
	var carBody: CharacterBody2D = car.get_node("CharacterBody2D")
	var speed = carBody.velocity.length()
	return speed
