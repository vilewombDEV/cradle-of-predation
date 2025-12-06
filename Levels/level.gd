extends Node2D
class_name Level

var portal_open: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $PortalArea/AnimatedSprite2D
@onready var teleport: AudioStreamPlayer = $PortalArea/Teleport

@export var music: AudioStream

func _ready() -> void:
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(_free_level)
	AudioManager.play_music(music)

func _free_level() -> void:
	PlayerManager.unparent_player(self)
	queue_free()


func _on_portal_area_body_entered(body: Node2D) -> void:
	if portal_open: return
	if body == PlayerManager.player:
		animated_sprite_2d.play("Portal Open")
		teleport.play()
