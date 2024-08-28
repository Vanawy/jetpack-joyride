extends Node
class_name ObstacleManager


@onready var moving_obstacles_parent = %MovingObstaclesParent
@onready var static_obstacles_parent = %StaticObstaclesParent

@onready var obstacles = [
	{
		"cost": 4,
		"scenes": [
			preload("res://obstacles/lasers/laser_0.tscn"),
			preload("res://obstacles/lasers/laser_1.tscn"),
			preload("res://obstacles/lasers/laser_2.tscn"),
			preload("res://obstacles/lasers/laser_3.tscn"),
			preload("res://obstacles/lasers/rotation_laser_0.tscn"),
		],
		"lambda": spawn_obstacle
	},
	{
		"cost": 7,
		"scenes": [
			preload("res://obstacles/lasers/long_laser_0.tscn"),
		],
		"lambda": spawn_obstacle
	},
	{
		"cost": 2,
		"lambda": spawn_spikes
	},
	]

@onready var spikes_scene = preload("res://obstacles/spikes.tscn")
@onready var spike_top_spawn = $TopSpikesSpawn
@onready var spike_bot_spawn = $BottomSpikesSpawn
@onready var obstacles_spawn = $ObstaclesSpawn

var game_score = 0
var difficulty_scale = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

var last_obstacle_score = 0
@onready var next_obstacle = obstacles[randi() % obstacles.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_score > last_obstacle_score + next_obstacle['cost']:
		last_obstacle_score = game_score
		next_obstacle = obstacles[randi() % obstacles.size()]
		next_obstacle['lambda'].call()
		
		
func spawn_obstacle():
	var scene = next_obstacle["scenes"][randi() % next_obstacle["scenes"].size()] as PackedScene
	var obs = scene.instantiate() as Node2D
	moving_obstacles_parent.add_child(obs)
	obs.global_position = Vector2(
		obstacles_spawn.position.x, 
		obstacles_spawn.position.y + randi_range(-48, 48)
	)
		
	#
#func remove_obstacles():
	#var obstacles = moving_obstacles_parent.get_children()
	#obstacles.append_array(static_obstacles_parent.get_children())
	#
	#for obstacle in obstacles:
		#obstacle.queue_free()

func update_timer(timer : Timer, default_cd: float):
	if difficulty_scale == 0:
		timer.stop()
	else:
		timer.wait_time = default_cd / difficulty_scale

func spawn_spikes():	
	var spikes = spikes_scene.instantiate() as Node2D
	moving_obstacles_parent.add_child(spikes)
	
	if(randi_range(0, 1)):
		spikes.global_position = spike_bot_spawn.global_position
	else:
		spikes.global_position = spike_top_spawn.global_position
		spikes.rotation = PI
