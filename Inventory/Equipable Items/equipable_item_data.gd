extends ItemData
class_name EquipableItemData

enum Type {WEAPON, ARMOR, RING, MAGIC_BOOK}
@export var type: Type = Type.WEAPON
@export var modifiers: Array[EquipableItemModifier]
