extends CharacterBody2D

@export var speed: float = 600.0 # Faster movement for a wider screen
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction < 0:
		# Moving Left: Play walk_right animation flipped horizontally
		velocity.x = direction * speed
		animated_sprite.play("walk_right")
		animated_sprite.flip_h = true
	elif direction > 0:
		# Moving Right: Play walk_right animation normally
		velocity.x = direction * speed
		animated_sprite.play("walk_right")
		animated_sprite.flip_h = false
	else:
		# Standing still: Play default animation
		velocity.x = move_toward(velocity.x, 0, speed)
		animated_sprite.play("default")
		animated_sprite.flip_h = false

	move_and_slide()
	
	# Clamp player inside the 1280 width (leaving a 50px margin on edges)
	position.x = clamp(position.x, 50, 1230)
