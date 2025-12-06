@icon("res://icon.svg")

class_name WheelchairAvatar extends CharacterBody3D


# Constants
const DEFAULT_ROTATION_AMOUNT: float = PI * 30
const FRICTION: float = .1

# Variables
@onready var model: WheelchairModel = $WheelchairModel

@export var rotation_amount: float = DEFAULT_ROTATION_AMOUNT

var direction: int = 0

# Keyboard input - FOR TESTING ONLY !!!
func keyboard_input(delta) -> void:
	var speed: float = 6.67
	
	if Input.is_action_pressed("wheelchair_left"):
		movement(speed, true, delta)
	elif Input.is_action_pressed("wheelchair_left_rev"):
		movement(-speed, true, delta)
		
	if Input.is_action_pressed("wheelchair_right"):
		movement(speed, false, delta)
	elif Input.is_action_pressed("wheelchair_right_rev"):
		movement(-speed, false, delta)
		
	if Input.is_action_pressed("wheelchair_left2"):
		movement(speed, true, delta)
	elif Input.is_action_pressed("wheelchar_left2_rev"):
		movement(-speed, true, delta)
		
	if Input.is_action_pressed("wheelchair_right2"):
		movement(speed, false, delta)
	elif Input.is_action_pressed("wheelchair_right2_rev"):
		movement(-speed, false, delta)
		
	if (Input.is_action_just_released("wheelchair_left") or Input.is_action_just_released("wheelchair_right") or Input.is_action_just_released("wheelchair_left_rev") or Input.is_action_just_released("wheelchair_right_rev")) and not (Input.is_action_pressed("wheelchair_left") or Input.is_action_pressed("wheelchair_right") or Input.is_action_pressed("wheelchair_left_rev") or Input.is_action_pressed("wheelchair_right_rev")):
		velocity = Vector3.ZERO
		direction = 0

func _physics_process(delta: float) -> void:
	# Testing
	#velocity = global_transform.basis.z * 200 * delta
	#move_and_slide()
	#rotate_around_point(false, delta)
	
	keyboard_input(delta)
	
	move_and_slide()
	if velocity.length_squared() > 0:
		#print(velocity.length())
		only_move(direction * (velocity.length() - FRICTION))
	
# Movement
func movement(speed: float, positive: bool, delta: float) -> void:
	only_move(speed)
	direction = sign(speed)
	#move_and_slide()
	rotate_around_point(positive, sign(speed), delta)

# Only move, no rotation
func only_move(speed: float) -> void:
	velocity = global_transform.basis.z * speed

# Rotate around point
func rotate_around_point(positive: bool, direction_pos: float, delta: float) -> void:
	var mult: float
	var rot_amount_delta: float = rotation_amount * delta
	
	if positive:
		mult = 1
		model.rotate_wheels_const(delta, 0, delta, direction_pos)
	else:
		model.rotate_wheels(delta, delta, 0, direction_pos)
		mult = -1
	
	self.rotate_y(mult * rot_amount_delta * delta)
	
