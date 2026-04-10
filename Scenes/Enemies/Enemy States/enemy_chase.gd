extends EnemyState
class_name EnemyStateChase

const PATHFINDER: PackedScene = preload("res://Scenes/Enemies/Enemy States/pathfinder.tscn")

#region /// Export Variables
@export var animation_name: String = "chase"
@export var chase_speed: float = 40.0
@export var turn_rate: float = 0.75

@export_category("AI")
@export var vision_area: VisionArea
@export var attack_area: DamagedArea
@export var state_aggro_duration: float = 1.0
@export var next_state: EnemyState
#endregion

var _timer: float = 0.0
var _direction: Vector2
var _can_see_player: bool = false

var pathfinder: PathFinder

func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(_on_player_enter)
		vision_area.player_exited.connect(_on_player_exit)

func enter() -> void:
	pathfinder = PATHFINDER.instantiate() as PathFinder
	enemy.add_child(pathfinder)
	_timer = state_aggro_duration
	enemy.update_animation(animation_name)
	if attack_area:
		attack_area.monitoring = true

func exit() -> void:
	pathfinder.queue_free()
	if attack_area:
		attack_area.monitoring = false
	_can_see_player = false

func process(_delta: float) -> EnemyState:
	if PlayerManager.player.hp <= 0:
		return next_state
	_direction = lerp(_direction, pathfinder.move_dir, turn_rate)
	enemy.velocity.x = _direction.x * chase_speed
	if enemy.set_direction(_direction):
		enemy.update_animation(animation_name)
	if _can_see_player == false:
		_timer -= _delta
		if _timer <= 0:
			return next_state
	else:
		_timer = state_aggro_duration
	return null

func physics_process(_delta: float) -> EnemyState:
	return null

func _on_player_enter() -> void:
	_can_see_player = true
	if(
			state_machine.current_state is EnemyStateStun
			or state_machine.current_state is EnemyStateDestroy
	):
		return
	state_machine.change_state(self)

func _on_player_exit() -> void:
	_can_see_player = false
