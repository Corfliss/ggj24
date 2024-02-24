extends Node2D

@onready var texture = $Camera2D/TextureRect

func _ready():
	$Audio.process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		# ui_cancel is the default action for the Escape key
		get_tree().quit()  # End the game
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.health <= 0:
		get_tree().paused = true
		texture.visible = true
	
	
