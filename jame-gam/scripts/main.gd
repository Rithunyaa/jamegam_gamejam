extends Node2D

# Array of your hazard scene versions so it can randomize between them
var hazard_scenes = [
	preload("res://scenes/hazard.tscn"),  # Your first hazard (e.g., pushpin)
	preload("res://scenes/hazard3.tscn"),
	preload("res://scenes/hazard2.tscn")
]

@onready var timer: Timer = $Timer
@onready var game_over_ui: CanvasLayer = $GameOverUI # Make sure node name matches
@onready var camera: Camera2D = $Camera2D # Reference to your Camera2D node

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
	
	# Trigger the screen shake effect when squashed
	shake_screen()
	
	# Trigger the fade screen and score UI
	game_over_ui.trigger_game_over(survival_time)

func shake_screen() -> void:
	# Create a tween that keeps running even when the game tree is paused
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# Rapidly jitter the camera offset back and forth for impact
	for i in range(8):
		var random_offset = Vector2(randf_range(-12.0, 12.0), randf_range(-12.0, 12.0))
		tween.tween_property(camera, "offset", random_offset, 0.03)
	
	# Snap the camera back to center when done
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.03)
