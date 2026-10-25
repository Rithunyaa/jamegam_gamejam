extends Area2D

@export var fall_speed: float = 350.0 # Faster fall speed for 720p

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	
	# Delete if it falls past the bottom of the 720p screen
	if position.y > 800:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Find the Main node in the scene tree and call game over
		var main_node = get_tree().current_scene
		if main_node.has_method("trigger_game_over"):
			main_node.trigger_game_over()
		
		# Remove the hazard safely
		queue_free()
