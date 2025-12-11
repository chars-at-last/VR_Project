@icon("res://icon.svg")

class_name WheelchairAvatar extends CharacterBody3D


# Constants
const DEFAULT_ROTATION_AMOUNT: float = PI / 2
const FRICTION: float = .1
const ROTATION_FRICTION: float = 2
const BASE_SPEED: float = 6.67

## Variables
@onready var model: WheelchairModel = $WheelchairModel
@onready var right_wheel_pickable_obj: XRToolsPickable = $RightWheelPickableObj
@onready var left_wheel_pickable_obj: XRToolsPickable = $LeftWheelPickableObj

@export var rotation_amount: float = DEFAULT_ROTATION_AMOUNT

@export var keyboard_testing: bool = false
@export var joystick_input_enabled: bool = true

# General variables
var direction: int = 0
var rotation_vel_rad: float
var rotate_left_sign: int = 0
var rotate_right_sign: int = 0
var pre_velocity: float = 0

# VR-specific variables
var right_wheel_hitb_starting_pos: Vector3
var left_wheel_hitb_starting_pos: Vector3
var right_wheel_hitb_prev_pos: Vector3
var left_wheel_hitb_prev_pos: Vector3

# Ready function - you know what it is
func _ready() -> void:
	right_wheel_hitb_starting_pos = right_wheel_pickable_obj.global_position
	left_wheel_hitb_starting_pos = left_wheel_pickable_obj.global_position
	reset_wheel_prev_pos()
	
# Resets the previous positions of the wheels (or just right/left)
func reset_wheel_prev_pos(reset_right: bool = true, reset_left: bool = true) -> void:
	if reset_right:
		right_wheel_hitb_prev_pos = right_wheel_hitb_starting_pos
	
	if reset_left:
		left_wheel_hitb_prev_pos = left_wheel_hitb_starting_pos

# Keyboard input - FOR TESTING ONLY !!!f
func keyboard_input(delta: float) -> void:
	var speed: float = BASE_SPEED
	rotate_left_sign = 0
	rotate_right_sign = 0
	pre_velocity = 0
	
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
		
	if Input.is_action_pressed("wheelchair_moving"):
		only_move(pre_velocity)
		
	if (Input.is_action_just_released("wheelchair_left") or Input.is_action_just_released("wheelchair_right") or Input.is_action_just_released("wheelchair_left_rev") or Input.is_action_just_released("wheelchair_right_rev")) and not (Input.is_action_pressed("wheelchair_left") or Input.is_action_pressed("wheelchair_right") or Input.is_action_pressed("wheelchair_left_rev") or Input.is_action_pressed("wheelchair_right_rev")):
		reset()
		
# Joystick movement
func joystick_input(delta: float) -> void:
	# Variables
	var left_influence: float = Input.get_action_strength("wheelchair_left_stick_up") - Input.get_action_strength("wheelchair_left_stick_down")
	var right_influence: float = Input.get_action_strength("wheelchair_right_stick_up") - Input.get_action_strength("wheelchair_right_stick_down")
	var influence_active: bool
	
	rotate_left_sign = 0
	rotate_right_sign = 0
	pre_velocity = 0
	influence_active = false
	
	#print(left_influence)
	#print(right_influence)
	
	if not is_zero_approx(left_influence):
		movement(left_influence * BASE_SPEED, true, delta, absf(left_influence))
		influence_active = true
		
	if not is_zero_approx(right_influence):
		movement(right_influence * BASE_SPEED, false, delta, absf(right_influence))
		influence_active = true
		
	if influence_active:
		only_move(pre_velocity)
		
# Resets some information
func reset() -> void:
	velocity = Vector3.ZERO
	direction = 0
	rotation_vel_rad = 0

func _physics_process(delta: float) -> void:
	## Testing 1 ##
	#velocity = global_transform.basis.z * 200 * delta
	#move_and_slide()
	#rotate_around_point(false, delta)
	
	## Testing 2 ##
	if keyboard_testing:
		keyboard_input(delta)
		
	if joystick_input_enabled:
		joystick_input(delta)
	
	## Always-running movement funcitons ##
	move_and_slide()
	rotate_around_point(delta)
	if velocity.length_squared() > 0:
		#print(velocity.length())
		only_move(direction * (velocity.length() - FRICTION))
	
# Movement
func movement(speed: float, left_wheel: bool, delta: float, rotate_mult: float = 1) -> void:
	#only_move(speed)
	pre_velocity += speed
	direction = sign(speed)
	if left_wheel:
		rotate_left_sign = direction
	else:
		rotate_right_sign = direction
	
	# Rotation calculation for compound rotations
	rotation_vel_rad = (rotate_left_sign - rotate_right_sign) * DEFAULT_ROTATION_AMOUNT * rotate_mult

# Only move, no rotation
func only_move(speed: float) -> void:
	velocity = global_transform.basis.z * speed

# Rotate around point
func rotate_around_point(delta: float) -> void:
	# Actual rotation
	if not is_zero_approx(rotation_vel_rad):
		self.rotate_y(rotation_vel_rad * delta)
		self.rotation_vel_rad = sign(self.rotation_vel_rad) * maxf(0, absf(self.rotation_vel_rad) - ROTATION_FRICTION * delta)
		
	# Right wheel
	if not is_zero_approx(rotate_right_sign):
		model.rotate_wheels_const(delta, 1, rotate_right_sign, 0)
	
	# Left wheel
	if not is_zero_approx(rotate_left_sign):
		model.rotate_wheels_const(delta, 1, 0, rotate_left_sign)
