extends Node

var my_timer 
var timer_started = false
var button_pressed = false
var time_left
var timer_zero = false

var tolerance = 0.3


func _ready():
	my_timer = $Timer
	my_timer.start()
	time_left = my_timer.time_left


func _process(delta):
	
	#print("Time left:", time_left)
	
	time_left = my_timer.time_left
	#print("time left = ", time_left)
	
	if Input.is_action_just_pressed("ui_accept"):
		button_pressed = true
		print("button pressed")
	else:
		button_pressed = false
		
	if time_left <= tolerance and button_pressed:
		evaluate_button_press()

func _on_timer_timeout():
	print("Beat has happened")
	#timer_zero = true
	#call_deferred("evaluate_button_press")
	
	
func evaluate_button_press():	
	
		print("Pressed within tolerance window")
	
	
		
	#else:
		#print("you missed")
		#timer_zero = false
	
	
	# Print the value of button_pressed
	
	
	#wait time represents duration of timer, time_elapsed(time since running)
	
	
	
	
	
	
