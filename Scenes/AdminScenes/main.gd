# main.gd
extends Node

@onready var current_scene_container = $CurrentSceneContainer

func _ready():
	# Register the scene container with GameManager
	GameManager.register_scene_container(current_scene_container)

	# Start with studio intro
	_load_studio_intro()

func _load_studio_intro():
	print("Loading studio Intro")
	# Change scene to studio intro scene
	GameManager.change_scene("res://Scenes/LoadingScenes/StudioIntro.tscn")
	
	# When studio intro complete, load title
	GameManager.current_scene.intro_completed.connect(_on_studio_intro_completed)

func _on_studio_intro_completed():
	print("Signal complete for studio intro")
	# When intro finishes, load title screen
	_load_title_screen()

func _load_title_screen():
	print("Loading title screen")
	#var title_screen = load("res://Scenes/MainMenuScenes/TitleScreen.tscn").instantiate()
	#_set_current_scene(title_screen)
	
	# Change scene to main title scene
	GameManager.change_scene("res://Scenes/MainMenuScenes/TitleScreen.tscn")
