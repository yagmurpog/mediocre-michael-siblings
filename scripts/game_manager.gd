extends Node2D

const common = preload("res://scripts/library.gd")

@export var first_level: Resource
var loaded_level: Node
var loaded_level_theme: common.theme = common.theme.GROUND

var timeRemanining = 300

@onready var mario = %mario
@onready var hud = %HUD

var stopEverything:bool = false #KRIS GET THE BANANA ...  potassium 

func _ready() -> void:
	load_level(first_level)


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_H):
		load_level(preload("res://scenes/levels/1-1.tscn"), Vector2(120, -50))

func load_level(level: Resource, spawn_pos = null):
	if loaded_level:
		loaded_level.queue_free()
	
	loaded_level = level.instantiate()
	loaded_level_theme = loaded_level.level_theme

	timeRemanining = loaded_level.levelTime
	hud.update_world(loaded_level.levelName)

	if spawn_pos:
		%mario.position = spawn_pos
	else:
		%mario.position = loaded_level.start_pos

	self.add_child(loaded_level)


func _on_level_timer_timeout() -> void:
	timeRemanining -= 1
	if timeRemanining < 1:
		mario.die()
	hud.update_time(str(timeRemanining))
