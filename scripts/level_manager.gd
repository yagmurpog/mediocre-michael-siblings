extends Node

const common = preload("res://scripts/library.gd")

@export var start_pos: Vector2
@export var level_theme: common.theme
@export var music: Resource 
@export var levelTime: int
@export var levelName: String = "my epic level"
@export var autoWalkLevel: bool = false
