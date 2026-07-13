extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const common = preload("res://scripts/library.gd")

func _on_hitbox_body_entered(body: Node2D) -> void:
	body.autoMove = true
	animation_player.play("flag_down")
	common.get_game_manager(self).musicStream.stop()
	common.play_audio(self,preload("res://assets/sound/sfx/flagpole.wav"))
	await common.wait(self,1.3)
	common.play_audio(self,preload("res://assets/sound/music/6.ogg"))
	
