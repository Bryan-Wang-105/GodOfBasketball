extends PanelContainer

@onready var tool_selector: Node = $"../../../../../ToolSelector"

@onready var panel: Panel = $MarginContainer/HBoxContainer/Panel
@onready var panel_2: Panel = $MarginContainer/HBoxContainer/Panel2
@onready var panel_3: Panel = $MarginContainer/HBoxContainer/Panel3
@onready var panel_4: Panel = $MarginContainer/HBoxContainer/Panel4

func _ready():
	tool_selector.change_index(0)

func change_slot(index):
	print("INDEX")
	print(index)
	panel.modulate = Color.WHITE
	panel_2.modulate = Color.WHITE
	panel_3.modulate = Color.WHITE
	panel_4.modulate = Color.WHITE
	
	match index:
		0:
			panel.modulate = Color.BLACK
		1:
			panel_2.modulate = Color.BLACK
		2:
			panel_3.modulate = Color.BLACK
		3:
			panel_4.modulate = Color.BLACK
