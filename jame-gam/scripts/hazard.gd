extends Area2D

@export var fall_speed: float = 150.0

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	
	if position.y > 200:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Squashed!")
		get_tree().reload_current_scene()
