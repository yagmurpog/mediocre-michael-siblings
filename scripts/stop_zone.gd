extends Area2D

const common = preload("res://scripts/library.gd")
@onready var game_manager = common.get_game_manager(self)
@onready var level_manager = common.get_level_manager(self)
@export var next_level: Resource

func _on_body_entered(body: Node2D) -> void:
	if next_level:
		game_manager.count_score(next_level)
