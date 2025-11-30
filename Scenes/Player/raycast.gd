extends RayCast3D

var result
var ball

func _ready() -> void:
	ball = BallManager.ball

func _process(delta: float) -> void:
	result = get_collider()
	
	# Drag ball around
	if Global.tool_selector.active_index == 0 and Input.is_action_pressed("l_click") and ball.freeze:
		# Freeze the body so physics won't fight you
		BallManager.freeze_ball()
		
	if result and result.is_in_group("interactable"):
		Global.HUD.prompt.text = result.get_prompt()
	else:
		Global.HUD.prompt.text = "x"
		
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if result:
			result.interact()
	
	# Pick up ball
	elif Global.tool_selector.active_index == 0 and event.is_action_pressed("l_click"):
		if result and result.is_in_group("ball"):
			print("CLICKED BALL")
			BallManager.ball = result
			ball = BallManager.ball
			
			# Freeze the body so physics won't fight you
			BallManager.freeze_ball()
	
	# Release ball
	elif Global.tool_selector.active_index == 0 and event.is_action_released("l_click"):
		# Unfreeze AFTER the physics step
		await get_tree().physics_frame
		BallManager.drop_ball()
