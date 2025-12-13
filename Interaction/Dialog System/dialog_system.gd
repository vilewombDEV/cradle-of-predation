extends CanvasLayer
class_name DialogSystemNode

signal finished
signal letter_added(letter: String)

var is_active: bool = false
var text_in_progress: bool = false
var waiting_for_choice: bool = false

var text_speed: float = 0.02
var text_length: int = 0
var plain_text: String

var dialog_items: Array[DialogItem]
var dialog_item_index: int = 0

@onready var dialog_ui: Control = $DialogUI
@onready var content: RichTextLabel = $DialogUI/PanelContainer/RichTextLabel
@onready var name_label: Label = $DialogUI/NameLabel
@onready var portrait_sprite: Sprite2D = $DialogUI/PortraitSprite
@onready var dialog_progress_bar: PanelContainer = $DialogUI/DialogProgressBar
@onready var dialog_progress_bar_label: Label = $DialogUI/DialogProgressBar/NEXT
@onready var timer: Timer = $DialogUI/Timer
@onready var default_text_sound: AudioStreamPlayer = $DialogUI/AudioStreamPlayer
@onready var choice_options: VBoxContainer = $DialogUI/VBoxContainer



func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	timer.timeout.connect(on_timer_timeout)
	hide_dialog()

#Handle key presses, but only if Dialog System is active
func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	if event.is_action_pressed("advance_dialog"):
		if text_in_progress == true:
			content.visible_characters = text_length
			timer.stop()
			text_in_progress = false
			show_dialog_button_indicator(true)
			return
		elif waiting_for_choice == true:
			return
		
		dialog_item_index += 1
		if dialog_item_index < dialog_items.size():
			start_dialog()
		else:
			hide_dialog()
	pass

func show_dialog(items: Array[DialogItem]) -> void:
	is_active = true
	dialog_ui.visible = true
	dialog_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialog_items = items
	dialog_item_index = 0
	get_tree().paused = true
	await get_tree().process_frame
	if dialog_items.size() == 0:
		hide_dialog()
	else:
		start_dialog()


#Hide Dialoug System UI
func hide_dialog() -> void:
	is_active = false
	choice_options.visible = false
	dialog_ui.visible = false
	dialog_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()


#Initialize UI variables for a new Dialog Interaction
func start_dialog() -> void:
	waiting_for_choice = false
	show_dialog_button_indicator(false)
	var _d: DialogItem = dialog_items[dialog_item_index]
	
	if _d is DialogText:
		set_dialog_text(_d as DialogText)
	elif _d is DialogChoice:
		set_dialog_choice(_d as DialogChoice)



## Set dialog and NPC variables, etc based on dialog item parameters.
## Once set, start text typing timer.
func set_dialog_text(_d: DialogText) -> void:
	if _d is DialogText:
		content.text = _d.text
		name_label.text = _d.npc_info.npc_name
		portrait_sprite.texture = _d.npc_info.portrait
		content.visible_characters = 0
		text_length = content.get_total_character_count()
		plain_text = content.get_parsed_text()
		text_in_progress = true
		start_timer()

#Set dialog choice UI based on parameters
func set_dialog_choice(_d: DialogChoice) -> void:
	choice_options.visible = true
	waiting_for_choice = true
	for c in choice_options.get_children():
		c.queue_free()
	
	for i in _d.dialog_branches.size():
		var _new_choice: Button = Button.new()
		_new_choice.text = _d.dialog_branches[i].text
		_new_choice.alignment = HORIZONTAL_ALIGNMENT_LEFT
		_new_choice.pressed.connect(_dialog_choice_selected.bind(_d.dialog_branches[i]))
		choice_options.add_child(_new_choice)
		
	await get_tree().process_frame
	choice_options.get_child(0).grab_focus()
	pass

func _dialog_choice_selected(_d: DialogBranch) -> void:
	choice_options.visible = false
	_d.selected.emit()
	show_dialog(_d.dialog_items)
	pass

func on_timer_timeout() -> void:
	content.visible_characters += 1
	if content.visible_characters <= text_length:
		default_text_sound.play()
		start_timer()
	else:
		show_dialog_button_indicator(true)
		text_in_progress = false

func start_timer() -> void:
	timer.wait_time = text_speed
	#Manipulate wait_time
	timer.start()


func show_dialog_button_indicator(_is_visible: bool) -> void:
	dialog_progress_bar.visible = _is_visible
	if dialog_item_index + 1 < dialog_items.size():
		dialog_progress_bar_label.text = "NEXT"
	else:
		dialog_progress_bar_label.text = "END"
