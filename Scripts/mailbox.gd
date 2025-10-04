extends Area2D

var isActive=true
@onready var ready_marker: Sprite2D = $readyMarker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ready_marker.visible = isActive


func _on_body_entered(body: Node2D) -> void:
	print("car got to mailbox")
	if isActive:
		body.handle_mail_pickup()
		isActive = false
