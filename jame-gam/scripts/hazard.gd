extends Area2D

@export var fall_speed: float = 350.0 

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	
	
	if position.y > 800:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var main_node = get_tree().current_scene
		if main_node.has_method("trigger_game_over"):
			main_node.trigger_game_over()
		
		queue_free()
