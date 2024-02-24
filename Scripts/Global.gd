extends Node

@export var bpm = [100, 130, 150, 170, 190, 0]
@export var tolerance_ms : float = 100
var tolerance_seconds : float = float(tolerance_ms / 1000)
var beat_offset = 8
var camera_offset = 400
var health = 100
var random_seed_timer = int(Time.get_time_string_from_system())
var rng_seed = RandomNumberGenerator.new().randi()
#func set_difficulty(difficulty):
	#if difficulty == "easy":
		#tolerance_ms == 60 / bpm * 0.3
	#elif difficulty == "medium":
		#tolerance_ms == 60 / bpm * 0.2
	#elif difficulty == "hard":
		#tolerance_ms == 60 / bpm * 0.1
