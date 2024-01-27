extends Node

@export var bpm : float = 144
@export var tolerance_ms : float = 100
var tolerance_seconds : float = float(tolerance_ms / 1000)
var beat_offset = 8
var camera_offset = 500


#func set_difficulty(difficulty):
	#if difficulty == "easy":
		#tolerance_ms == 60 / bpm * 0.3
	#elif difficulty == "medium":
		#tolerance_ms == 60 / bpm * 0.2
	#elif difficulty == "hard":
		#tolerance_ms == 60 / bpm * 0.1
