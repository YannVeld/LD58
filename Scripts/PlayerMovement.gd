extends CharacterBody2D

@export var MaxSpeed = 200.0
@export var Acc = 1000.0
@export var Frict = 0.2

@export var JumpSpeed = 200.0
@export var Gravity = 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.x = 0
	velocity.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var ax = Input.get_axis("WalkLeft", "WalkRight")
	
	velocity.x += ax * Acc * delta
	velocity.x -= velocity.x * Frict * float(ax == 0)
	velocity.x = clampf(velocity.x, -MaxSpeed, MaxSpeed)
	#if (abs(velocity.x) < Acc * delta):
		#velocity.x = 0.0
	
	if not is_on_floor():
		velocity.y += Gravity * delta
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = -JumpSpeed
	
	#position.x += velocity.x * delta
	move_and_slide()
