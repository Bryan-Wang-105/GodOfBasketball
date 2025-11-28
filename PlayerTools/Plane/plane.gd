extends CharacterBody3D

# Flight variables
var speed = 20.0
var turn_speed = 1.5
var pitch_speed = 1.0
var roll_speed = 2.0
var roll_amount = 0.0
var max_roll = 45.0  # Maximum roll angle in degrees

@onready var cam_positions: AnimationPlayer = $CamPositions
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var main_cam: Camera3D = $"../MainCam"
@onready var bomb_cam: Camera3D = $BombCam
@onready var main_cam_pos: Node3D = $CamPos

@onready var mesh: Node3D = $Airplane

var balls_not_released = true
var balls_in_cargo = []
var view = 1

func _ready():
	# Collect all children that are in the "ball" group
	for child in get_children():
		if child.is_in_group("ball"):
			balls_in_cargo.append(child)

func _physics_process(delta):
	if view == 1:
		main_cam.current = true
		main_cam.global_position = main_cam_pos.global_position
		main_cam.look_at(self.global_position)
	
		# Forward movement in the direction the plane is facing (-Z axis)
	var forward = -transform.basis.z
	velocity = forward * speed
	
	# Pitch (W/S - up/down relative to plane)
	if Input.is_action_pressed("ui_down"):  # W key
		rotate_object_local(Vector3.RIGHT, -pitch_speed * delta)
	if Input.is_action_pressed("ui_up"):  # S key
		rotate_object_local(Vector3.RIGHT, pitch_speed * delta)
	
	# Roll (A/D - tilt left/right)
	var target_roll = 0.0
	if Input.is_action_pressed("ui_left"):  # A key
		target_roll = max_roll
		rotate_y(turn_speed * delta)  # Also turn while rolling
	elif Input.is_action_pressed("ui_right"):  # D key
		target_roll = -max_roll
		rotate_y(-turn_speed * delta)  # Also turn while rolling
	
	# Smoothly interpolate roll
	roll_amount = lerp(roll_amount, target_roll, roll_speed * delta)
	rotation.z = deg_to_rad(roll_amount)
	
	speed = 50.0
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("l_click") and balls_not_released:
		release_balls()
	
	if event.is_action_released("r_click"):
		print(global_position)
		switch_cams()

func switch_cams():
	# Switch to bomb view 1
	if view == 1:
		main_cam.current = false
		cam_positions.play("BayDoors")
		view = 2
	elif view == 2:
		main_cam.current = false
		cam_positions.play("StraightDown")
		view = 3
	# Switch to main cam
	elif view == 3:
		main_cam.current = true
		view = 1

# Call this function when you want to release the balls
func release_balls():
	balls_not_released = false
	
	anim.play("OpenDoors")
	
	for i in range(balls_in_cargo.size()):
		var ball = balls_in_cargo[i]
		if ball and is_instance_valid(ball):
			# Wait for delay (0.1 seconds between each)
			await get_tree().create_timer(0.01).timeout
			
			# Unfreeze the rigidbody
			ball.freeze = false
			
			# Add random slight velocity
			var random_velocity = Vector3(
				randf_range(-2.0, 2.0),  # Random X
				randf_range(-1.0, 1.0),  # Random Y (slight up/down)
				randf_range(-2.0, 2.0)   # Random Z
			)
			ball.linear_velocity = random_velocity
			
			# Preserve global transform during reparent
			var global_pos = ball.global_position
			var global_rot = ball.global_rotation
			
			ball.reparent(Global.land)
			
			ball.global_position = global_pos
			ball.global_rotation = global_rot
	
	# Optional: clear the array after release
	balls_in_cargo.clear()
		
