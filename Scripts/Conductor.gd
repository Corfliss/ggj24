# Courtesy of LegionGames
# https://github.com/LegionGames/Conductor-Example/blob/master/Scripts/Conductor.gd

extends AudioStreamPlayer2D

var bpm = Global.bpm[0]
var measures = 4

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

# The main process
func _physics_process(_delta):
	if playing:
		audio_update()
	if not playing:
		#play()
		audio_update()

func audio_update():
	# Get the song position according to the playback position and time since last mix
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		
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
	play()
	
	# Set the position from audio will be played, in seconds
	seek(beat * sec_per_beat)
	
	# Get the beats before start from the offset parameter
	beats_before_start = offset
	
	# Get the measure
	measure = beat % measures

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
		play()
		
		# Stop the start timer
		$StartTimer.stop()
	
	# Regardless the condition, update the beat report
	_report_beat()
	
func _on_character_body_2d_trip():
	if Global.health <= 80:
		bpm = Global.bpm[1]
	if Global.health <= 60:
		bpm = Global.bpm[2]
	if Global.health <= 40:
		bpm = Global.bpm[3]
	if Global.health <= 20:
		bpm = Global.bpm[4]

