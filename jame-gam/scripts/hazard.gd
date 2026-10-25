extends Area2D

@export var fall_speed: float = 350.0 # Faster fall speed for 720p

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	
	# Delete if it falls past the bottom of the 720p screen
	if position.y > 800:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Squashed!")
		get_tree().reload_current_scene()
