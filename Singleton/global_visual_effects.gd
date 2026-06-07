# VFX
extends Node

const DUST_EFFECT = preload("uid://g4rmh3q4sno5")
const HIT_PARTICLES = preload("uid://dd7fjw275hs0x")


func _create_dust_effect(pos: Vector2) -> DustEffect:
	var dust: DustEffect = DUST_EFFECT.instantiate()
	add_child(dust)
	dust.global_position = pos
	return dust

func jump_dust(pos: Vector2) -> void:
	var dust: DustEffect = _create_dust_effect(pos)
	dust.start(DustEffect.TYPE.JUMP)

func land_dust(pos: Vector2) -> void:
	var dust: DustEffect = _create_dust_effect(pos)
	dust.start(DustEffect.TYPE.LAND)

func hit_dust(pos: Vector2) -> void:
	var dust: DustEffect = _create_dust_effect(pos)
	dust.start(DustEffect.TYPE.HIT)

func hit_particles(pos: Vector2, dir: Vector2, settings: HitParticleSettings) -> void:
	var p: HitParticles = HIT_PARTICLES.instantiate()
	add_child(p)
	p.global_position = pos
	p.start(dir, settings)
