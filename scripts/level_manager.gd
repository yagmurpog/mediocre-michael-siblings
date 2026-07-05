extends Node

const common = preload("res://scripts/library.gd")

@export var start_pos: Vector2
@export var level_theme: common.theme

#@export var hud: CanvasLayer
#@onready var mario: Node = %mario

#@export var levelTime: int
#@onready var timeRemanining = levelTime

#func _on_level_timer_timeout() -> void:
#	timeRemanining -= 1
#	if timeRemanining  <1:
#		mario.die()
#	hud.update_time(str(timeRemanining))
