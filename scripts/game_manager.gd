extends Node


@export var hud: CanvasLayer
@export var mario: CharacterBody2D

@export var levelTime: int
@onready var timeRemanining = levelTime


const score_text_template:Resource = preload("uid://4m3nthogness")

var coins = 0
var score = 0

func increase_coin(amount,caller):
	
	var score_text = score_text_template.instantiate()
	score_text.text = "300"
	score_text.position = caller.position
	add_sibling(score_text)
	coins += amount
	
	hud.update_coin(str(coins))
	increase_score(300)
	

func increase_score(amount):
	score += amount
	hud.update_score(str(score))


func _on_level_timer_timeout() -> void:
	timeRemanining -= 1
	if timeRemanining  <1:
		mario.die()
	hud.update_time(str(timeRemanining))
