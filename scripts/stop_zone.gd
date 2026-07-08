extends Area2D

const common = preload("res://scripts/library.gd")
@onready var game_manager = common.get_game_manager(self)
@onready var level_manager = common.get_level_manager(self)


func _on_body_entered(body: Node2D) -> void:
	if level_manager.next_level:
		print("hello :) ")
		game_manager.count_score(level_manager.next_level)
