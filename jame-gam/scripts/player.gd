extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	position.x = clamp(position.x, 16, 304)
