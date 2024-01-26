extends Node2D

@onready var timer = get_node("../AudioStreamPlayer2D/StartTimer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_audio_stream_player_2d_beats(position):
	print("Current beats:", position)


func _on_audio_stream_player_2d_measurement(position):
	print("Current measurement:", position)
