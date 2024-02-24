# Courtesy of LegionGames with modifications
# https://github.com/LegionGames/Conductor-Example/blob/master/Scripts/Conductor.gd

extends Node2D

@export var bgm_list : Array[AudioStreamRandomizer]
@export var sfx_list : Array[AudioStreamRandomizer]

@onready var bgm = $BGM
@onready var sfx = $SFX
var death_sfx

var bpm = Global.bpm[0]
var measures = 4
var current_time = 0
var beat_duration_100 = 0.1
var current_song_list
var current_song
var current_song_index


# Tracking the beat data and song position
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

# Making the signal
signal beats(position)
signal measurement(position)

func _ready():
	current_song_list = bgm_list[0]
	bgm.stream = current_song_list.get_stream(Global.rng_seed % bgm_list.size())
	bgm.play()

# The main process
func _physics_process(_delta):
	#BPM is standard calc (60 divided by)
	#current_time += _delta
	#loop_start_time = current_time
	#if (loop_start_time % beat_duration_100 <= _delta):
		#print("Beat!")	
	#if current_time >= beat_duration_100:

		#print("Beat!")
		#current_time -= beat_duration_100
		#var button_pressed_on_beat = true
		#print(button_pressed_on_beat)

		#if Input.is_action_pressed("ui_accept") and button_pressed_on_beat == true:
			#print("Enter key pressed on beat!")

	audio_update()
	position = $"../CharacterBody2D".position
	#if playing:
		#audio_update()
	#if not playing:
		#audio_update()

func audio_update():
		# Get the song position according to the playback position and time since last mix
		song_position = bgm.get_playback_position() + AudioServer.get_time_since_last_mix()

		# Compensate for output latency
		song_position -= AudioServer.get_output_latency()

		# Keeping track of song position in beats
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start

		# Report the beat processing with a private function
		_report_beat()

# The function to report beat to give information
func _report_beat():

	# If the beat is not ending
	if last_reported_beat < song_position_in_beats:

		# Checking on which beat measures we are
		if measure > measures:

			# Return to 1 if it is at the end of the measures
			measure = 1

		# Emit signal for sending the report	
		emit_signal("beats", song_position_in_beats)
		emit_signal("measurement", measure)
		last_reported_beat = song_position_in_beats

		# Increment measure by 1
		measure += 1

# To run fake beat before the real one starts
func play_with_beat_offset(num):

	# Assign the number of beats before start
	beats_before_start = num

	# Make a timer according to the beat offset
	#$StartTimer.wait_time = sec_per_beat
	#$StartTimer.start()

# Not sure how this is going to be used in the game
# But I reckon this is for detecting the closest beat
func closest_beat():

	# Get the integer of the closest beat
	closest = round(song_position / sec_per_beat)

	# Get the time off beat
	time_off_beat = abs(closest * sec_per_beat - song_position)

	# Return both as Vector2
	return Vector2(closest, time_off_beat)

	# For debugging purpose:
	#print("----------------------")
	#print("time_off_beat: ", time_off_beat)
	#print("song_position: ", song_position)
	#print("sec_per_beat: ", sec_per_beat)
	#print("closest_beat: ", closest_beat)
	#print("song_position_in_beats: ", song_position_in_beats)
	#print("last_reported_beat: ", last_reported_beat)
	#print("beats_before_start: ", beats_before_start)
	#print("measure: ", measure)
	#print("----------------------")

func play_from_beat(beat, offset):
	# Play the msuic
	bgm.play()

	# Set the position from audio will be played, in seconds
	bgm.seek(beat * sec_per_beat)

	# Get the beats before start from the offset parameter
	beats_before_start = offset

	# Get the measure
	measure = beat % measures

func repeat_previous():
	pass

# Signal from StartTimer timeout
func _on_start_timer_timeout():

	# Increment the song position in beats
	song_position_in_beats += 1

	# Checking if the song position in beats are before the beats before start
	if song_position_in_beats < beats_before_start - 1:

		# Start a timer
		$StartTimer.start()

	# If the song position in beats is right before beats before start
	elif song_position_in_beats == beats_before_start - 1:

		# Initialize a timer to sync with the music
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() +
														AudioServer.get_output_latency())

		# Initialize the synced timer
		$StartTimer.start()

	# If it is all over
	else:

		# Play the music
		bgm.play()

		# Stop the start timer
		$StartTimer.stop()

	# Regardless the condition, update the beat report
	_report_beat()

func _on_character_body_2d_trip():

	# Stop the music
	bgm.stop()

	# Process the index of the current song playlist index
	var current_index = abs((Global.health / 20) - 5)

	# Set the index of the current bpm
	bpm = Global.bpm[current_index]

	if Global.health > 0:
		# Change the current song playlist
		current_song_list = bgm_list[current_index]

		# Set the stream to the random chosen playlist
		bgm.stream = current_song_list.get_stream(Global.rng_seed % bgm_list.size())

		# Play it
		bgm.play()

	else:
		bgm.stop()

	# Add sound effects of tripping
	sfx.stream = sfx_list[0] # 0 for trip sfx list
	
	# Play the sound effects
	sfx.play()
	
	#If died, play audiostream of dying with the trip audio
	if Global.health <= 0:
		death_sfx = AudioStreamPlayer2D.new()
		add_child(death_sfx)
		death_sfx.stream = sfx_list[1] # 1 for death sfx list
		death_sfx.play()
		death_sfx.finished.connect(_on_death_sfx_finished)


# Signal to loop the audio
func _on_bgm_finished():
	bgm.play()

# Signal to remove the child of death sfx when it is finished
func _on_death_sfx_finished():
	remove_child(death_sfx)
