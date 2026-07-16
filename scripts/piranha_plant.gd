extends CharacterBody2D

var canDie = true

const common = preload("res://scripts/library.gd")

@onready var sprite: AnimatedSprite2D = $Node2D/AnimatedSprite2D
@onready var kill_shape: CollisionShape2D = $Node2D/KillZone/CollisionShape2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var blockageCheck: Area2D = $Node2D/BlockageCheck

var inPipe = true


func fire_die():
	if canDie:
		common.play_audio(self,preload("res://assets/sound/sfx/kickkill.wav"))
		velocity.y -= 200
		sprite.scale *= -1
		kill_shape.set_deferred("disabled",true)
		canDie = false
	


func _physics_process(delta: float) -> void:
	move_and_slide()
	if not canDie:
		velocity += get_gravity() * delta


func _on_kill_zone_body_entered(body: Node2D) -> void:
	body.take_damage(self)


func _on_timer_timeout() -> void:
	if not blockageCheck.get_overlapping_bodies():
		if inPipe:
			animation.play("disappear")
		else:
			animation.play("appear")
	
		inPipe = not inPipe
	timer.start()
