extends StaticBody2D

@onready var camera = $"../../Camera2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position.x = camera.position.x - Global.camera_offset

