extends Area2D

const common = preload("res://scripts/library.gd")
@onready var game_manager = common.get_game_manager(self)

func _on_body_entered(body: Node2D) -> void:
	print("hello :) ")
	game_manager.load_level(preload("res://scenes/levels/1-2.tscn"))
	body.flagpoleEndReached = false
	body.levelFinish = false
