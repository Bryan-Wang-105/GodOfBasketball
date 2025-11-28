extends StaticBody3D

@onready var launch_area: Area3D = $Area3D

@export var launch_speed: float = 20.0  # Adjust for desired launch power
@export var launch_angle: float = 30.0  # Degrees upward

func _ready() -> void:
	launch_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D and body.is_in_group("ball"):
		launch_ball(body)

func launch_ball(ball: RigidBody3D) -> void:
	# Get the ramp's forward direction (-Z in local space)
	var forward = global_transform.basis.z
	
	# Get the ramp's up direction
	var up = global_transform.basis.y
	
	# Calculate launch direction (30 degrees up from forward)
	var angle_rad = deg_to_rad(launch_angle)
	var launch_direction = (forward * cos(angle_rad) + up * sin(angle_rad)).normalized()
	
	# Apply impulse (instantaneous force, better for launchers)
	var impulse = launch_direction * launch_speed
	ball.apply_central_impulse(impulse)
	
	# Optional: Add a bit of spin for realism
	# ball.apply_torque_impulse(Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)))
	
	# Optional: Play sound effect
	# $AudioStreamPlayer3D.play()
