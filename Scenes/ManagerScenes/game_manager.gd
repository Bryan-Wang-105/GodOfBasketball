# game_manager.gd (add to autoload in Project Settings)
extends Node

var current_scene_container = null
var current_scene = null
var player_data = {}

# Register the scene container from Main
func register_scene_container(container):
	current_scene_container = container

# Change scene with optional initialization data
func change_scene(scene_path, init_data = null):
	# Remove current scene
	for child in current_scene_container.get_children():
		child.queue_free()

	# Load new scene
	var new_scene = load(scene_path).instantiate()
	
	# Add to tree
	current_scene_container.add_child(new_scene)
	
	# Initialize if it extends BaseScene
	if new_scene.has_method("initialize"):
		new_scene.initialize(init_data)

	# Pick current scene
	current_scene = new_scene

# Save player progress (between scenes)
func save_player_progress(data):
	player_data = data
	# Could also save to disk here

# Get player progress
func get_player_progress():
	return player_data
