extends Node2D

const brickParticles: Resource = preload("uid://mb2bx1rfnovl")

@export var itemInside: Resource
@export var isBrick = false
@export var isInvinsible = false



@onready var game_manager: Node = %GameManager
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

var isHit = false

func _ready() -> void:
	if isBrick:
		sprite.play("brick")
	if isInvinsible:
		sprite.hide()
		collision_shape_2d.set_deferred("disabled",true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not isHit:
		if isInvinsible:
			sprite.show()
			collision_shape_2d.set_deferred("disabled",false)
		
		if itemInside:
			
			var thing = itemInside.instantiate()
			
			if thing.name == "Coin":
				thing.isSpawnedByBlock = true
				game_manager.increase_coin(1,self)
			
			add_sibling(thing)
			thing.position = global_position
			thing.position.y -= 16
			isHit = true
		
		animation_player.play("hit")
			
		if not itemInside and isBrick:
			animation_player.play("brick_hit")
			if body.status > 0:
				timer.start()
				var brickParticle = brickParticles.instantiate()
				brickParticle.emitting = true
				add_sibling(brickParticle)
				brickParticle.position = global_position

func _on_timer_timeout() -> void:
	queue_free()
