extends Node2D

var hazard_scene = preload("res://scenes/hazard.tscn")
@onready var timer: Timer = $Timer

var survival_time: float = 0.0

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	survival_time += delta
	
	# Gradually increase spawn rate as time goes on
	timer.wait_time = max(0.3, 1.2 - (survival_time * 0.02))

func _on_timer_timeout() -> void:
	var hazard = hazard_scene.instantiate()
	
	# Scale hazard speed up over time
	var speed_multiplier = 1.0 + (survival_time * 0.04)
	hazard.fall_speed *= speed_multiplier
	
	# Pick a random X position across the full 1280 width (between 60 and 1220)
	var random_x = randf_range(60.0, 1220.0)
	hazard.position = Vector2(random_x, -50) # Spawn just above the screen
	
	add_child(hazard)
