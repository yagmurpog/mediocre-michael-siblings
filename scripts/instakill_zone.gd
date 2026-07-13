extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "mario":
		print(body.position)
		body.die()
	else:
		body.queue_free()