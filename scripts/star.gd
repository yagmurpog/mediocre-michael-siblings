extends CharacterBody2D

const common = preload("res://scripts/library.gd")

const SPEED = 5000
var isMoving = false
var direction = 1

@onready var game_manager = common.get_game_manager(self)
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight

func _physics_process(delta: float) -> void:
	
	# jumpy :D
	if is_on_floor():
		velocity.y-= 16000 * delta
	else:
		velocity += get_gravity()/2 * delta

	if not is_on_floor():
		velocity += get_gravity() * delta
	if ray_cast_right.is_colliding():
		direction = -1

	if ray_cast_left.is_colliding():
		direction = 1	
	if isMoving and not game_manager.stopEverything:
		velocity.x = SPEED*delta * direction


	if isMoving and not game_manager.stopEverything:
		velocity.x = SPEED * delta * direction
		move_and_slide()

func startMoving():
	isMoving = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	game_manager.play_music(preload("res://assets/sound/music/5.ogg"))
	common.play_audio(self, preload("res://assets/sound/sfx/powerup.wav"))

	body.hasStar = true
	body.star_timer.start()
	body.animation_player.play("rainbow")
	body.add_score(1000,"1000")

	self.queue_free()
