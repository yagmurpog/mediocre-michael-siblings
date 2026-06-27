extends Node2D

@export var text = "100"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var label: Label


func _ready() -> void:
	label.text = text
	animation_player.play("default")
