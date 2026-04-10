extends CharacterBody2D
class_name Enemy

signal direction_changed(new_direction: Vector2)
signal enemy_damaged(attack_area: AttackArea)
signal enemy_destroyed(attack_area: AttackArea)

const DIR_2 = [Vector2.RIGHT, Vector2.LEFT]

@export var hp: int = 3
@export var xp_reward: int = 1

var axis_direction: Vector2 = Vector2.LEFT
var direction: Vector2 = Vector2.ZERO
var player: Player
var invulnerable: bool = false

#region /// On-Ready Variables
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var damaged_area: DamagedArea = $DamagedArea
@onready var hazard_area: HazardArea = $HazardArea
@onready var enemy_state_machine: EnemyStateMachine = $EnemyStateMachine
#endregion

func _ready() -> void:
	enemy_state_machine.initialize(self)
	player = PlayerManager.player
	damaged_area.damage_taken.connect(_take_damage)

func _process(_delta) -> void:
	pass

func _physics_process(delta) -> void:
	velocity += get_gravity() * delta
	move_and_slide()

func set_direction(_new_direction: Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id: int = int( round(
		( direction + axis_direction * 0.1).angle()
		/ TAU * DIR_2.size()
	))
	var new_dir = DIR_2[direction_id]
	if new_dir == axis_direction:
		return false
	
	axis_direction = new_dir
	direction_changed.emit(new_dir)
	sprite.scale.x = 1 if axis_direction == Vector2.LEFT else 1
	return true

func update_animation(state: String) -> void:
	animation_player.play(state + "_" + animation_direction())

func animation_direction() -> String:
	if axis_direction == Vector2.LEFT:
		return "left"
	elif axis_direction == Vector2.RIGHT:
		return "right"
	else:
		return ""

func _take_damage(attack_area: AttackArea) -> void:
	if invulnerable == true:
		return
	hp -= attack_area.damage
	PlayerManager.shake_camera()
	EffectManager.damage_text( attack_area.damage, global_position + Vector2(0, -36) )
	if hp > 0:
		enemy_damaged.emit(attack_area)
	else:
		enemy_destroyed.emit(attack_area)
