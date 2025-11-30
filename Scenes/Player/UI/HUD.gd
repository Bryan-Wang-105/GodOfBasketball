extends Control

@onready var fps: Label = $MarginContainer/Control/FPS
@onready var timer: Label = $MarginContainer/Control/Timer
@onready var prompt: Label = $MarginContainer/Control/Prompt

@onready var anim: AnimationPlayer = $AnimationPlayer

var scored = false
var elapsed_time = 0.0

func _ready() -> void:
	update_font_size()
	get_viewport().size_changed.connect(update_font_size)
	Global.HUD = self

func update_font_size():
	var viewport_size = get_viewport_rect().size
	# Font size as 5% of screen height, for example
	var new_font_size = int(viewport_size.y * 0.05)
	
	# For Label nodes
	fps.add_theme_font_size_override("font_size", new_font_size)
	timer.add_theme_font_size_override("font_size", new_font_size)
	prompt.add_theme_font_size_override("font_size", new_font_size)


func _process(delta):
	fps.text = "FPS: " + str(Engine.get_frames_per_second())
	
	if not scored:
		# Update elapsed time
		elapsed_time += delta
		
		# Convert to HH:MM:SS:MS
		var hours = int(elapsed_time) / 3600
		var minutes = int(elapsed_time) / 60 % 60
		var seconds = int(elapsed_time) % 60
		var centi_seconds = int((elapsed_time - int(elapsed_time)) * 100)
		
		timer.text = "%02d:%02d:%02d:%02d" % [hours, minutes, seconds, centi_seconds]


func stop_clock():
	scored = true
	animate_timer()


func animate_timer():
	print("YOU WIN")
