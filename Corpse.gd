extends RigidBody2D
class_name Corpse

signal dropped_dead
var is_dropped_dead = false

@onready var timer = $DroppedDeadTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(func(): 
		dropped_dead.emit()
		is_dropped_dead = true
	)

func _physics_process(_delta):
	if is_dropped_dead:
		return
	if absf(linear_velocity.y) < 0.2:
		if timer.is_stopped():
			timer.start()
	else:
		timer.stop()
