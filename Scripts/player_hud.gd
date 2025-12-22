extends CanvasLayer

@export var button_focus_audio: AudioStream = preload("res://Music & SFX/SFX/hover_pm.wav")
@export var button_select_audio: AudioStream = preload("res://Music & SFX/SFX/click_pm.wav")

var hearts: Array[HeartGUI] = []

#region /// Basic On-Ready References
@onready var game_over: Control = $Control/GameOver
@onready var continue_button: Button = $Control/GameOver/VBoxContainer/Continue
@onready var main_menu_button: Button = $"Control/GameOver/VBoxContainer/Main Menu"
@onready var animation_player: AnimationPlayer = $Control/GameOver/AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var notification: NotificationUI = $Control/Notification
#endregion

#region /// Ability-related On-Ready References
@onready var abilities: Control = $Control/Abilities
@onready var ability_items: HBoxContainer = $Control/Abilities/HBoxContainer
#endregion

func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append(child)
			child.visible = false
	hide_game_over_screen()
	continue_button.focus_entered.connect(play_audio.bind(button_focus_audio))
	continue_button.pressed.connect(load_game)
	main_menu_button.focus_entered.connect(play_audio.bind(button_focus_audio))
	main_menu_button.pressed.connect(title_screen)
	LevelManager.level_load_started.connect(hide_game_over_screen)
	
	update_ability_ui(0)
	PauseMenu.shown.connect(_on_show_pause)
	PauseMenu.hidden.connect(_on_hide_pause)

func update_hp(_hp: int, _max_hp: int) -> void:
	update_max_hp(_max_hp)
	for i in _max_hp:
		update_heart(i, _hp)

func update_heart(_index: int, _hp: int) -> void:
	var _value: int = clampi(_hp - _index * 2, 0, 2)
	hearts[_index].value = _value

func update_max_hp(_max_hp: int) -> void:
	var _heart_count: int = roundi(_max_hp * 0.5)
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false

func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	var can_continue: bool = SaveManager.get_save_file() != null
	continue_button.visible = can_continue
	animation_player.play("show_game_over")
	await animation_player.animation_finished
	if can_continue == true:
		continue_button.grab_focus()
	else:
		main_menu_button.grab_focus()

func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color(1,1,1,0)

func load_game() -> void:
	play_audio(button_select_audio)
	await fade_to_black()
	SaveManager.load_game()

func title_screen() -> void:
	play_audio(button_select_audio)
	await fade_to_black()
	LevelManager.load_new_level("res://Levels/main_menu.tscn", "", Vector2.ZERO)

func fade_to_black() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	PlayerManager.player.revive_player()
	return true

func play_audio(_a: AudioStream) -> void:
	audio.stream = _a
	audio.play()

func queue_notification(_title: String, _message: String) -> void:
	notification.add_notification_to_queue(_title, _message)

func update_ability_items(abilities: Array[String]) -> void:
	var ability_items: Array[Node] = ability_items.get_children()
	for a in ability_items.size():
		if abilities[a] == "":
			ability_items[a].visible = false
		else:
			ability_items[a].visible = true

func update_ability_ui(ability_index: int) ->void:
	var _items: Array[Node] = ability_items.get_children()
	for a in _items:
		a.self_modulate = Color(1, 1, 1)
		a.modulate = Color(0.6, 0.6, 0.8)
	_items[ability_index].self_modulate = Color(1, 1, 1)
	_items[ability_index].modulate = Color(1, 1, 1)
	play_audio(button_focus_audio)

func _on_show_pause() -> void:
	abilities.visible = false

func _on_hide_pause() -> void:
	abilities.visible = true
