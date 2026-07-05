extends Area2D

@export var connecting_level: Resource
@export var starting_position: Vector2


func _on_body_entered(body: Node2D) -> void:
	body.get_tree().root.get_child(0).load_level(connecting_level, starting_position if not Vector2.ZERO else null)
	self.queue_free()
