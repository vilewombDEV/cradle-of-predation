@tool
extends NPCBehavior

@export var walk_speed: float = 20.0

var patrol_locations: Array[PatrolLocation]
var current_location_index: int = 0
var target: PatrolLocation

func _ready() -> void:
	gather_patrol_locations()
	if Engine.is_editor_hint():
		child_entered_tree.connect(gather_patrol_locations)
		child_order_changed.connect(gather_patrol_locations)
		return
	super()
	if patrol_locations.size() == 0:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	target = patrol_locations[0]

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if npc.global_position.distance_to(target.target_pos) < 1:
		start()

func gather_patrol_locations(_n: Node = null) -> void:
	patrol_locations = []
	for c in get_children():
		if c is PatrolLocation:
			patrol_locations.append(c)

func start() -> void:
	if npc.do_behavior == false or patrol_locations.size() < 2:
		return
	npc.global_position = target.target_pos
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	
	var wait_time: float = target.wait_time
	current_location_index += 1
	if current_location_index >= patrol_locations.size():
		current_location_index = 0
	target = patrol_locations[current_location_index]
	await get_tree().create_timer(wait_time).timeout
	
	if npc.do_behavior == false:
		return
	npc.state = "walk"
	var _dir = global_position.direction_to(target.target_pos)
	npc.direction = _dir
	npc.velocity = walk_speed * _dir
	npc.update_direction(target.target_pos)
	npc.update_animation()
