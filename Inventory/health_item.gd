extends ItemEffect
class_name HealthItem

@export var health_increase: int = 2
@export var audio: AudioStream


func use() -> void:
	PlayerManager.player.update_hp(health_increase)
	PauseMenu.play_sound(audio)
