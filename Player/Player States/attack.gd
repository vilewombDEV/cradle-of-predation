extends PlayerState
class_name PlayerStateAttack

var attacking: bool = false

func init() -> void:
	pass

func enter() -> void:
	player.animation_player.play("secondary_attack")
	player.animation_player.animation_finished.connect(end_attack)
	
	attacking = true
	await get_tree().create_timer(0.075).timeout
	if attacking:
		player.hurt_box.monitoring = true

func exit() -> void:
	player.animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	player.hurt_box.monitoring = false

func handle_input(_event: InputEvent) -> PlayerState:
	return next_state 

func process(_delta: float) -> PlayerState:
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return run
	return next_state

func end_attack(_new_animation_name: String) -> void:
	attacking = false
