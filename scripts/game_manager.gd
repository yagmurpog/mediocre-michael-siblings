extends Node2D

const common = preload("res://scripts/library.gd")

@export var first_level: Resource
var loaded_level: Node
var loaded_level_resource: Resource

var loaded_level_theme: common.theme = common.theme.GROUND

var timeRemanining = 300

@onready var mario = %mario
@onready var hud = %HUD
@onready var musicStream: AudioStreamPlayer = $MusicPlayer

var stopEverything: bool = false # KRIS GET THE BANANA ...  potassium

func _ready() -> void:
	show_splash(first_level)


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_H):
		pass

func load_level(level: Resource, spawn_pos = null):
	if loaded_level:
		loaded_level.queue_free()
	
	loaded_level = level.instantiate()
	loaded_level_resource = level
	loaded_level_theme = loaded_level.level_theme
	
	mario.autoMove = loaded_level.autoWalkLevel
		
	play_level_music()

	timeRemanining = loaded_level.levelTime
	hud.update_world(loaded_level.levelName)

	if spawn_pos and spawn_pos != Vector2.ZERO:
		mario.position = spawn_pos
	else:
		mario.position = loaded_level.start_pos

	self.add_child(loaded_level)

func play_music(music: Resource):
	musicStream.stop()
	musicStream.stream = music
	musicStream.play()

func play_level_music():
	play_music(loaded_level.music)


func _on_level_timer_timeout() -> void:
	timeRemanining -= 1
	if timeRemanining == 0:
		mario.die()
	hud.update_time(str(timeRemanining))


func show_splash(level_to_load):
	hud.splash_control.show()
	hud.world_splash_label.text = level_to_load.instantiate().levelName
	hud.lives_splash_label.text = "x " + str(mario.lives)
	await common.wait(self, 1.0)
	hud.splash_control.hide()
	load_level(level_to_load)

func count_score(levelToLoad):
	mario.hide()
	mario.stopZoneReached = true
	await common.wait(self, 4.0)
	
	# do the counting here

	hud.splash_control.show()
	await common.wait(self, 1.0)
	hud.splash_control.hide()
	mario.resetMovement()
	mario.show()
	load_level(levelToLoad)
	pass
