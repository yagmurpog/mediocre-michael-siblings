extends Node2D

const brickParticles: Resource = preload("uid://mb2bx1rfnovl")

@export var itemInside: Resource
@export var isBrick = false
@export var isInvinsible = false


@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var hit_zone: Area2D = $HitZone

const common = preload("res://scripts/library.gd")


var isHit = false

func _ready() -> void:
	setAnimation()
	if isBrick:
		if not itemInside:
			audio_stream_player.stream = preload("res://assets/sound/sfx/bump.wav")
	if isInvinsible:
		sprite.hide()
		collision_shape_2d.set_deferred("disabled", true)
	if itemInside:
		audio_stream_player.stream = preload("res://assets/sound/sfx/item.wav")
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not isHit:
		if not body.is_on_floor():
			hit(body)
	else:
		common.play_audio(self, preload("res://assets/sound/sfx/bump.wav"))
		

func hit(body):
	if isInvinsible:
		sprite.show()
		collision_shape_2d.set_deferred("disabled", false)
		
	for stuff_above in hit_zone.get_overlapping_bodies():
		print(stuff_above.name)
		if stuff_above.get_collision_layer() == (1 << 4) | (1 << 0):
			print("yup	")
			stuff_above.fire_die()
		else:
			stuff_above.velocity.y -= 150

	if itemInside:
		var thing = itemInside.instantiate()
			
		if thing.name == "Coin":
			thing.isSpawnedByBlock = true
			body.increase_coin(1, self)
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
			body.add_score(50, "50")
			audio_stream_player.stream = preload("res://assets/sound/sfx/brick.wav")

			spawn_particles(common.get_theme(self))

			timer.start()
			common.play_audio(self, preload("res://assets/sound/sfx/brick.wav"))
			
			
		audio_stream_player.play()


func _on_timer_timeout() -> void:
	queue_free()
	pass

func spawn_particles(theme: common.theme):
	var brickParticle = brickParticles.instantiate()
	brickParticle.emitting = true

	# sorry for magic numbers :(
	# these point to specific regions in items.png
	match theme:
		common.theme.GROUND:
			brickParticle.texture.region = Rect2(180,26,8,8)
		common.theme.UNDERGROUND:
			brickParticle.texture.region = Rect2(180,134,8,8)
		common.theme.CASTLE:
			brickParticle.texture.region = Rect2(180,242,8,8)


	add_sibling(brickParticle)
	brickParticle.position = global_position


func setAnimation():
	if isBrick:
		match common.get_theme(self):
			common.theme.GROUND:
				sprite.play("brick")
			common.theme.UNDERGROUND:
				sprite.play("brick_underground")

	else:
		match common.get_theme(self):
			common.theme.GROUND:
				sprite.play("default")
			common.theme.UNDERGROUND:
				sprite.play("default_underground")


func drain():
	match common.get_theme(self):
			common.theme.GROUND:
				sprite.play("empty")
			common.theme.UNDERGROUND:
				sprite.play("empty_underground")


func _on_shell_bump_zone_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
