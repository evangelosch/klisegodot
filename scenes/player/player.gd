extends CharacterBody2D

const MAX_SPEED = 200

#dash check
var dash_direction = Vector2()
var friction = 0.5
var dash_speed = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity = direction * MAX_SPEED
	move_and_slide()
	#handle dash
	if Input.is_action_just_pressed("dash"):
		dash_direction = direction.normalized()
		velocity = dash_direction * dash_speed * 10
		#velocity *= 1.0 - (friction * delta)
		print("dash")
		move_and_collide(velocity)


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)
	
#handle dash

