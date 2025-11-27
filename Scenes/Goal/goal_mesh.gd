extends RigidBody3D

@onready var top_area: Area3D = $Area3D
@onready var bottom_area: Area3D = $Area3D2

var balls_in_top: Array = []  # Track which balls entered top area
var score_count: int = 0
var health = 100

func _ready() -> void:
	gravity_scale = 1
	freeze = true
	
	# Connect signals for top area
	top_area.body_entered.connect(_on_top_area_entered)
	top_area.body_exited.connect(_on_top_area_exited)
	
	# Connect signals for bottom area
	bottom_area.body_entered.connect(_on_bottom_area_entered)
	#bottom_area.body_exited.connect(_on_bottom_area_exited)

func _on_top_area_entered(body: Node3D) -> void:
	if body.is_in_group("ball"):
		# Ball entered from top
		if not balls_in_top.has(body):
			balls_in_top.append(body)
			print("Ball entered top area")

func _on_top_area_exited(body: Node3D) -> void:
	if body.is_in_group("ball"):
		# Ball left top area (either going back up or continuing down)
		print("Ball exited top area")
		balls_in_top.erase(body)

func _on_bottom_area_entered(body: Node3D) -> void:
	print("Ball entered bottom area")
	if body.is_in_group("ball") and body in balls_in_top:
		on_goal_scored(body)
		

func take_dmg(amt):
	health = max(0, health - amt)
	
	if health <= 0:
		freeze = false

func on_goal_scored(ball: Node3D) -> void:
	score_count += 1
	print("GOAL! Score: ", score_count)
	
	Global.HUD.stop_clock()
	# Add your goal logic here:
	# - Play sound effect
	# - Update UI score
	# - Particle effects
	# - Add points to player/team
	# Example:
	# Global.score += 2
	# $AudioStreamPlayer3D.play()
