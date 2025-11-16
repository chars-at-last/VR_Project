@tool
class_name XRToolsWheelPickable
extends XRToolsPickable

@export var max_roll_speed : float = 3.0
@export var allow_rolling : bool = true

var original_y_position : float

func _ready():
	super._ready()
	original_y_position = global_position.y

func pick_up(by: Node3D):
	if can_pick_up(by):
		original_y_position = global_position.y
		super.pick_up(by)

func _physics_process(delta):
	if is_picked_up() and allow_rolling:
		# Only constrain Y position to prevent falling through floor
		# but allow X and Z movement for rolling
		var current_pos = global_position
		current_pos.y = original_y_position
		global_position = current_pos
		
		# Limit maximum speed
		if linear_velocity.length() > max_roll_speed:
			linear_velocity = linear_velocity.normalized() * max_roll_speed

func let_go(by: Node3D, linear_vel: Vector3, angular_vel: Vector3):
	# Allow natural rolling physics when released
	super.let_go(by, linear_vel, angular_vel)
