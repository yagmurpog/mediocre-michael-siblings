extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const common = preload("res://scripts/library.gd")

func _on_hitbox_body_entered(body: Node2D) -> void:
	body.levelFinish = true
	animation_player.play("flag_down")
	common.play_audio(self,preload("res://assets/sound/sfx/flagpole.wav"))
