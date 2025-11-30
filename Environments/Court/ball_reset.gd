extends CSGBox3D

@onready var ball_spawn: Node3D = $"../BallSpawn"

var closed = true
var prompt = "Press [E] to reset the ball"
	

func get_prompt():
	return prompt

func interact():
	var ball = BallManager.ball

	# Freeze the body so physics won't fight you
	ball.freeze = true

	# Apply transform and velocities DEFERRED (required for RigidBody3D)
	ball.set_deferred("global_position", ball_spawn.global_position)
	ball.set_deferred("global_rotation", Vector3.ZERO)
	ball.set_deferred("linear_velocity", Vector3.ZERO)
	ball.set_deferred("angular_velocity", Vector3.ZERO)

	# Unfreeze AFTER the physics step
	await get_tree().physics_frame
	ball.freeze = false
