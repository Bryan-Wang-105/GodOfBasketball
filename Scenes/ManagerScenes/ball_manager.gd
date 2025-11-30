extends Node

var ball
var ball_arr = []
var ball_limit = 2000
var ball_index = 0


func add_new_ball(ball):
	if len(ball_arr) != ball_limit:
		ball_arr.append(ball)
		ball_index += 1
		
	else:
		print("REACHED MAX LIMIT, GETTING ONE FROM EXISTING POOL")
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

func reset_ball_array():
	ball = null
	ball_arr = []
