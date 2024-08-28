class_name Bird
extends CharacterBody2D

signal death

@export var JUMP_VELOCITY = -90.0

var last_jump_time : int = 0
@export var jump_animation_delay : int = 150
@onready var character_animator : AnimatedSprite2D = $CharacterSprite
@onready var bubble_animator : AnimatedSprite2D = $BubbleSprite
#@onready var audio_jump = $JumpPlayer

@onready var player_hitbox : Area2D = $Hitbox

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 350

var started = false

var action = "ui_accept"

func _ready():
	player_hitbox.body_entered.connect(player_collision)

func start():
	started = true
	character_animator.play("fly")
	bubble_animator.play("fly")

func  _process(_delta):
	if is_on_floor():
		character_animator.play("run")

func player_collision(_body : Node2D):
	kill_player()

func kill_player():
	death.emit()
	queue_free()
	
func _physics_process(delta):
	if !started:
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed(action):
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed(action):
		character_animator.play("fly")
		bubble_animator.play("fly")
		
	if Input.is_action_just_released(action):
		character_animator.play("fall")
		bubble_animator.play("pop")
	
	if Input.is_action_just_pressed("debug_kill"):
		kill_player()

	move_and_slide()
