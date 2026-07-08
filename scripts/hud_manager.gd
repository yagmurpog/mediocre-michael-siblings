extends CanvasLayer

@export var player_label: Label
@export var score_label: Label
@onready var coin_label: Label = $Control/CoinLabel
@onready var time_label: Label = $Control/TimeLabel
@onready var world_label: Label = $Control/WorldLabel


@onready var splash_control: Control = $SplashControl
@onready var world_splash_label: Label = $SplashControl/SplashWorldLabel
@onready var lives_splash_label: Label = $SplashControl/SplashLivesLabel



func _ready() -> void:
	player_label.text = "michael"
	score_label.text = "0"
	pass

func update_score(update_value):
	score_label.text = update_value

func update_coin(update_value):
	coin_label.text = "0"+update_value

func update_time(update_value):
	time_label.text =  "TIME\n"+ update_value 

func update_world(update_value):
	world_label.text =  "WORLD\n"+ update_value 