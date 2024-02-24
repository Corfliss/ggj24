extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
#@onready var conductor = $Conductor
@onready var camera = $"../Camera2D"

var is_jumping = false

const SPEED = 750.0
const JUMP_VELOCITY = 800.0
const TRIP_SPEED = 500

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Signal for taking a trip
signal trip()

func _ready():
	# Set velocity based on input
	velocity.x = SPEED

func _process(delta):
	# Set the camera position
	camera.position.x = position.x + Global.camera_offset

	# Jumping logic   
	if is_on_floor() and Input.is_action_just_pressed("ui_up"): #and conductor.closest_beat().y < Global.tolerance_seconds:
		velocity.y = -JUMP_VELOCITY
		is_jumping = true

	# Apply gravity
	if !is_on_floor():
		velocity.y += gravity * delta

	#if Input.is_action_just_pressed("ui_accept") and first_press:
		##timer.wait_time = 50
		##timer.start()
		##print("Timer start")
		#first_press = false
	#
	#if Input.is_action_just_pressed("ui_accept") and !first_press:
		#pass
		#timer.stop()
		#timer.wait_time = 50
		#timer.start()
		#print(timer.time_left)

	
		
	
			#else:
				#Global.health -= 20
				#velocity.x = TRIP_SPEED
				#if is_on_floor:
					#velocity.y = -250
				#emit_signal("trip")
				#update_animations()

	if is_on_floor() and Input.is_action_just_pressed("ui_down"):
		position.y += 1
		
	# Play animations based on movement state
	update_animations()

	# Move the character
	move_and_slide()
	
func update_animations():
	# Play the appropriate animation based on the character's state
	if is_on_floor():
		if velocity.x == SPEED:
			animated_sprite.play("run")
		elif velocity.x == TRIP_SPEED:
			return
		else:
			animated_sprite.play("idle")
	else:
		if velocity.x == TRIP_SPEED:
			animated_sprite.play("trip")
		else:
			animated_sprite.play("jump")

func _on_obstacles_body_entered(_body):
	Global.health -= 20
	velocity.x = TRIP_SPEED
	if is_on_floor:
		velocity.y = -250
	emit_signal("trip")
	update_animations()

func _on_animated_sprite_2d_animation_finished():
	velocity.x = SPEED
	update_animations()
