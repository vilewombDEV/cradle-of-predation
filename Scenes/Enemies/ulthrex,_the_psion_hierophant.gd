extends Node2D
class_name UlthrexBoss

const ENERGY_ORB: PackedScene = preload("res://Scenes/Enemies/energy_orb.tscn")

@export var max_hp: int = 10

#region /// Standard Variables
var hp: int  = 10
var audio_hurt: AudioStream = preload("res://Music & SFX/SFX/ulthrex_hit.mp3")
var audio_shoot: AudioStream = preload("res://Music & SFX/SFX/boss_fireball.wav")
var current_position: int = 0
var positions: Array[Vector2]
var beam_attacks: Array[BeamAttack]
var damage_count: int = 0
#endregion

#region /// On-Ready Variables
@onready var boss_animation_player: AnimationPlayer = $BossNode/BossAnimationPlayer
@onready var damaged_animation_player: AnimationPlayer = $BossNode/DamagedAnimationPlayer
@onready var audio: AudioStreamPlayer2D = $BossNode/AudioStreamPlayer2D
@onready var boss_node: Node2D = $BossNode
@onready var boss_defeated: PersistentDataHandler = $PersistentDataHandler
@onready var hurt_box: HurtBox = $BossNode/HurtBox
@onready var hit_box: HitBox = $BossNode/HitBox

#endregion

func _ready() -> void:
	boss_defeated.get_value()
	if boss_defeated.value == true:
		queue_free()
		return
	hp = max_hp
	PlayerHUD.show_boss_health("Ulthrex, the Psyion Hierophant")
	hit_box.damaged.connect(_damage_taken)
	for c in $PositionTargets.get_children():
		positions.append(c.global_position)
	$PositionTargets.visible = false
	for b in $BeamAttacks.get_children():
		beam_attacks.append(b)
	teleport(0)

func teleport(_location: int) -> void:
	boss_animation_player.play("disappear")
	enable_hit_boxes(false)
	damage_count = 0
	if hp < max_hp:
		shoot_orb()
	await get_tree().create_timer(2.5)
	boss_node.global_position = positions[_location]
	current_position = _location
	boss_animation_player.play("appear")
	await boss_animation_player.animation_finished
	idle()

func idle() -> void:
	enable_hit_boxes()
	if randf() <= float(hp)/ float(max_hp):
		boss_animation_player.play("idle")
		await boss_animation_player.animation_finished
		if hp < 1:
			return
	if damage_count < 1:
		energy_beam_attack()
		boss_animation_player.play("cast_spell")
		await boss_animation_player.animation_finished
	if hp < 1:
		return
	var _t: int = current_position
	while _t == current_position:
		_t = randi_range(0, 3)
	teleport(_t)

func energy_beam_attack() -> void:
	var _b: Array[int]
	match current_position:
		0, 2:
			if current_position == 0:
				_b.append(0)
				_b.append(randi_range(1, 2))
			else:
				_b.append(2)
				_b.append(randi_range(0, 1))
			if hp < 5:
				_b.append(randi_range(3, 5))
		1, 3:
			if current_position == 3:
				_b.append(5)
				_b.append(randi_range(3, 4))
			else:
				_b.append(3)
				_b.append(randi_range(4, 5))
			if hp < 5:
				_b.append(randi_range(0, 2))
	for b in _b:
		beam_attacks[b].attack()

func shoot_orb() -> void:
	var eo: Node2D = ENERGY_ORB.instantiate()
	eo.global_position = boss_node.global_position + Vector2(0, -34)
	get_parent().add_child.call_deferred(eo)
	play_audio(audio_shoot)

func _damage_taken(_hurt_box: HurtBox) -> void:
	if damaged_animation_player.current_animation == "damaged" or _hurt_box.damage == 0:
		return
	play_audio(audio_hurt)
	hp = clampi(hp - hurt_box.damage, 0, max_hp)
	damage_count += 1
	PlayerHUD.update_boss_health(hp, max_hp)
	damaged_animation_player.play("damaged")
	damaged_animation_player.seek(0)
	damaged_animation_player.queue("default")
	if hp < 1:
		defeat()

func defeat() -> void:
	boss_animation_player.play("destroy")
	enable_hit_boxes(false)
	PlayerHUD.hide_boss_health()
	boss_defeated.set_value()
	await boss_animation_player.animation_finished

func enable_hit_boxes(_v: bool = true) -> void:
	hit_box.set_deferred("monitorable", _v)
	hurt_box.set_deferred("monitoring", _v)

func play_audio(_a: AudioStream) -> void:
	audio.stream = _a
	audio.play()
