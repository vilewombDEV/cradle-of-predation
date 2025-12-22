extends PlayerState
class_name PlayerStateIdle

func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("idle")

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump
	if _event.is_action_pressed("attack"):
		return attack
	return next_state 

func process(_delta: float) -> PlayerState:
	if player.direction.x != 0:
		return run
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	return next_state
