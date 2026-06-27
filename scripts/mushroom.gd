extends CharacterBody2D

const SPEED = 1200
var direction = 1
var isMoving = false

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_down: RayCast2D = $RayCastDown

func _init() -> void:
	print("mushromd")

func startMoving():
	isMoving = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if ray_cast_right.is_colliding():
		direction = -1

	if ray_cast_left.is_colliding():
		direction = 1	
	if isMoving:
		velocity.x = SPEED*delta * direction
		move_and_slide()
	




func _on_area_2d_body_entered(body: Node2D) -> void:
	body.get_big() # Replace with function body.
	queue_free()
