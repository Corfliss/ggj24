extends Node

var input_timer: Timer

func _ready():
	input_timer = $Timer
	input_timer.connect("timeout", self, "_on_input_timeout")

func _process(delta):
	if Input.is_action_just_pressed("your_input_action"):
		# First press, handle it immediately
		_handle_input()

		# Start the timer to handle subsequent presses
		input_timer.start()

func _on_input_timeout():
	# Timer has elapsed, allowing for the next press
	input_timer.stop()

func _handle_input():
	# Your code to handle the input goes here
	print("Input pressed!")
