extends Resource
class_name EquipableItemModifier

enum Type {ATTACK, DEFENSE, INSIGHT, ATTUNEMENT}
@export var type: Type = Type.ATTACK
@export var value: int = 1
