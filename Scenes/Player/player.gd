extends CharacterBody3D

# ==============================================================================
# FIRST PERSON CONTROLLER
# A basic FPS-style character controller with mouse look, WASD movement,
# jumping, sprinting, and pause functionality
# ==============================================================================

# ------------------------------------------------------------------------------
# CONSTANTS AND CONFIGURATION
# ------------------------------------------------------------------------------
const WALK_SPEED: float = 10.0          # Base movement speed
const SPRINT_SPEED: float = 20.0         # Sprint movement speed  
const JUMP_VELOCITY: float = 4.5        # Upward velocity for jumping
const MOUSE_SENSITIVITY: float = 0.002  # Mouse look sensitivity
const GRAVITY: float = 9.8              # Gravity acceleration

# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------
var direction: Vector3 = Vector3.ZERO   # Current movement direction
var lerp_speed: float = 10.0            # Speed of movement interpolation
var is_mouse_captured: bool = true      # Whether mouse is captured for look

# Node references
@onready var head = $Head               # Camera head node for mouse look
@onready var hold_pos: Node3D = $Head/HoldPos

# ------------------------------------------------------------------------------
# INITIALIZATION
# ------------------------------------------------------------------------------
func _ready() -> void:
	"""Initialize the controller and capture mouse on start."""
	Global.player = self
	capture_mouse()

# ------------------------------------------------------------------------------
# INPUT HANDLING
# ------------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	"""Handle mouse look and pause input."""
	# Mouse look - only when mouse is captured
	if event is InputEventMouseMotion and is_mouse_captured:
		# Rotate player body horizontally
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# Rotate head vertically with clamping to prevent over-rotation
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85), deg_to_rad(85))
	
	# Toggle pause/mouse capture
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

# ------------------------------------------------------------------------------
# PHYSICS AND MOVEMENT
# ------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	"""Handle physics-based movement, gravity, and jumping."""
	
	# Apply gravity when not on ground
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# Handle jumping - only when on ground
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Determine movement speed (sprint only works on ground)
	var current_speed = SPRINT_SPEED if Input.is_action_pressed("sprint") and is_on_floor() else WALK_SPEED
	
	# Get input direction from WASD/arrow keys
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Convert input to world space direction relative to player rotation
	var target_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Smoothly interpolate current direction toward target for responsive feel
	direction = lerp(direction, target_direction, delta * lerp_speed)
	
	# Apply movement or deceleration
	if direction.length() > 0.01:  # Small threshold to avoid jitter
		# Moving - apply direction and speed
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		# Not moving - smoothly decelerate to stop
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	# Apply movement with collision detection
	move_and_slide()

# ------------------------------------------------------------------------------
# MOUSE CONTROL FUNCTIONS
# ------------------------------------------------------------------------------
func capture_mouse() -> void:
	"""Capture mouse for first-person look control."""
	is_mouse_captured = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func release_mouse() -> void:
	"""Release mouse to show cursor (for menus, etc.)."""
	is_mouse_captured = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func toggle_pause() -> void:
	"""Toggle between captured and released mouse states."""
	if is_mouse_captured:
		release_mouse()
	else:
		capture_mouse()
