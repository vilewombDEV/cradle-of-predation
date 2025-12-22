extends Node


const GLOBAL_DAMAGE_TEXT = preload("res://Singleton/global_damage_text.tscn")

func damage_text(_damage: int, _pos: Vector2) -> void:
	var _t: DamageText = GLOBAL_DAMAGE_TEXT.instantiate()
	add_child(_t)
	_t.start( str(_damage), _pos )
