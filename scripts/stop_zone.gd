extends Area2D

@export var demo_text: Control

func _on_body_entered(body: Node2D) -> void:
	print("hello :) ")
	demo_text.start_text()
	body.stopZoneReached = true
