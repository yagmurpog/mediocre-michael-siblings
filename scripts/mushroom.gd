extends CharacterBody2D

const SPEED = 1800
var direction = 1
var isMoving = false

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var sprite: Sprite2D = $Sprite

@export var isOneUp: bool = false
@export var oneUp: Texture

const common = preload("res://scripts/library.gd")
@onready var game_manager = common.get_game_manager(self)
func _ready() -> void:
	if isOneUp:
		sprite.texture = oneUp
	print("mushromd")

func startMoving():
	isMoving = true

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if ray_cast_right.is_colliding():
		direction = -1

	if ray_cast_left.is_colliding():
		direction = 1	
	if isMoving and not game_manager.stopEverything:
		velocity.x = SPEED*delta * direction
		move_and_slide()
	




func _on_area_2d_body_entered(body: Node2D) -> void:
	if isOneUp:
		common.play_audio(self,preload("res://assets/sound/sfx/1up.wav"))
		body.lives += 1
	else:
		body.get_big()
	
	queue_free()
