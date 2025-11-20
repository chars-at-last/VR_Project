@icon("res://icon.svg")

class_name WheelchairModel extends Node3D


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
func rotate_wheels(amount_rad_front: float, amount_rad_back_left: float, amount_rad_back_right: float) -> void:
	front_wheels.rotate_x(amount_rad_front)
	back_wheel_left.rotate_x(amount_rad_back_left)
	back_wheel_right.rotate_x(amount_rad_back_right)

# Rotate all by same amount
func rotate_wheels_same(amount_rad: float) -> void:
	return rotate_wheels(amount_rad, amount_rad, amount_rad)
