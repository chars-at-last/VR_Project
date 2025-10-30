@icon("res://icon.svg")

class_name TestScene extends Node2D


# Constants
const SCREEN_MIDDLE: Vector2 = Vector2(960, 540) / 2

# Variables
@onready var sprite: Sprite2D = $Sprite2D

@export var radius: float = 200
@export var speed: float = TAU / 4

var angle: float = 0

# Process
func _physics_process(delta: float) -> void:
	angle += speed * delta
	
	sprite.position = SCREEN_MIDDLE + radius * Vector2.from_angle(angle).normalized()
