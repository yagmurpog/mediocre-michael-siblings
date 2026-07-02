extends Node2D

@export var isSpawnedByBlock = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var isTouched = false

const common = preload("res://scripts/library.gd")

func _ready() -> void:
	if isSpawnedByBlock:
		audio_stream_player.play()
		animated_sprite_2d.play("block")
		animation_player.play("block")
	else:
		setAnimation()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not isSpawnedByBlock and not isTouched:
		isTouched = true
		body.increase_coin(1,self)
		common.play_audio(self,preload("res://assets/sound/sfx/coin.wav"))
		self.queue_free()


func setAnimation():
	match get_node("/root/Level").level_theme:
		common.theme.GROUND:
			animated_sprite_2d.play("default")
		common.theme.UNDERGROUND:
			animated_sprite_2d.play("default_underground")
