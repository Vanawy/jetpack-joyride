@tool
extends Node2D


@onready var point_a = $AnchorA
@onready var point_b = $AnchorB
@onready var line : Line2D = $Line2D
@onready var collider : CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		update_points()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_points()

func update_points():
	if line:
		line.points[1] = point_b.position
	if collider.shape is SegmentShape2D:
		collider.shape.b = point_b.position
