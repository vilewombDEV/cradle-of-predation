@tool
extends CutsceneAction
class_name CutsceneActionMove

enum Method {DURATION, SPEED}

#region /// Export Variables
@export var timimg_method: Method = Method.DURATION
@export var object_to_move: Node2D
@export var transition_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var easing_method: Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export_range(0.0, 10.0, 0.05, "s") var move_duration: float = 0.5
@export_range(10, 1000.0, 1, "px/s") var move_speed: float = 120.0
@export var animation_speed_factor: float = 120.0
#endregion

var target_location: Vector2 = Vector2.ZERO
var move_direction: Vector2 = Vector2.ZERO
var distance_to_target: float = 0.0

func _ready() -> void:
	target_location = global_position

func play() -> void:
	if object_to_move:
		object_to_move.process_mode = Node.PROCESS_MODE_ALWAYS
		distance_to_target = calculate_distance_to_target()
		get_move_direction()
		if timimg_method == Method.SPEED:
			move_duration = distance_to_target / move_speed
		else:
			move_speed = distance_to_target / move_duration
		
		if object_to_move is NPC:
			var npc: NPC = object_to_move
			npc.do_behavior = false
			npc.state = "run"
			npc.direction = move_direction
			npc.update_direction(target_location)
			npc.update_animation()
			npc.animation.speed_scale = move_speed / animation_speed_factor
		
		var tween: Tween = create_tween()
		tween.set_ease(easing_method)
		tween.set_trans(transition_type)
		tween.tween_property(object_to_move, "global_position", target_location, move_duration)
		tween.tween_callback(_on_tween_finished)
	else:
		finished.emit()

func get_move_direction() -> void:
	if object_to_move:
		move_direction = object_to_move.global_position.direction_to(target_location)

func calculate_distance_to_target() -> float:
	return object_to_move.global_position.distance_to(target_location)

func _on_tween_finished() -> void:
	object_to_move.process_mode = Node.PROCESS_MODE_INHERIT
	
	if object_to_move is NPC:
		var npc: NPC = object_to_move
		npc.do_behavior = true
		npc.state = "idle"
		npc.animation.speed_scale = 1
		npc.do_behavior_enabled.emit()
		npc.update_animation()
		npc.process_mode = Node.PROCESS_MODE_INHERIT
	
	finished.emit()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle(Vector2.ZERO, 3, Color.RED)
		draw_circle(Vector2.ZERO, 10, Color(1, 0, 0, 0.5), false, 1.0)
