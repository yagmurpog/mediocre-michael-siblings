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
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const common = preload("res://scripts/library.gd")


var isHit = false

func _ready() -> void:
	
	if isBrick:
		sprite.play("brick")
		if not itemInside:
			audio_stream_player.stream = preload("res://assets/sound/sfx/bump.wav")
	if isInvinsible:
		sprite.hide()
		collision_shape_2d.set_deferred("disabled",true)
	if itemInside:
		audio_stream_player.stream = preload("res://assets/sound/sfx/item.wav")
	

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
				audio_stream_player.stream = preload("res://assets/sound/sfx/bump.wav")
			
			add_sibling(thing)
			thing.position = global_position
			thing.position.y -= 16
			isHit = true
		
			animation_player.play("hit")
			audio_stream_player.play()

		if not itemInside and isBrick:
			audio_stream_player.stream = preload("res://assets/sound/sfx/bump.wav")
			animation_player.play("brick_hit")
			if body.status > 0:
				audio_stream_player.stream = preload("res://assets/sound/sfx/brick.wav")


				timer.start()
				common.play_audio(self,preload("res://assets/sound/sfx/brick.wav"))
			
				var brickParticle = brickParticles.instantiate()
				brickParticle.emitting = true
				add_sibling(brickParticle)
				brickParticle.position = global_position
			audio_stream_player.play()
	else:
		common.play_audio(self,preload("res://assets/sound/sfx/bump.wav"))
		
func _on_timer_timeout() -> void:
	queue_free()
	pass