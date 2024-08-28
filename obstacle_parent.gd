extends Node2D
class_name ObstaclesParent

var speed = 0
	
func _physics_process(delta):
	position.x -= speed * delta

func set_speed(new_speed : float):
	speed = new_speed
