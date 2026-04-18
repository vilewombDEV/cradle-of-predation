extends PlayerState
class_name PlayerStateCutscene

func init() -> void:
	DialogSystem.started.connect(_on_dialog_started)
	DialogSystem.finished.connect(_on_dialog_finished)

func enter() -> void:
	player.animation_player.play("idle")
	player.process_mode = Node.PROCESS_MODE_ALWAYS

func exit() -> void:
	player.process_mode = Node.PROCESS_MODE_INHERIT

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	player.velocity = Vector2.ZERO
	return null

func physics_process(_delta: float) -> PlayerState:
	return null

func _on_dialog_started() -> void:
	player.change_state(self)

func _on_dialog_finished() -> void:
	player.change_state(idle)
