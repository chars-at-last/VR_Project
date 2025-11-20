@icon("res://icon.svg")

class_name WheelchairAvatar extends CharacterBody3D


# Constants
const DEFAULT_ROTATION_AMOUNT: float = PI

# Variables
@onready var model: WheelchairModel = $WheelchairModel

@export var rotation_amount: float = DEFAULT_ROTATION_AMOUNT

# Testing
func _physics_process(delta: float) -> void:
	velocity = global_transform.basis.z * 400 * delta
	move_and_slide()
	rotate_around_point(true, delta)
	rotate_around_point(false, delta)

# Rotate around point
func rotate_around_point(positive: bool, delta: float) -> void:
	self.rotate_y((1 if positive else -1) * rotation_amount * delta)
	
