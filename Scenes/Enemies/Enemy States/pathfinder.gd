extends Node2D
class_name PathFinder

var vectors: Array[Vector2] = [
	Vector2 (1,0), # RIGHT
	Vector2 (0,1), # DOWN
	Vector2 (-1,0) # LEFT
]

var interests: Array[float] 
var obstacles: Array[float] = [0, 0, 0]
var outcomes: Array[float] = [0, 0, 0]
var rays: Array[RayCast2D]

var move_dir: Vector2 = Vector2.ZERO
var best_path: Vector2 = Vector2.ZERO

@onready var timer: Timer = $Timer

func _ready() -> void:
	# Gather all Raycast2D Nodes
	for c in get_children():
		if c is RayCast2D:
			rays.append(c)
	# Normalize all vectors
	for i in vectors.size():
		vectors[i] = vectors[i].normalized()
	# Perform initial pathfinder function
	set_path()
	# Connect timer 
	timer.timeout.connect(set_path)

func _process(delta: float) -> void:
	move_dir = lerp(move_dir, best_path, 10 * delta)

# Set best path vector by checking for desired direction & considering obstacles
func set_path() -> void:
	var player_dir: Vector2 = global_position.direction_to(PlayerManager.player.global_position)
	
	for i in 3:
		obstacles[i] = 0
		outcomes[i] = 0
	
	for i in 3: 
		if rays[i].is_colliding():
			obstacles[i] += 1
			obstacles[ get_next_i(i) ] += 1
			obstacles[ get_prev_i(i) ] += 1
	
		if obstacles.max() == 0:
			best_path = player_dir
			return
	
	interests.clear()
	for v in vectors:
		interests.append(v.dot(player_dir))
	
	for i in 3:
		outcomes[i] = interests[i] - obstacles[i]
	best_path = vectors[ outcomes.find(outcomes.max()) ]


func get_next_i(i: int) -> int:
	var n_i: int = i + 1
	if n_i >= 3:
		return 0
	else:
		return n_i

func get_prev_i(i: int) -> int:
	var n_i: int = i - 1
	if n_i < 0:
		return 2
	else:
		return n_i
