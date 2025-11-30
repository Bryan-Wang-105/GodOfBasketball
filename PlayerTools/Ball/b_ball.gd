extends RigidBody3D


func _ready() -> void:
	if not BallManager.ball:
		BallManager.ball = self
	
	BallManager.add_new_ball(self)
