@icon("res://icon.svg")

class_name WheelchairAvatar extends CharacterBody3D


# Constants
const DEFAULT_ROTATION_AMOUNT: float = PI * 30

# Variables
@onready var model: WheelchairModel = $WheelchairModel

@export var rotation_amount: float = DEFAULT_ROTATION_AMOUNT

# Testing
func _physics_process(delta: float) -> void:
	velocity = global_transform.basis.z * 200 * delta
	move_and_slide()
	rotate_around_point(false, delta)

# Rotate around point
func rotate_around_point(positive: bool, delta: float) -> void:
	var mult: float
	var rot_amount_delta: float = rotation_amount * delta
	
	if positive:
		mult = 1
		model.rotate_wheels_const(delta, 0, delta)
	else:
		model.rotate_wheels(delta, delta, 0)
		mult = -1
	
	self.rotate_y(mult * rot_amount_delta * delta)
	
