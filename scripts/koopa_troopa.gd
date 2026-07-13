extends CharacterBody2D

const SPEED = 1500


@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var canDie = true
var direction = 1
var shellOnly = false
var shellMoving = false
var shellSpeedMultiplier = 1

const common = preload("res://scripts/library.gd")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if ray_cast_right.is_colliding():
		direction = -1

	if ray_cast_left.is_colliding():
		direction = 1
		
	if direction > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	velocity.x = SPEED * delta * direction * shellSpeedMultiplier
	
		
	move_and_slide()


func _on_kill_zone_body_entered(body: Node2D) -> void:
	for body2 in $KillZone.get_overlapping_bodies():
		print(body2.get_collision_layer)
		if body2.get_collision_layer() == (1 << 1):
			if (shellMoving and shellOnly) or not shellOnly:
				body.take_damage(self)
					
			else:
				common.play_audio(self, preload("res://assets/sound/sfx/kickkill.wav"))
				direction = sign(body.velocity.x)
				shellMoving = true
				shellSpeedMultiplier = 5

		if body2.get_collision_layer() == (1 << 4) and (shellMoving and shellOnly):
			body2.fire_die()
			print("yup")
		
		
func _on_stomp_zone_body_entered(body: Node2D) -> void:
	print("hi :)")
	if canDie and not shellMoving:
		direction = 0
		body.goomba_stomp(300)
		shellOnly = true
		
		sprite.play("shell")
		collision_shape_2d.position.y = 1.5

		common.play_audio(self, preload("res://assets/sound/sfx/stompswim.wav"))

	if shellMoving and shellOnly:
		common.play_audio(self, preload("res://assets/sound/sfx/kickkill.wav"))
		direction = 0
		shellMoving = false
		body.goomba_stomp(300)
		

func fire_die():
	if canDie:
		shellOnly = true
		velocity.y -= 200
		sprite.scale *= -1
		collision_shape_2d.set_deferred("disabled", true)
		canDie = false
