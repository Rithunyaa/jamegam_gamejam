extends CharacterBody2D

@export var speed: float = 600.0 
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction < 0:
		velocity.x = direction * speed
		animated_sprite.play("walk_right")
		animated_sprite.flip_h = true
	elif direction > 0:
		velocity.x = direction * speed
		animated_sprite.play("walk_right")
		animated_sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		animated_sprite.play("default")
		animated_sprite.flip_h = false

	move_and_slide()

	position.x = clamp(position.x, 50, 1230)
