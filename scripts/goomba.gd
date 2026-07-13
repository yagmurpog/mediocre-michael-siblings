extends CharacterBody2D

const SPEED = 1500
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


const common = preload("res://scripts/library.gd")
@onready var game_manager = common.get_game_manager(self)

var canDie = true
var direction = 1

func _ready() -> void:
	play_animation("default")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if ray_cast_right.is_colliding():
		direction = -1

	if ray_cast_left.is_colliding():
		direction = 1	


	velocity.x = SPEED*delta * direction
	if not game_manager.stopEverything:
		move_and_slide()


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if canDie:
		body.take_damage(self)
	

func _on_stomp_zone_body_entered(body: Node2D) -> void:
	if canDie:
		common.play_audio(self,preload("res://assets/sound/sfx/stompswim.wav"))
		body.goomba_stomp(400)
		animation_player.play("stomp")

func fire_die():
	if canDie:
		common.play_audio(self,preload("res://assets/sound/sfx/kickkill.wav"))
		velocity.y -= 200
		sprite.scale *= -1
		collision_shape_2d.set_deferred("disabled",true)
		canDie = false



func play_animation(anim):
	match anim:
		"default":
			match common.get_theme(self):
				common.theme.GROUND:
					sprite.play("default")
				common.theme.UNDERGROUND:
					sprite.play("default_underground")
		"stomp":
			match common.get_theme(self):
				common.theme.GROUND:
					sprite.play("stomp")
				common.theme.UNDERGROUND:
					sprite.play("stomp_underground")		
