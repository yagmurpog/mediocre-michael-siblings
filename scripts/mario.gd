extends CharacterBody2D

const MAX_SPEED = 130.0
const score_text_template: Resource = preload("uid://4m3nthogness")
const fireball: Resource = preload("uid://bbvkd41rgv2lb")


const JUMP_SFX = preload("res://assets/sound/sfx/jump.wav")

const common = preload("res://scripts/library.gd")

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var hud: CanvasLayer


var default_collision_shape: RectangleShape2D


#movement stuff
@export var accel = 100
var deAccel = 400
var isAccelPositive = 1
var speedMultiplier = 0
var speed = 0
var facingRight = 1


#player status
var dead = false
var canJump = false
var tempInvincible = false
var status = 0 # 0 smol, 1 big, #2 fire
var suspendAnimations = false
var coins = 0
var score = 0
@export var lives = 3

# level stuff
@export var currentLevel = 0


# level end stuff
var levelFinish: bool = false
var flagpoleEndReached: bool = false
var stopZoneReached: bool = false

var jump_modifier: float


func _physics_process(delta: float) -> void:
	if not dead:
		if (not is_on_floor() and not levelFinish):

			jump_modifier = 0.5 if Input.is_action_pressed("jump") and isJumping else 1.0

			velocity += get_gravity() * delta * jump_modifier
			
			
		if levelFinish:
			velocity = Vector2.ZERO
			if not flagpoleEndReached:
				play_animation("hold")
			if not is_on_floor():
				velocity += get_gravity() * 5 * delta
			else:
				flagpoleEndReached = true
				if not stopZoneReached:
					auto_move(delta)
		else:
			jump(delta)
			move(delta)
		
		#run
		if Input.is_action_pressed("run"):
			speedMultiplier = 1.5
			sprite.speed_scale = 1.8
		else:
			sprite.speed_scale = 1
			speedMultiplier = 1

		if Input.is_action_just_pressed("attack") and status == 2:
			cast_fireball()

		
		move_and_slide()
	

func cast_fireball():
		var spawned_fireball = fireball.instantiate()
		spawned_fireball.position = global_position
		spawned_fireball.linear_velocity.x = spawned_fireball.linear_velocity.x * facingRight + velocity.x
		spawned_fireball.position.y -= 20
		add_sibling(spawned_fireball)


func take_damage():
	if tempInvincible:
		print("incinvle")
	else:
		tempInvincible = true
		timer.start()


		if status == 0 and not dead:
			die()
		if status == 1:
			status = 0
			sprite.offset.y = 0
			var shap = RectangleShape2D.new()
			shap.size = Vector2(12, 14)
			collision_shape_2d.position.y = -8
			collision_shape_2d.shape = shap
			collision_shape_2d.position.y = 1
			position.y -= 32
		if status == 2:
			status -= 1

func die():
	status = 0
	dead = true
	play_animation("die")
	animation_player.play("die")

	audio_stream_player.stream = preload("res://assets/sound/sfx/death.wav")
	audio_stream_player.play()

	lives -= 1
	await common.wait(self, 2.8)
	get_tree().reload_current_scene()
		
func get_big():
	add_score(1000, "lmao")

	if status < 2:
		status = 1
	else:
		return
	var shap = RectangleShape2D.new()
	shap.size = Vector2(12, 30)
	collision_shape_2d.position.y = -8
	collision_shape_2d.shape = shap
	
	common.play_audio(self, preload("res://assets/sound/sfx/powerup.wav"))
	

	sprite.offset.y = -8

	sprite.play("get_big")
	suspendAnimations = true
	await common.wait(self, 0.5)
	suspendAnimations = false
	
	
func fire_up():
	if status == 0:
		get_big()
	status = 2
	add_score(1000, "lmao")
	
	
func goomba_stomp(vel):
	velocity.y = - vel
	add_score(100, "smoked")

# very jank
func play_animation(animationName):
	if not suspendAnimations:
		match status:
			0: # small
				match animationName:
					"idle":
						sprite.play("idle")
					"run":
						sprite.play("run")
					"die":
						sprite.play("die")
					"get_big":
						sprite.play("get_big")
					"turn_around":
						sprite.play("turn_around")
					"jump":
						sprite.play("jump")
					"hold":
						sprite.play("hold")

			1: # big
				match animationName:
					"idle":
						sprite.play("big_idle")
					"run":
						sprite.play("big_run")
					"turn_around":
						sprite.play("big_turn_around")
					"jump":
						sprite.play("big_jump")
					"hold":
						sprite.play("big_hold")
			2: # fire
				match animationName:
					"idle":
						sprite.play("fire_idle")
					"run":
						sprite.play("fire_run")
					"turn_around":
						sprite.play("fire_turn_around")
					"jump":
						sprite.play("fire_jump")
					"hold":
						sprite.play("fire_hold")

func play_audio(sound_name):
	match sound_name:
		"jump":
			audio_stream_player.stream = JUMP_SFX
	audio_stream_player.play()
	

var isJumping = false


func jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= 15000 * delta
		isJumping = true
		common.play_audio(self,preload("res://assets/sound/sfx/jump.wav"))


func _input(event: InputEvent) -> void:
	if event.is_action_released("jump"):
		isJumping = false


func move(delta):
		var direction := Input.get_axis("left", "right")
		
		#speed penalty when changing directions
		if direction != 0:
			if direction * speed < 0:
				speed = 0


			speed = clampf(speed + accel * speedMultiplier * delta * direction, -MAX_SPEED * speedMultiplier, MAX_SPEED * speedMultiplier)
			velocity.x = speed
			if is_on_floor():
				play_animation("run")
			else:
				play_animation("jump")
		else:
			speed = clampf((abs(speed) - deAccel * delta), 0, 999999999) * isAccelPositive
			velocity.x = speed
			if is_on_floor():
				play_animation("idle")
			else:
				play_animation("jump")
		if direction < 0:
			sprite.flip_h = true
			facingRight = -1
			isAccelPositive = -1
		if direction > 0:
			isAccelPositive = 1
			facingRight = 1
			sprite.flip_h = false

## automatically move player to the right, used for cutscenes		
func auto_move(delta):
	play_animation("run")
	velocity.x = 2000 * delta


## display a text where the player is
func add_score(amount, text):
	var score_text = score_text_template.instantiate()
	score_text.text = text
	score_text.position = position
	add_sibling(score_text)
	increase_score(amount)
	
func increase_score(amount):
	score += amount
	hud.update_score(str(score))

func increase_coin(amount, caller):
	var score_text = score_text_template.instantiate()
	score_text.text = "300"
	score_text.position = caller.position
	add_sibling(score_text)
	coins += amount
	
	hud.update_coin(str(coins))
	increase_score(300)
	

func _on_timer_timeout() -> void:
	tempInvincible = false
