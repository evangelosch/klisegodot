extends CharacterBody2D

var bullet_scene: PackedScene = preload("res://scenes/basic_enemy/bullet/enemy_bullet.tscn")

var directions = [
	Vector2(0, -1),   # Up
	Vector2(0, 1),    # Down
	Vector2(-1, 0),   # Left
	Vector2(1, 0),    # Right
	Vector2(1, -1),   # UpRight
	Vector2(-1, -1),  # UpLeft
	Vector2(1, 1),    # DownRight
	Vector2(-1, 1)    # DownLeft	
]


var current_direction = Vector2(0, 0)  # Initial direction


const MAX_SPEED = 75
# Called when the node enters the scene tree for the first time.
func _ready():
	$DamageHitBox.area_entered.connect(on_area_entered)
	$DirectionChangeTimer.timeout.connect(on_DirectionChangeTimer_timeout)
	$ShootTimer.timeout.connect(_on_ShootTimer_timeout)
	change_direction()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var direction = get_direction_to_player()
	velocity = current_direction * MAX_SPEED
	#velocity = direction * MAX_SPEED
	move_and_slide()



func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO

func on_area_entered(other_area: Area2D):
	print("Area entered: ", other_area.name)
	if other_area.is_in_group("PlayerBullet"):
		queue_free()
	return

func on_DirectionChangeTimer_timeout():
	change_direction()


func change_direction():
	current_direction = directions[randi() % directions.size()].normalized()


func shoot_at_player():
	var bullet = bullet_scene.instantiate() as Area2D
	get_parent().add_child(bullet)
	
	bullet.global_position = global_position
	var direction = get_direction_to_player()
	bullet.velocity = direction * bullet.speed
	print("Bullet created with type: ", bullet.get_class())


func _on_ShootTimer_timeout():
	shoot_at_player()
