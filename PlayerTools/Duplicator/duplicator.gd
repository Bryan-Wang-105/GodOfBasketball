extends StaticBody3D

@onready var portal_area: Area3D = $Area3D

@export var duplicate_groups: Array[String] = ["ball"]  # Only duplicate these groups
@export var spawn_delay: float = 0.25  # Delay before duplicate spawns
@export var inherit_velocity: bool = true
@export var velocity_multiplier: float = 1.0

var bodies_in_portal: Dictionary = {}  # Track by instance ID

func _ready() -> void:
	portal_area.body_entered.connect(_on_body_entered)
	portal_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if not body is RigidBody3D:
		return
	
	if body.freeze:
		return
	
	# Check if body is in any of the allowed groups
	var in_allowed_group = false
	for group in duplicate_groups:
		if body.is_in_group(group):
			in_allowed_group = true
			break
	
	if not in_allowed_group:
		return
	
	var body_id = body.get_instance_id()
	if not bodies_in_portal.has(body_id):
		bodies_in_portal[body_id] = body
		
		# Capture entry state
		var entry_data = {
			"position": body.global_position,
			"rotation": body.global_rotation,
			"linear_velocity": body.linear_velocity,
			"angular_velocity": body.angular_velocity
		}
		
		# Spawn duplicate after delay
		spawn_duplicate_delayed(body, entry_data)

func _on_body_exited(body: Node3D) -> void:
	var body_id = body.get_instance_id()
	if bodies_in_portal.has(body_id):
		bodies_in_portal.erase(body_id)

func spawn_duplicate_delayed(original: RigidBody3D, entry_data: Dictionary) -> void:
	# Wait for the delay
	await get_tree().create_timer(spawn_delay).timeout
	
	# Check if original still exists
	if not is_instance_valid(original):
		return
	
	var duplicate
	
	# Reuse ball from object pool if we are at limit
	if len(BallManager.ball_arr) == BallManager.ball_limit:
		duplicate = BallManager.get_next_ball()
	# Duplicate the ball that went in
	else:
		duplicate = original.duplicate(DUPLICATE_USE_INSTANTIATION)
		
		get_parent().add_child(duplicate)
	
	# Set to exact entry position and rotation
	duplicate.global_position = entry_data.position
	duplicate.global_rotation = entry_data.rotation
	
	# Copy physics properties
	duplicate.freeze = false
	duplicate.mass = original.mass
	duplicate.physics_material_override = original.physics_material_override
	duplicate.gravity_scale = original.gravity_scale
	duplicate.linear_damp = original.linear_damp
	duplicate.angular_damp = original.angular_damp
	duplicate.continuous_cd = original.continuous_cd
	duplicate.contact_monitor = original.contact_monitor
	duplicate.max_contacts_reported = original.max_contacts_reported
	
	# Set velocity to entry velocity
	if inherit_velocity:
		duplicate.linear_velocity = entry_data.linear_velocity * velocity_multiplier
		duplicate.angular_velocity = entry_data.angular_velocity * velocity_multiplier
	
	#print("Duplicated ", original.name, " at entry point after ", spawn_delay, " seconds")
