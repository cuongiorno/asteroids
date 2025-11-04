extends Node2D

const BLOCK_WIDTH : int = 32
const BLOCK_HEIGHT : int = 32
const OFFSET : int = 10

var total_width : int
var array_of_movement : Array = ["l", "l", "d", "r", "r", "r", "r", "d", "l", "l"]
var current_move = 0
var current_direction : Vector2 = Vector2(-OFFSET, 0)
var move_interval : float = 2.0

@onready var enemy_large_scene = preload("res://scenes/enemy_large.tscn")
@onready var enemy_medium_scene = preload("res://scenes/enemy_medium.tscn")
@onready var enemy_small_scene = preload("res://scenes/enemy_small.tscn")
@onready var enemy_special_scene = preload("res://scenes/enemy_special.tscn")
@onready var bullet_scene = preload("res://scenes/bullet.tscn")


func _on_ready() -> void:
	randomize()
	SignalBus.enemy_hit.connect(increase_speed)
	var start_pos_y = 100
	var max_columns = floori(get_viewport().size.x / (BLOCK_WIDTH + OFFSET))
	var next_pos
	total_width = (max_columns - 1) * (BLOCK_WIDTH + OFFSET) - OFFSET
	
	
	for i in 5:
		var start_pos_x = (get_viewport().size.x - total_width) / 2
		for y in (max_columns - 1):
			@warning_ignore("integer_division")
			next_pos = Vector2(start_pos_x + (BLOCK_WIDTH / 2), start_pos_y + (BLOCK_HEIGHT / 2))
			match i:
				0:
					spawn_block(enemy_small_scene, next_pos)
				1, 2:
					spawn_block(enemy_medium_scene, next_pos)
				3, 4:
					spawn_block(enemy_large_scene, next_pos)
			start_pos_x += (BLOCK_WIDTH + OFFSET)
		start_pos_y += (BLOCK_HEIGHT + OFFSET)


func spawn_block(block_scene, block_pos):
		var block = block_scene.instantiate()
		@warning_ignore("integer_division")
		block.position = block_pos
		add_child(block)


#region Movement
func move_block():
	match array_of_movement[current_move]:
		"l":
			self.position += Vector2(-OFFSET, 0)
		"r":
			self.position += Vector2(OFFSET, 0)
		"d":
			self.position += Vector2(0, OFFSET)
	current_move += 1
	if current_move >= array_of_movement.size():
		current_move = 0


func _on_move_timer_timeout() -> void:
	move_block()


func increase_speed(_points_awarded):
	move_interval *= 0.95
	$MoveTimer.wait_time = move_interval
#endregion


#region Shooting
func fire_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.is_friendly = false
	bullet.collision_layer = 3
	bullet.collision_mask = 1
	bullet.position = random_child_position()
	get_parent().add_child(bullet)
	$ShootTimer.start(randi_range(1, 2))


func random_child_position() -> Vector2:
	var children = get_children()
	var random_child = children.pick_random()
	if random_child is not Timer:
		return random_child.global_position
	else:
		return random_child_position()


func _on_shoot_timer_timeout() -> void:
	if get_child_count() > 3:
		fire_bullet()
#endregion


func _on_spawn_timer_timeout():
	var enemy_special = enemy_special_scene.instantiate()
	enemy_special.global_position = Vector2(0, 70)
	get_parent().add_child(enemy_special)
	$SpawnTimer.start(randi_range(20, 30))
