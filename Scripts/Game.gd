extends Node2D
 
func _ready():
	get_tree().set_debug_collisions_hint(true)
func _input(event):
	if event.is_action("ui_cancel"):
		# Pause menu for later
		pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
