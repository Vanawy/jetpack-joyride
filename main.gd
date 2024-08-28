extends Node2D

@export var default_speed = 64;
@export var max_speed = 128;

var speed = default_speed;
var acceleration = 2;
var speed_damping = 0.85

const M_TO_PX_RATIO = 1.0 / 32.0;
var meters_traveled = 0

var is_game_over = false;
var is_game_started = false;

@onready var corpse_scene = preload("res://corpse.tscn")

@onready var room : Room = $Room
@onready var obstacles_parent : ObstaclesParent = $MovingObstaclesParent
@onready var debug_label = $DebugLabel
@onready var player : Bird = $Player
@onready var obstacle_manager : ObstacleManager = $ObstacleManager
@onready var score_manager : ScoreManager = $ScoreManager

var score = 0
var best_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player.death.connect(spawn_corpse)
	best_score = score_manager.pb_score
	
func _physics_process(delta):
	if !is_game_started:
		return
		
	if !is_game_over:
		speed = clampf(speed, 0, max_speed)
		speed += acceleration * delta
		meters_traveled += delta * speed * M_TO_PX_RATIO;
		
	room.set_speed(speed)
	obstacles_parent.set_speed(speed)
	obstacle_manager.difficulty_scale = speed / default_speed
	obstacle_manager.game_score = meters_traveled

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	score = round(meters_traveled)
	debug_label.text = "m:" + str(score)
	update_gui()
	#debug_label.text += "\ns:" + str(round(speed))
	
	if Input.is_action_just_pressed("debug_reload"):
		restart_game()
		
	if score > best_score:
		best_score = score

	if Input.is_action_just_pressed("ui_accept"):
		if !is_game_started:
			start_game()
		if is_game_over:
			restart_game()
		

func update_gui():
	$Score/Value.text = str(score)
	$BestScore/Value.text = str(best_score)

func game_over():
	speed = 0
	is_game_over = true
	print("game over")
	score_manager.update_score(round(meters_traveled))
	best_score = score_manager.pb_score
	$RestartText.visible = true

func start_game():
	player.start()
	is_game_started = true
	
func restart_game():
	get_tree().reload_current_scene()
	
func spawn_corpse():
	var corpse = corpse_scene.instantiate() as Corpse
	add_child.call_deferred(corpse)
	corpse.global_position = player.global_position
	corpse.linear_velocity = player.velocity
	
	corpse.dropped_dead.connect(game_over)
	corpse.body_entered.connect(func(_body: Node):
		speed *= speed_damping
	)
