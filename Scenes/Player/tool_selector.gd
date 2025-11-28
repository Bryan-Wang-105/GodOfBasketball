extends Node

var tools = [null, null, null, null]
var active_index

func change_index(index):
	active_index = index

func active_tool():
	tools[active_index].activate()
	

func add_tool(tool_obj):
	pass

func remove_tool(index):
	tools[index] = null


func replace_tool(index, tool_obj):
	tools[index] = tool_obj
