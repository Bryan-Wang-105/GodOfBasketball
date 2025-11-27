extends RayCast3D

var result
var ball

func _ready() -> void:
	ball = Global.ball

func _process(delta: float) -> void:
	if Input.is_action_pressed("l_click") and ball.freeze:
		# Freeze the body so physics won't fight you
			ball.freeze = true

			# Apply transform and velocities DEFERRED (required for RigidBody3D)
			ball.set_deferred("global_position", Global.player.hold_pos.global_position)
			#ball.set_deferred("global_rotation", Vector3.ZERO)
			ball.set_deferred("linear_velocity", Vector3.ZERO)
			ball.set_deferred("angular_velocity", Vector3.ZERO)

	result = get_collider()
		
	if result and result.is_in_group("interactable"):
		Global.HUD.prompt.text = result.get_prompt()
	else:
		Global.HUD.prompt.text = "x"
		
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		result.interact()
	
	elif event.is_action_pressed("l_click"):
		if result and result.is_in_group("ball"):
			print("CLICKED BALL")
			Global.ball = result
			ball = Global.ball
			
			# Freeze the body so physics won't fight you
			ball.freeze = true

			# Apply transform and velocities DEFERRED (required for RigidBody3D)
			ball.set_deferred("global_position", Global.player.hold_pos.global_position)
			#ball.set_deferred("global_rotation", Vector3.ZERO)
			ball.set_deferred("linear_velocity", Vector3.ZERO)
			ball.set_deferred("angular_velocity", Vector3.ZERO)
			
	
	elif event.is_action_released("l_click"):
		# Unfreeze AFTER the physics step
		await get_tree().physics_frame
		Global.ball.freeze = false
		pass
		
