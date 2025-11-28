# studio_intro.gd
extends BaseScene

signal intro_completed

@onready var animation_player = $AnimationPlayer
@onready var background_rect: ColorRect = $ColorRect

func initialize(data):
	# Start animation automatically when scene loads
	animation_player.play("title_fade")

	# Connect animation finished signal
	animation_player.animation_finished.connect(_on_animation_finished)

	# Connect to window resize signal to keep background full-screen
	get_tree().root.size_changed.connect(_resize_background)

func cleanup():
	# Disconnect signals
	animation_player.animation_finished.disconnect(_on_animation_finished)
	get_tree().root.size_changed.disconnect(_resize_background)

func _resize_background():
	# Make sure background covers the entire viewport
	var viewport_size = get_viewport_rect().size
	background_rect.size = viewport_size

func _on_animation_finished(anim_name):
	if anim_name == "title_fade":
		# Animation complete, emit signal to notify main
		emit_signal("intro_completed")
