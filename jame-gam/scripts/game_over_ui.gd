extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var menu_container: Control = $MenuContainer
@onready var message_label: RichTextLabel = $MenuContainer/MessageLabel 
@onready var new_record_label: RichTextLabel = $MenuContainer/NewRecordLabel 
@onready var try_again_button: Button = $MenuContainer/TryAgainButton

const SAVE_PATH = "user://highscore.save"

func _ready() -> void:
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
	menu_container.visible = false
	color_rect.modulate.a = 0.0
	
	if try_again_button:
		try_again_button.pressed.connect(_on_try_again_pressed)

func trigger_game_over(survived_time: float) -> void:
	
	get_tree().paused = true
	
	
	var high_score = load_high_score()
	if survived_time > high_score:
		high_score = survived_time
		save_high_score(high_score)
		if new_record_label:
			new_record_label.visible = true
			new_record_label.text = "New Record!"
			new_record_label.add_theme_color_override("default_color", Color(0.58, 0.056, 0.058, 1.0))
	else:
		if new_record_label:
			new_record_label.visible = false
	
	
	if message_label:
		message_label.text = "You have died.\nTime Survived: " + String.num(survived_time, 2) + "s"
		
		message_label.add_theme_color_override("default_color", Color(0.027, 0.027, 0.027, 1.0))
	
	
	menu_container.visible = true
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.0)

func _on_try_again_pressed() -> void:
	
	get_tree().paused = false
	
	
	get_tree().change_scene_to_file("res://scenes/levelone.tscn")

func save_high_score(score: float) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_float(score)

func load_high_score() -> float:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			return file.get_float()
	return 0.0
