extends Node2D
class_name Barrel

#region /// On-Ready Variables
@onready var damaged_area: DamagedArea = $DamagedArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var is_destroyed_data: PersistentDataHandler = $IsDestroyed
#endregion

var is_destroyed: bool = false

func _ready() -> void:
	damaged_area.damage_taken.connect(_on_damage_taken)
	is_destroyed_data.data_loaded.connect(set_barrel_state)
	set_barrel_state()

func set_barrel_state() -> void:
	is_destroyed = is_destroyed_data.value
	if is_destroyed:
		animated_sprite.play("Destroyed")
	else:
		animated_sprite.play("Idle")

func _on_damage_taken(attack_area: AttackArea) -> void:
	if is_destroyed:
		return
	if !is_destroyed:
		animated_sprite.play("Destroy")
		is_destroyed_data.set_value()
		is_destroyed = true
		await animated_sprite.animation_finished
		queue_free()
	else:
		animated_sprite.play("Idle")
