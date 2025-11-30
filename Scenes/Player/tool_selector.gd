extends Node

@onready var hotbar: PanelContainer = $"../CanvasLayer/Control/Hotbar"

var tools = [null, null, null, null]
var active_index = 0

func change_index(index):
	active_index = index
	hotbar.change_slot(index)

func active_tool():
	tools[active_index].activate()

func add_tool(tool_obj):
	pass

func remove_tool(index):
	tools[index] = null

func replace_tool(index, tool_obj):
	tools[index] = tool_obj

# ------------------------------------------------------------------------------
# INPUT HANDLING
# ------------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	"""Handle 1, 2, 3 input."""
	# Toggle pause/mouse capture
	if Input.is_action_just_pressed("1"):
		change_index(0)
	elif Input.is_action_just_pressed("2"):
		change_index(1)
	elif Input.is_action_just_pressed("3"):
		change_index(2)
	elif Input.is_action_just_pressed("4"):
		change_index(3)
	
