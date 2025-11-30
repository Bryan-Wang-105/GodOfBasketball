extends PanelContainer

@onready var tool_selector: Node = $"../../../../../ToolSelector"

@onready var panel: Panel = $MarginContainer/HBoxContainer/Panel
@onready var panel_2: Panel = $MarginContainer/HBoxContainer/Panel2
@onready var panel_3: Panel = $MarginContainer/HBoxContainer/Panel3
@onready var panel_4: Panel = $MarginContainer/HBoxContainer/Panel4

@onready var img1: TextureRect = $MarginContainer/HBoxContainer/Panel/MarginContainer/Panel/TextureRect
@onready var img2: TextureRect = $MarginContainer/HBoxContainer/Panel2/MarginContainer/Panel/TextureRect
@onready var img3: TextureRect = $MarginContainer/HBoxContainer/Panel3/MarginContainer/Panel/TextureRect
@onready var img4: TextureRect = $MarginContainer/HBoxContainer/Panel4/MarginContainer/Panel/TextureRect

var panels
var imgs

func _ready():
	panels = [panel, panel_2, panel_3, panel_4]
	imgs = [img1, img2, img3, img4]
	

func change_slot(old_index, index):
	print("INDEX")
	print(index)
	
	# Change old panel border to darker color
	var old_style = panels[old_index].get_theme_stylebox("panel").duplicate()
	old_style.border_color = Color("#443e3a")
	panels[old_index].add_theme_stylebox_override("panel", old_style)
	
	# Change new panel border to lighter color
	var new_style = panels[index].get_theme_stylebox("panel").duplicate()
	new_style.border_color = Color("#cdc7c2")
	panels[index].add_theme_stylebox_override("panel", new_style)
	
