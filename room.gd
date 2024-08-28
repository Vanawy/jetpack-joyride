class_name Room
extends Node2D

@onready var end_marker : Marker2D = $End

var speed = 0

@onready var second_tilemap : TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	second_tilemap = $TileMap.duplicate()
	second_tilemap.position = end_marker.position
	add_child.call_deferred(second_tilemap)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(delta):
	if end_marker.global_position.x < 0:
		position.x = end_marker.global_position.x
	position.x -= speed * delta

func set_speed(new_speed : float):
	speed = new_speed
