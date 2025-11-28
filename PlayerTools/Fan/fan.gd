extends StaticBody3D

@export_group("Fan Properties")
## Maximum upward force applied by the fan
@export var max_force: float = 50.0
## How quickly the force ramps up (lower = slower acceleration)
@export var acceleration_rate: float = 6.0

## Add some turbulence for realism
@export var turbulence_strength: float = 2.0
# Track objects currently in the fan's influence
var affected_bodies: Dictionary = {} # RigidBody3D -> current_force_multiplier

@onready var detection_area: Area3D = $Area3D


func _ready() -> void:
	if not detection_area:
		push_error("VerticalFan: No Area3D assigned to detection_area!")
		return
	
	# Connect area signals
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	# Apply forces to all affected bodies
	for body in affected_bodies.keys():
		if not is_instance_valid(body):
			affected_bodies.erase(body)
			continue
		
		# Gradually increase force multiplier (acceleration effect)
		var current_multiplier: float = affected_bodies[body]
		current_multiplier = move_toward(current_multiplier, 1.0, acceleration_rate * delta)
		affected_bodies[body] = current_multiplier
		
		# Calculate upward force
		var upward_force = Vector3.UP * max_force * current_multiplier
		
		# Add some horizontal turbulence for realism
		if turbulence_strength > 0:
			var turbulence = Vector3(
				randf_range(-1.0, 1.0),
				0,
				randf_range(-1.0, 1.0)
			) * turbulence_strength * current_multiplier
			upward_force += turbulence
		
		# Apply the force
		body.apply_central_force(upward_force)
		
		# Optional: Dampen horizontal velocity slightly to keep objects centered
		var horizontal_velocity = Vector3(body.linear_velocity.x, 0, body.linear_velocity.z)
		if horizontal_velocity.length() > 0:
			body.apply_central_force(-horizontal_velocity * 0.5 * current_multiplier)

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D and body.is_in_group("ball"):
		# Start with 0 force multiplier, will ramp up
		affected_bodies[body] = 0.0

func _on_body_exited(body: Node3D) -> void:
	if body is RigidBody3D and body in affected_bodies:
		affected_bodies.erase(body)

## Get the current force multiplier for a body (0.0 to 1.0)
func get_body_force_multiplier(body: RigidBody3D) -> float:
	if body in affected_bodies:
		return affected_bodies[body]
	return 0.0
