extends Area2D

var speed :int = 500
var velocity = Vector2()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity * delta
