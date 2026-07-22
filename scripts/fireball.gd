extends RigidBody2D

@onready var kill_zone: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const common = preload("res://scripts/library.gd")

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.fire_die()
	explode()


func _on_timer_timeout() -> void:
	explode()

func explode():
	kill_zone.disabled = true
	sprite.play("explode")
	await common.wait(self, 0.3)
	queue_free()
