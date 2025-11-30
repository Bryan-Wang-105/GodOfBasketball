extends Node

@onready var hotbar: PanelContainer = $"../CanvasLayer/Control/MarginContainer/Control/Hotbar"

var tools = [null, null, null, null]
var active_index = 0

func _ready():
	Global.tool_selector = self

func change_index(index):
	# Drop ball if switching tools
	if active_index == 0 and index != 0:
		BallManager.drop_ball()
		
	hotbar.change_slot(active_index, index)
	active_index = index

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
	
