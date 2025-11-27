extends RigidBody3D


func _ready() -> void:
	Global.ball = self
	Global.add_new_ball(self)
