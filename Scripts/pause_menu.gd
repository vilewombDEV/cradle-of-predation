extends CanvasLayer

signal shown
signal hidden

@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer

@onready var save_button: Button = $Control/TabContainer/System/VBoxContainer/Save
@onready var load_button: Button = $Control/TabContainer/System/VBoxContainer/Load
@onready var main_menu_button: Button = $"Control/TabContainer/System/VBoxContainer/Main Menu"
@onready var quit: Button = $Control/TabContainer/System/VBoxContainer/Quit

@onready var click: AudioStreamPlayer = $Control/Click
@onready var hover: AudioStreamPlayer = $Control/Hover

@onready var item_description: Label = $Control/TabContainer/Inventory/ItemDescription

@onready var tab_container: TabContainer = $Control/TabContainer

var is_paused: bool = false

func _ready() -> void:
	hide_pause_menu()
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		if is_paused == false:
			if DialogSystem.is_active:
				return
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	tab_container.current_tab = 0
	shown.emit()

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()

func _on_save_mouse_entered() -> void:
	hover.play()
func _on_load_mouse_entered() -> void:
	hover.play()
func _on_quit_mouse_entered() -> void:
	hover.play()
func _on_main_menu_mouse_entered() -> void:
	hover.play()
func _on_save_pressed() -> void:
	click.play()
	if is_paused == false:
		return
	SaveManager.save_game()
	hide_pause_menu()

func _on_load_pressed() -> void:
	click.play()
	if is_paused == false:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()

func _on_main_menu_pressed() -> void:
	click.play()
	if is_paused == false:
		return
	AudioManager.play_music(null)
	LevelManager.load_new_level("res://Levels/main_menu.tscn", "", Vector2.ZERO)
	PauseMenu.visible = false
	PauseMenu.PROCESS_MODE_DISABLED

func _on_quit_pressed() -> void:
	click.play()
	await click.finished
	get_tree().quit()

func update_item_description(new_text: String) -> void:
	item_description.text = new_text

func play_sound(audio: AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
