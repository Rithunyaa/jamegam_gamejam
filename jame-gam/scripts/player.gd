extends CharacterBody2D

@export var speed: float = 600.0 # Faster movement for a wider screen

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	# Clamp player inside the 1280 width (leaving a 50px margin on edges)
	position.x = clamp(position.x, 50, 1230)
