extends CharacterBody2D
extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	# Get left/right input (-1 for left, 1 for right)
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	# Screen clamp (keeps your little guy inside the 320x180 window bounds)
	position.x = clamp(position.x, 16, 304)extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	# Get left/right input (-1 for left, 1 for right)
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	# Screen clamp (keeps your little guy inside the 320x180 window bounds)
	position.x = clamp(position.x, 16, 304)
