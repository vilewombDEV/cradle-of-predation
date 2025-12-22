extends ItemData
class_name EquipableItemData

enum Type {WEAPON, ARMOR, MAGIC_BOOK, RING}
@export var type: Type = Type.WEAPON
@export var modifiers: Array[EquipableItemModifier]
