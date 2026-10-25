extends Node2D

# Array of your hazard scene versions so it can randomize between them
var hazard_scenes = [
	preload("res://scenes/hazard.tscn"),  # Your first hazard (e.g., pushpin)
	preload("res://scenes/hazard2.tscn") # Make sure this matches your second hazard scene file path
]

@onready var timer: Timer = $Timer
@onready var game_over_ui: CanvasLayer = $GameOverUI # Make sure node name matches

var survival_time: float = 0.0
var is_game_over: bool = false

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	if is_game_over:
		return
		
	survival_time += delta
	timer.wait_time = max(0.3, 1.2 - (survival_time * 0.02))

func _on_timer_timeout() -> void:
	# Randomly pick one of the hazard scenes from the array
	var random_hazard_scene = hazard_scenes.pick_random()
	var hazard = random_hazard_scene.instantiate()
	
	var speed_multiplier = 1.0 + (survival_time * 0.04)
	hazard.fall_speed *= speed_multiplier
	
	var random_x = randf_range(60.0, 1220.0)
	hazard.position = Vector2(random_x, -50)
	add_child(hazard)

func trigger_game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	
	# Stop the spawner timer
	timer.stop()
	
	# Trigger the fade screen and score UI
	game_over_ui.trigger_game_over(survival_time)
