extends CharacterBody2D

@export var wheel_base = 15
@export var steering_angle = 10
@export var engine_power = 500
@export var braking = -450
@export var max_speed_reverse = 250
@export var min_speed = 25
@export var drift_threshold_speed = 100
@export var traction_fast = 0.0
@export var traction_slow = 0.7

var friction = -55/110.0
var drag = -0.06

var acceleration = Vector2.ZERO
var steer_direction

func get_input():
	var turn = Input.get_axis("steer_left", "steer_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	print(steer_direction)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
		
func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < min_speed:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * friction * delta
	acceleration += drag_force + friction_force
		
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
		
	rear_wheel += velocity*delta
	front_wheel += velocity.rotated(steer_direction)*delta
	var new_heading = rear_wheel.direction_to(front_wheel)
	
	var traction = traction_slow
	if velocity.length() > drift_threshold_speed:
		traction = traction_fast
		print("drifting")

	velocity = velocity.lerp(new_heading*velocity.length(), traction)
	rotation = new_heading.angle()
	
	var d = new_heading.dot(velocity.normalized())
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

func _physics_process(delta: float) -> void:
	acceleration = Vector2.ZERO
	get_input()
	apply_friction(delta)
	print(acceleration)
	velocity += acceleration * delta
	if velocity.length()>0:
		calculate_steering(delta)
	move_and_slide()
	print("velocity = ", velocity.length() )
