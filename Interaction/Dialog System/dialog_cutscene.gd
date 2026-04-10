@tool
extends DialogItem
class_name DialogCutscene

signal finished

enum Mode {PARALLEL, SEQUENTIAL}
@export var playback_mode: Mode = Mode.SEQUENTIAL

var actions: Array[CutsceneAction] = []
var actions_finished_count: int = 0

func _ready() -> void:
	gather_actions()

func gather_actions() -> void:
	for c in get_children():
		if c is CutsceneAction:
			actions.append(c)
			if Engine.is_editor_hint() == false:
				c.finished.connect(_on_action_finished)

func play() -> void:
	if Engine.is_editor_hint():
		return
	actions_finished_count = 0
	if actions.size() == 0:
		await get_tree().process_frame
		finished.emit()
	elif playback_mode == Mode.SEQUENTIAL:
		actions[0].play()
	else:
		for a in actions:
			a.play()

func _on_action_finished() -> void:
	actions_finished_count += 1
	if actions_finished_count >= actions.size():
		finished.emit()
	elif playback_mode == Mode.SEQUENTIAL:
		actions[actions_finished_count].play()
