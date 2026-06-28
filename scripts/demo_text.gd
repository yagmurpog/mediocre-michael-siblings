extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func start_text():
	animation_player.play("new_animation")