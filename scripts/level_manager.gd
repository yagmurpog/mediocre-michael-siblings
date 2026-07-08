extends Node

const common = preload("res://scripts/library.gd")

@export var start_pos: Vector2
@export var next_level: Resource
@export var level_theme: common.theme
@export var levelTime: int
@export var levelName: String = "my epic level"
@export var autoWalkLevel: bool = false

@onready var music: AudioStreamPlayer = $MusicPlayer