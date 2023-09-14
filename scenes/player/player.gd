extends CharacterBody2D

const MAX_SPEED = 200
var bullet_scene: PackedScene = preload("res://scenes/player/bullet/player_bullet.tscn")

#dash check
var dash_direction = Vector2()
var friction = 0.5
var dash_speed = 10
var dash_length = 3
var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShootCooldown.timeout.connect(on_ShootCooldown_timeout)
	$ShootSound.finished.connect(on_ShootSound_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#handle movement
	get_movement_input()
	move_and_slide()
	#handle dash
	if Input.is_action_just_pressed("dash"):
		do_dash(delta)
		print("dash")
	#handle shooting
	if Input.is_action_just_pressed("left_click") and can_shoot:
		do_shoot()


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


func do_shoot():
	can_shoot = false
	$ShootCooldown.start()
	
	var bullet = bullet_scene.instantiate()
	get_tree().get_first_node_in_group("player").get_parent().add_child(bullet)
	bullet.global_position = global_position
	var direction = (get_global_mouse_position() - bullet.global_position).normalized()
	bullet.velocity = direction * bullet.speed
	print("Bullet created with type: ", bullet.get_class())
	$ShootSound.play()


func on_ShootCooldown_timeout():
	can_shoot = true


func on_ShootSound_finished():
	$ReloadSound.play()
