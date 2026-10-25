extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var menu_container: Control = $MenuContainer
@onready var message_label: RichTextLabel = $MenuContainer/MessageLabel # Adjust path if your node path differs
@onready var new_record_label: RichTextLabel = $MenuContainer/NewRecordLabel # The new record label
@onready var try_again_button: Button = $MenuContainer/TryAgainButton

const SAVE_PATH = "user://highscore.save"

func _ready() -> void:
	# Ensure this UI processes even when the game tree is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Hide menu and make the white fade screen invisible at start
	menu_container.visible = false
	color_rect.modulate.a = 0.0
	
	if try_again_button:
		try_again_button.pressed.connect(_on_try_again_pressed)

func trigger_game_over(survived_time: float) -> void:
	# Pause the game so hazards stop moving
	get_tree().paused = true
	
	# Load previous high score and check if it's beaten
	var high_score = load_high_score()
	if survived_time > high_score:
		high_score = survived_time
		save_high_score(high_score)
		if new_record_label:
			new_record_label.visible = true
			new_record_label.text = "New Record!"
			# Force text color to be visible against the white background (e.g., dark red or black)
			new_record_label.add_theme_color_override("default_color", Color(0.8, 0.1, 0.1))
	else:
		if new_record_label:
			new_record_label.visible = false
	
	# Only display the current time survived
	if message_label:
		message_label.text = "You have died.\nTime Survived: " + String.num(survived_time, 2) + "s"
		# Force message label color to black so it's readable on white
		message_label.add_theme_color_override("default_color", Color(0, 0, 0))
	
	# Show container and fade screen to white
	menu_container.visible = true
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.0)

func _on_try_again_pressed() -> void:
	# Unpause the game tree FIRST
	get_tree().paused = false
	
	# Reload your main scene
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
