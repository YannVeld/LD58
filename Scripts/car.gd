extends CharacterBody2D

@export var wheel_base = 15
@export var steering_angle = 20
@export var engine_power = 500
@export var braking = -450
@export var max_speed_reverse = 250
@export var min_speed = 25
@export var critical_speed_low = 100
@export var critical_speed_high = 150
@export var traction_fast = 0.0
@export var traction_slow = 0.7
@export var on_collision_backward_velocity = 35

@onready var stun_timer: Timer = $stunTimer

var friction = -55/110.0 * 3
var drag = -0.06

var acceleration = Vector2.ZERO
var steer_direction

var stunned = false

func get_input():
	var turn = Input.get_axis("steer_left", "steer_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	#print(steer_direction)
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
	if velocity.length()>critical_speed_high:
		traction = traction_fast
	elif velocity.length()>critical_speed_low:
		traction = traction_slow + (traction_fast-traction_slow)*(velocity.length() - critical_speed_low)/(critical_speed_high - critical_speed_low)

	rotation = new_heading.angle()
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp(new_heading*velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

func _physics_process(delta: float) -> void:
		acceleration = Vector2.ZERO
		if not stunned:
			get_input()
		apply_friction(delta)
		#print(acceleration)
		velocity += acceleration * delta
		if velocity.length()>0:
			calculate_steering(delta)
		move_and_slide()
		#print("velocity = ", velocity.length() )

func handle_collision():
	velocity = -on_collision_backward_velocity*velocity.normalized()
	print("omg! this car just collided with a building" )
	print("Stunned for 2 sec" )
	stunned = true
	stun_timer.start()
	
func handle_mail_pickup():
	print("mail received")

func _on_stun_timer_timeout() -> void:
	print("Unstunned now")
	stunned = false
