extends Node2D

@onready var texture = $Camera2D/TextureRect
func _ready():
	pass
	#get_tree().set_debug_collisions_hint(true)
func _input(event):
	if event.is_action("ui_cancel"):
		# Pause menu for later
		pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.health <= 0:
		get_tree().paused = true
		texture.visible = true
