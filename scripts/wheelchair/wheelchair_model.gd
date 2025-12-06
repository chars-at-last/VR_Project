@icon("res://icon.svg")

class_name WheelchairModel extends Node3D


# Constants
const MODEL_WHEEL_ROTATION_DEFAULT: float = PI / 2

# Variables
@onready var chair: Node3D = $Chair
@onready var back_wheels: Node3D = $BackWheels
@onready var front_wheels: Node3D = $FrontWheels

@onready var back_wheel_left: Node3D = $BackWheels/BackWheelLeft
@onready var back_wheel_right: Node3D = $BackWheels/BackWheelRight

# Testing
#func _physics_process(delta: float) -> void:
	#var value := PI / 2 * delta
	#rotate_wheels(value, 2 * value, value)

# Rotate wheels, choose whether to rotate left / right back wheels or nah
func rotate_wheels(amount_rad_front: float, amount_rad_back_left: float, amount_rad_back_right: float, mult: float = 1) -> void:
	front_wheels.rotate_x(amount_rad_front * mult)
	back_wheel_left.rotate_x(amount_rad_back_left * mult)
	back_wheel_right.rotate_x(amount_rad_back_right * mult)

# Rotate all by same amount
func rotate_wheels_same(amount_rad: float, mult: float = 1) -> void:
	return rotate_wheels(amount_rad, amount_rad, amount_rad, mult)

# Rotate wheels using constant
func rotate_wheels_const(mult: float = 1, mult_front: float = 1, mult_back_left: float = 1, mult_back_right: float = 1) -> void:
	rotate_wheels(MODEL_WHEEL_ROTATION_DEFAULT * mult_front, MODEL_WHEEL_ROTATION_DEFAULT * mult_back_left, MODEL_WHEEL_ROTATION_DEFAULT * mult_back_right, mult)
