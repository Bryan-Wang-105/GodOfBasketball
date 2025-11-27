extends Node

var HUD
var ball
var player

var ball_arr = []
var ball_limit = 1000
var ball_index = 0


func add_new_ball(ball):
	if len(ball_arr) != ball_limit:
		ball_arr.append(ball)
		ball_index += 1
		
	else:
		print("REACHED 500 BALLS NOW DELETING 1 AND REPLACING")
		ball_arr[ball_index].queue_free()
		
		ball_arr[ball_index] = ball
		ball_index += 1
		
	if ball_index == ball_limit - 1:
		ball_index = 0

func get_next_ball():
	var toReturn = ball_arr[ball_index]
	
	ball_index += 1
	if ball_index == ball_limit - 1:
		ball_index = 0
	
	return toReturn
