# base_scene.gd
class_name BaseScene
extends Control

# Virtual methods for scene lifecycle
func initialize(data):
	"""
	Initialize scene with provided data
	Override in child classes

	Parameters:
	data (Dictionary): Data passed from previous scene
	"""
	pass

func cleanup():
	"""
	Clean up resources before scene is removed
	Override in child classes
	"""
	pass

# Helper methods for scene transitions
func change_to_scene(scene_path, data = {}):
	"""
	Utility method to change to another scene

	Parameters:
	scene_path (String): Path to the scene resource
	data (Dictionary): Data to pass to the new scene
	"""
	GameManager.change_scene(scene_path, data)

# Optional common UI functions
func show_message(text, duration = 2.0):
	"""
	Display a temporary message

	Parameters:
	text (String): Message to display
	duration (float): How long to show the message
	"""
	# Implementation depends on your UI setup
	var message_label = Label.new()
	message_label.text = text
	add_child(message_label)

	# Position it (adjust as needed)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	# Create a timer to remove it
	var timer = get_tree().create_timer(duration)
	await timer.timeout
	message_label.queue_free()
