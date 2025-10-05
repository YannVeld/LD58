extends CharacterBody2D

@export_group("Base settings")
@export var wheel_base = 15
@export var base_steering_angle = 15
@export var tight_steering_angle_bonus = 10
@export var key_holdtime_tight_steering = 2
@export var base_engine_power = 500
@export var braking = -450
@export var max_speed_reverse = 250
@export var min_speed = 25
@export var critical_speed_low = 100
@export var critical_speed_high = 150
@export var traction_fast = 0.0
@export var traction_slow = 0.7
@export var on_collision_backward_velocity = 35

@export_group("Boost settings")
@export var speedBoostTime: float = 5
@export var bonus_engine_power = 350
@export var bonus_steering_angle = 5

@export_group("VFX")
@export var collisionShakeDuration: float = 0.2
@export var collisionShakeMagnitude: float = 3.0
@export var fireParticleSpeed: float = 100
@export var boostPickupShakeDuration: float = 0.2
@export var boostPickupShakeMagnitude: float = 3.0

@export var fakeDriftingMinSpeed: float = 100
@export var fakeDriftingAngle: float = 10
@export var fakeDriftingHoldTime: float = 0.5
@export_range(0,1) var fakeDriftingSmoothing: float = 0.5


@onready var stun_timer: Timer = $stunTimer
@onready var mainCamera = $"../../Camera2D" #Ugly!
@onready var game_manager: Node = $"../../Game manager"
@onready var speedBoostParticleEmitter: GPUParticles2D = $"../../PowerupSpawner/SpeedPickupParticles"
@onready var timeBoostParticleEmitter: GPUParticles2D = $"../../PowerupSpawner/TimePickupParticles"
@onready var carFireParticleEmitter: GPUParticles2D = $"../FireParticleEmitter"
@onready var driftParticleEmitter: GPUParticles2D = $"../DriftParticleEmitter"
@onready var spriteStack: Node2D = $SpriteStack
@onready var spriteStackBaseAngle = spriteStack.get_rotation_degrees()

@onready var spawnPosition = position
@onready var spawnRotation = rotation

var friction = -55/110.0 * 3
var drag = -0.06

var acceleration = Vector2.ZERO
var steer_direction

var stunned = false

var speedupTimer: Timer

# To detect key releases
var _timeSinceSteerPress = 0
var _steer_input = 0

# Changeable car parameters
@onready var _current_engine_power = base_engine_power


func _respawn():
	if Input.is_action_pressed("respawn"):
		acceleration = Vector2.ZERO
		velocity = Vector2.ZERO
		position = spawnPosition
		rotation = spawnRotation


func _get_input(delta: float):
	var turn = Input.get_axis("steer_left", "steer_right")
	if (sign(turn) == sign(_steer_input)) and (abs(turn) > 0.1):
		_timeSinceSteerPress += delta
	else:
		_timeSinceSteerPress = 0
	_steer_input = turn
	
func _calculate_steering_angle() -> float:
	var _frac = _timeSinceSteerPress / key_holdtime_tight_steering
	_frac = clampf(_frac, 0, 1)
	var _angle = lerpf(base_steering_angle, base_steering_angle+tight_steering_angle_bonus, _frac)
		
	if speedupTimer and speedupTimer.time_left > 0:
		_angle += bonus_steering_angle
	
	return _angle
	
func _handle_player_input():
	var _steering_angle = _calculate_steering_angle()
	steer_direction = _steer_input * deg_to_rad(_steering_angle)
	#print(steer_direction)
	
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * _current_engine_power
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

func _get_fake_drift_angle() -> float:
	var _turn = Input.get_axis("steer_left", "steer_right")

	if Input.is_action_pressed("brake"): return spriteStackBaseAngle
	if abs(_turn) < 0.1: return spriteStackBaseAngle
	if velocity.length() < fakeDriftingMinSpeed: return spriteStackBaseAngle

	var _frac = _timeSinceSteerPress / fakeDriftingHoldTime
	_frac = clampf(_frac, 0, 1)
	var _extraAngle = lerpf(0, fakeDriftingAngle, _frac)
	return spriteStackBaseAngle + sign(_turn) * _extraAngle

func _do_fake_drifting() -> void:
	var _targetAngle = _get_fake_drift_angle()
	var _currentAngle = spriteStack.get_rotation_degrees()
	var _newAngle = lerpf( _currentAngle, _targetAngle, fakeDriftingSmoothing )
	spriteStack.set_rotation_degrees(_newAngle)
	

func _physics_process(delta: float) -> void:
	_respawn()
	
	acceleration = Vector2.ZERO
	if not stunned:
		_get_input(delta)
		_handle_player_input()
	apply_friction(delta)
	#print(acceleration)
	velocity += acceleration * delta
	if velocity.length()>0:
		calculate_steering(delta)
	move_and_slide()
	
	_do_fake_drifting()
	#print("velocity = ", velocity.length() )

func handle_collision():
	velocity = -on_collision_backward_velocity*velocity.normalized()
	print("omg! this car just collided with a building" )
	print("Stunned for 2 sec" )
	stunned = true
	stun_timer.start()
	
	mainCamera.shake(collisionShakeDuration, collisionShakeDuration)
	
func handle_mail_pickup():
	print("mail received")

func _on_stun_timer_timeout() -> void:
	print("Unstunned now")
	stunned = false
	
func pickup(type: String, pickup: Node2D):
	print('detected pickup')
	if type=='Extra Time':
		print('extra time' )
		game_manager.add_time()
		
		timeBoostParticleEmitter.global_position = pickup.get_parent().global_position
		timeBoostParticleEmitter.restart()
		
	elif type=='Speed Up':
		print("Speed up activated")
		_current_engine_power = base_engine_power + bonus_engine_power
		speedupTimer = Timer.new()
		add_child(speedupTimer)
		speedupTimer.wait_time = speedBoostTime
		speedupTimer.one_shot= true
		speedupTimer.start()
		speedupTimer.timeout.connect(_on_timer_timeout)
		
		speedBoostParticleEmitter.global_position = pickup.get_parent().global_position
		speedBoostParticleEmitter.restart()
		
		mainCamera.shake(boostPickupShakeDuration, boostPickupShakeMagnitude)
		
	else:
		print("Something is wrong with the powerup")

func _on_timer_timeout() -> void:
	print("Speed up deactivated")
	_current_engine_power = base_engine_power
	# How to delete speedupTimer?


func _handle_fire_particle_emission() -> void:
	if _current_engine_power <= base_engine_power:
		carFireParticleEmitter.set_emitting(false)
		return
	if velocity.length() <= fireParticleSpeed:
		carFireParticleEmitter.set_emitting(false)
		return
	
	carFireParticleEmitter.set_emitting(true)

func _handle_drift_particle_emission() -> void:
	var startEmittingTime = fakeDriftingHoldTime * 3 / 4
	
	if Input.is_action_pressed("brake"): 
		driftParticleEmitter.set_emitting(false)
		return
		
	if _timeSinceSteerPress < startEmittingTime:
		driftParticleEmitter.set_emitting(false)
		return
	
	driftParticleEmitter.set_emitting(true)



func _process(delta: float) -> void:
	_handle_fire_particle_emission()
	_handle_drift_particle_emission()
