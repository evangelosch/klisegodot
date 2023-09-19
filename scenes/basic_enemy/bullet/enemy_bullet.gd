extends Area2D

var speed :int = 300
var velocity = Vector2()
var is_returning = false


func _ready():
	pass#shooter = ge

func _physics_process(delta):
	position += velocity * delta

func return_to_shooter():
	is_returning = true
	velocity = -velocity  # Reverse the velocity
