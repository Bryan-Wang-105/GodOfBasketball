# title_screen.gd
extends BaseScene

signal start_game_pressed
signal options_pressed
signal quit_game_pressed

@onready var title_menu_animator: AnimationPlayer = $TitleMenuAnimator

@onready var title: Label = $CanvasLayer/Control/Title

@onready var options_vbox: VBoxContainer = $CanvasLayer/Control/OptionsVbox
@onready var start_button: Button = $CanvasLayer/Control/OptionsVbox/StartButton
@onready var options_button: Button = $CanvasLayer/Control/OptionsVbox/OptionsButton
@onready var exit_button: Button = $CanvasLayer/Control/OptionsVbox/ExitButton
@onready var black_rect: ColorRect = $CanvasLayer/Control/BlackRect

# Track if player has pressed any button yet
var initial_input_received = false
var fade_in_complete = false

func _ready():
	# Set menu invisible initially
	black_rect.visible = true
	title.visible = false
	options_vbox.visible = false

	# Connect button signals
	start_button.pressed.connect(_on_start_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	exit_button.pressed.connect(_on_quit_button_pressed)

	# Connect animation finished function
	title_menu_animator.animation_finished.connect(_on_animation_finish)

	# Play title animation
	title_menu_animator.play("fade_black_in")

func initialize(show_title):
	# Reset state when scene is initialized
	initial_input_received = show_title
	fade_in_complete = false

func _input(event):
	# Only process input if fade-in animation is complete
	if not fade_in_complete:
		return

	# If initial_input_received is false, we show title screen
	if not initial_input_received and (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		initial_input_received = true
		_fade_in_menu()
		get_viewport().set_input_as_handled() # Consume the input

	# Show the main menu

func _fade_in_menu():
	# Play animation to fade title and show menu
	title_menu_animator.play("title_fade_out")

func _on_animation_finish(anim_name):
	if anim_name == "title_fade_in":
		fade_in_complete = true
	elif anim_name == "title_fade_out":
		_show_main_menu()
	elif anim_name == "main_menu_fade_out":
		title_menu_animator.play("fade_black_out")
	elif anim_name == "fade_black_in":
		title_menu_animator.play("title_fade_in")
	elif anim_name == "fade_black_out":
		_to_world()
	else:
		pass

func _show_main_menu():
	title_menu_animator.play("main_menu_fade_in")

func _on_start_button_pressed():
	print("Start game pressed")
	emit_signal("start_game_pressed")
	# For actual implementation:
	# GameManager.change_scene("res://scenes/main_menu.tscn")

	title_menu_animator.play("main_menu_fade_out")

func _on_options_button_pressed():
	print("Options pressed")
	emit_signal("options_pressed")
	# For actual implementation:
	# var options_menu = preload("res://scenes/options_menu.tscn").instantiate()
	# add_child(options_menu)

func _on_quit_button_pressed():
	print("Quit pressed")
	emit_signal("quit_game_pressed")
	# For actual implementation:
	get_tree().quit()

func _to_world():
	# Change scene to world
	print("ball array length")
	print(len(BallManager.ball_arr))
	BallManager.reset_ball_array()
	print("ball array length after reset")
	print(len(BallManager.ball_arr))
	GameManager.change_scene("res://Environments/world.tscn")

func cleanup():
	# Any cleanup needed before scene removal
	pass
