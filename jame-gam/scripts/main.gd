extends Node2D

var hazard_scenes = [
	preload("res://scenes/hazard.tscn"),  
	preload("res://scenes/hazard3.tscn"),
	preload("res://scenes/hazard2.tscn")
]

@onready var timer: Timer = $Timer
@onready var game_over_ui: CanvasLayer = $GameOverUI
@onready var camera: Camera2D = $Camera2D
@onready var crunch_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var background_music: AudioStreamPlayer2D = $AudioStreamPlayer2D2


var survival_time: float = 0.0
var is_game_over: bool = false

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	
	
	background_music.finished.connect(_on_music_finished)
	background_music.play()

func _process(delta: float) -> void:
	if is_game_over:
		return
		
	survival_time += delta
	timer.wait_time = max(0.3, 1.2 - (survival_time * 0.02))

func _on_timer_timeout() -> void:
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
	
	timer.stop()
	
	background_music.stop()
	
	crunch_sound.play()
	
	shake_screen()
	
	game_over_ui.trigger_game_over(survival_time)

func shake_screen() -> void:
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	for i in range(8):
		var random_offset = Vector2(randf_range(-12.0, 12.0), randf_range(-12.0, 12.0))
		tween.tween_property(camera, "offset", random_offset, 0.03)
	
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.03)

func _on_music_finished() -> void:
	background_music.play()
