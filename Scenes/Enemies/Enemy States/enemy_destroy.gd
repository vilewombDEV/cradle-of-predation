extends EnemyState
class_name EnemyStateDestroy

const PICKUP = preload("res://Inventory/item_pickup.tscn")

#region /// Export Variables
@export var animation_name: String = "destroy"
@export var knockback_speed: float = 15.0
@export var decelerate_speed: float = 10.0

@export_category("AI")

@export_category("Item Drops")
@export var drops: Array[DropData]
#endregion

var _damage_position: Vector2
var _direction: Vector2
var _animation_finished: bool = false

func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)

func enter() -> void:
	enemy.invulnerable = true
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.set_direction(_direction)
	enemy.velocity = _direction * -knockback_speed
	enemy.update_animation(animation_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	disable_hurt_box()
	drop_items()
	PlayerManager.reward_xp(enemy.xp_reward)

func exit() -> void:
	pass

func process(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func physics_process(_delta: float) -> EnemyState:
	return null

func _on_enemy_destroyed(attack_area: AttackArea) -> void:
	_damage_position = attack_area.global_position
	state_machine.change_state(self)

func _on_animation_finished(_a: String) -> void:
	enemy.queue_free()

func disable_hurt_box() -> void:
	var attack_area: AttackArea = enemy.get_node_or_null("HazardArea")
	if attack_area:
		attack_area.monitoring = false

func drop_items() -> void:
	if drops.size() == 0:
		return
	for i in drops.size():
		if drops[i] == null or drops[i].item == null:
			continue
		var drop_count: int = drops[i].get_drop_count()
		for j in drop_count:
			var drop: ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[i].item
			enemy.get_parent().call_deferred("add_child", drop)
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated(randf_range(-1.5, 2.5)) * randf_range(0.9, 1.5)
