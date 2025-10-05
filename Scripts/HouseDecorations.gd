extends Node2D

@onready var chimney: Sprite2D = $"./Chimney"
@onready var flowerbox: Sprite2D = $"./Flowerbox"
@onready var roofExtension: Sprite2D = $"./RoofExtension"
@onready var roofWindow: Sprite2D = $"./RoofWindow"
@onready var window: Sprite2D = $"./Window"
@onready var windowFlower: Sprite2D = $"./WindowFlowers"
@onready var windowRoof: Sprite2D = $"./WindowRoof"

@export_range(0,1) var chimneyChance: float = 0.5
@export_range(0,1) var flowerBoxChance: float = 0.5

@export_range(0,1) var roofExtensionChance: float = 0.5
@export_range(0,1) var roofWindowChance: float = 0.5


@export_range(0,1) var windowChance: float = 0.5
@export_range(0,1) var windowFlowerChance: float = 0.5
@export_range(0,1) var windowRoofChance: float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()

	chimney.set_visible(false)
	flowerbox.set_visible(false)
	roofExtension.set_visible(false)
	roofWindow.set_visible(false)
	window.set_visible(false)
	windowFlower.set_visible(false)
	windowRoof.set_visible(false)


	if rng.randf() < chimneyChance:
		chimney.set_visible(true)
	
	if rng.randf() < flowerBoxChance:
		flowerbox.set_visible(true)
	
	var _roofNumber = rng.randf()
	if _roofNumber < roofExtensionChance:
		roofExtension.set_visible(true)
	elif _roofNumber < (roofExtensionChance + roofWindowChance):
		roofWindow.set_visible(true)
		
	
	if rng.randf() < windowChance:
		window.set_visible(true)
		
		if rng.randf() < windowFlowerChance:
			windowFlower.set_visible(true)
			
		if rng.randf() < windowRoofChance:
			windowRoof.set_visible(true)
	
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
