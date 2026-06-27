extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_hitbox_body_entered(body: Node2D) -> void:
	body.levelFinish = true
	animation_player.play("flag_down")
	pass
