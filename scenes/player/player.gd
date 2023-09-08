extends CharacterBody2D

const MAX_SPEED = 200

#dash check
var dash_direction = Vector2()
var friction = 0.5
var dash_speed = 10
var dash_length = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#handle movement
	get_movement_input()
	move_and_slide()
	#handle dash
	if Input.is_action_just_pressed("dash"):
		do_dash(delta)
		print("dash")
	
	
func get_movement_input():
	velocity = get_input_direction() * MAX_SPEED
	
	
func do_dash(deltaValue):
	velocity = get_input_direction() * dash_speed * dash_length
	velocity *= 1.0 - (friction * deltaValue)
	move_and_collide(velocity)


func get_input_direction():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_direction == null:
		return Vector2.ZERO
	return input_direction

