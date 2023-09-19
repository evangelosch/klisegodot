extends CharacterBody2D

const MAX_SPEED = 200
var bullet_scene: PackedScene = preload("res://scenes/player/bullet/player_bullet.tscn")

#dash check
var dash_direction = Vector2()
var friction = 0.5
var dash_speed = 10
var dash_length = 3
var can_shoot = true
var bullet_dodge_distance_threshold: float = 50.0 
@onready var animation_tree : AnimationTree = $AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	$ShootCooldown.timeout.connect(on_ShootCooldown_timeout)
	$ShootSound.finished.connect(on_ShootSound_finished)
	animation_tree.animation_finished.connect(on_ParryAnimation_finished)
	$Parry.area_entered.connect(on_ParryHitbox_area_entered)


func _process(delta):
	#handle animations
	update_animation_parameters()
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
	for bullet in get_tree().get_nodes_in_group("enemyBullet"):
		if bullet.global_position.distance_to(global_position) < bullet_dodge_distance_threshold:
			slow_down_time(0.5, 2.0)  # Slow down time
			break  # Exit the loop once one qualifying bullet is found
	velocity = get_input_direction() * dash_speed * dash_length
	velocity *= 1.0 - (friction * deltaValue)
	move_and_collide(velocity)


func slow_down_time(scale: float, duration: float):
	Engine.time_scale = scale
	await get_tree().create_timer(duration).timeout
	Engine.time_scale = 1.0


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


func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	if (Input.is_action_just_pressed("parry")):
		animation_tree["parameters/conditions/is_parrying"] = true


	
func on_ParryAnimation_finished(animation_name: String):
	if (animation_name == "parry_right"):
		animation_tree["parameters/conditions/is_parrying"] = false


func on_ParryHitbox_area_entered(area: Area2D):
	if area.is_in_group("enemyBullet"):
		area.return_to_shooter()
