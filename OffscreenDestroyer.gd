extends Node2D

@export var left_limit = -100

func _process(_delta):
	if global_position.x < left_limit:
		get_parent().queue_free()
