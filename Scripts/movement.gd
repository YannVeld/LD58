extends CharacterBody2D

@export var wheel_base = 40
@export var steering_angle = 30
@export var engine_power = 9000*1.5
@export var braking = -450
@export var max_speed_reverse = 250
@export var min_speed = 25

var friction = -55*0.1
var drag = -0.06

var acceleration = Vector2.ZERO
var steer_direction

func get_input():
	var turn = Input.get_axis("steer_left", "steer_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
		
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	print("wheel_base = ", (front_wheel - rear_wheel).length())
	print("velocity = ", (velocity).length())

	
	var new_heading = rear_wheel.direction_to(front_wheel)
	var d = new_heading.dot(velocity.normalized())
	if d>0:
		velocity = new_heading * velocity.length()
	elif d<0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)	
	rotation = new_heading.angle()
	
func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < min_speed:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * friction * delta
	acceleration += drag_force + friction_force

func _physics_process(delta: float) -> void:
	acceleration = Vector2.ZERO
	get_input()
	apply_friction(delta)
	velocity += acceleration * delta
	if velocity.length()>0:
		calculate_steering(delta)
	move_and_slide()

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
