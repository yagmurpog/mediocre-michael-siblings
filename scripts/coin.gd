extends Node2D

@onready var game_manager: Node = %GameManager
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not isSpawnedByBlock and not isTouched:
		isTouched = true
		game_manager.increase_coin(1,self)
		common.play_audio(self,preload("res://assets/sound/sfx/coin.wav"))
		self.queue_free()
