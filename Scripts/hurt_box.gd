extends Area2D
class_name HurtBox

@export var damage: int = 1

func _ready() -> void:
	area_entered.connect(_area_entered)

func _area_entered(a: Area2D) -> void:
	if a is HitBox:
		a.take_damage(self)
