extends CSGBox3D

@onready var anim: AnimationPlayer = $"../AnimationPlayer"

var closed = true
var prompt = "Press [E] to open/close gym roof"


func get_prompt():
	return prompt

func interact():
	if closed:
		anim.play("OpenRoof")
		closed = false
	else:
		anim.play_backwards("OpenRoof")
		closed = true
	
