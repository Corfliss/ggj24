extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var conductor = $Conductor
@onready var camera = $"../Camera2D"

var is_jumping = false

const SPEED = 750.0
const JUMP_VELOCITY = 800.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(delta):
	camera.position.x = position.x + Global.camera_offset
	var direction = 0
	if Input.is_action_pressed("ui_right"): # and conductor.closest_beat().y < Global.tolerance_seconds:
		direction =+ 1
	if Input.is_action_pressed("ui_left"): # and conductor.closest_beat().y < Global.tolerance_seconds:
		direction =- 1

	# Set velocity based on input
	velocity.x = direction * SPEED

	# Jumping logic   
	if is_on_floor() and Input.is_action_just_pressed("ui_up"): #and conductor.closest_beat().y < Global.tolerance_seconds:
		velocity.y = -JUMP_VELOCITY
		is_jumping = true

	# Apply gravity
	if !is_on_floor():
		velocity.y += gravity * delta

	# Flip the sprite based on movement direction
	if direction != 0:
		animated_sprite.scale.x = direction
	
	# Play animations based on movement state
	update_animations()

	# Move the character
	move_and_slide()

func update_animations():
	# Play the appropriate animation based on the character's state
	if is_on_floor():
		if velocity.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
	else:
		animated_sprite.play("jump")
		
func _input(event : InputEvent):
	if event.is_action_pressed("ui_down"):
		position.y += 1

