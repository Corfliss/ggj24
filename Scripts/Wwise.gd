extends Node2D

var music_playlist
var music_100
# Called when the node enters the scene tree for the first time.
func _ready():
	Wwise.register_game_obj(self, "Wwise")
	music_playlist = Wwise.post_event_id(AK.EVENTS.MUSIC_PLAYLIST_100, self)
	
func _music_100():
	music_100 = Wwise.post_event_id(AK.EVENTS.MUSIC_PLAYLIST_40, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#if Input.is_action_pressed("ui_up"):
		#Wwise.stop_event(music_playlist, 100, AkUtils.AK_CURVE_LINEAR)
		#_music_100()

	#if Input.is_action_pressed("ui_accept"):
		#change_wise_rtpc()
			
#func change_wise_rtpc():	
	#
	#var new_value = 50  # Replace with the desired value
	# Call the Wwise API function to set the RTPC value
	#Wwise.set_rtpc_value_id(rtpc_id, new_value)
		

func _on_character_body_2d_trip():
	Wwise.post_event_id(AK.EVENTS.TRIP, self)
	
	if Global.health <= 80:
		Wwise.stop_event(music_playlist, 1000, AkUtils.AK_CURVE_LINEAR)
		music_playlist = Wwise.post_event_id(AK.EVENTS.MUSIC_PLAYLIST_80, self)
	if Global.health <= 60:
		Wwise.stop_event(music_playlist, 1000, AkUtils.AK_CURVE_LINEAR)
		music_playlist = Wwise.post_event_id(AK.EVENTS.MUSIC_PLAYLIST_60, self)
	if Global.health <= 40:
		Wwise.stop_event(music_playlist, 1000, AkUtils.AK_CURVE_LINEAR)
		music_playlist = Wwise.post_event_id(AK.EVENTS.MUSIC_PLAYLIST_40, self)
	if Global.health <= 20:
		Wwise.stop_event(music_playlist, 1000, AkUtils.AK_CURVE_LINEAR)
		music_playlist = Wwise.post_event_id(AK.EVENTS.MUSIC_PLAYLIST_20, self)
	if Global.health <= 0:
		Wwise.stop_event(music_playlist, 1000, AkUtils.AK_CURVE_LINEAR)
		music_playlist = Wwise.post_event_id(AK.EVENTS.DEATH, self)
	
