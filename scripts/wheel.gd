extends StaticBody3D

#Maximum rotation and rotation speed
@export var max_rotation_degrees := 360.0
@export var rotation_speed := 2.0

var grabbed := false
var grab_hand: XRController3D = null
var initial_grab_angle := 0.0
var initial_wheel_angle := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_ray_pickable = true
	#pass # Replace with function body.

#Return rotation angle
func get_current_rotation_angle() -> float:
	return rotation.y

#Called when the player grabs the wheel
func _on_grab(hand: XRController3D):
	if not grabbed:
		grabbed = true
		grab_hand = hand

	# Calculate initial angles
	var hand_pos = global_transform.origin
	var wheel_pos = global_transform.origin
	var to_hand = hand_pos - wheel_pos
	var local_to_hand = global_transform.basis.inverse() * to_hand

	initial_grab_angle = atan2(local_to_hand.z, local_to_hand.x)
	initial_wheel_angle = get_current_rotation_angle()

#Called when player release the wheel
func _on_release(hand: XRController3D):
	if grabbed and grab_hand == hand:
		grabbed = false
		grab_hand = null

#Called when wheel is being rotated by player
func update_wheel_rotation():
	var hand_pos = grab_hand.global_transform.origin
	var wheel_pos = global_transform.origin
	var to_hand = hand_pos - wheel_pos
	var local_to_hand = global_transform.basis.inverse() * to_hand
	var current_grab_angle = atan2(local_to_hand.z, local_to_hand.x)
	var angle_difference = current_grab_angle - initial_grab_angle
	
	var target_angle = initial_wheel_angle + angle_difference * rotation_speed
	target_angle = clamp(target_angle, -deg_to_rad(max_rotation_degrees), deg_to_rad(max_rotation_degrees))
	
	rotation.y = target_angle
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pass
	if grabbed and grab_hand:
		update_wheel_rotation()
