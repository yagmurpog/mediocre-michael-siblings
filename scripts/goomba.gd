extends CharacterBody2D

const SPEED = 1500
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var canDie = true
var direction = 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if ray_cast_right.is_colliding():
		direction = -1

	if ray_cast_left.is_colliding():
		direction = 1	
	velocity.x = SPEED*delta * direction
	
	move_and_slide()


func _on_kill_zone_body_entered(body: Node2D) -> void:
	body.take_damage()
	

func _on_stomp_zone_body_entered(body: Node2D) -> void:
	if canDie:
		body.goomba_stomp()
		animation_player.play("stomp")

func fire_die():
	if canDie:
		animation_player.play("fire_die")
		velocity.y -= 200
		sprite.scale *= -1
		collision_shape_2d.set_deferred("disabled",true)
		canDie = false
