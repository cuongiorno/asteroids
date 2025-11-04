class_name Bullet
extends RigidBody2D

const SPEED: int = 20

@export var is_friendly : bool

@onready var explosion = preload("res://scenes/explosion.tscn").instantiate()


func _physics_process(_delta: float) -> void:
	var collision_info
	if is_friendly:
		collision_info = move_and_collide(Vector2(0, -SPEED))
	elif not is_friendly:
		collision_info = move_and_collide(Vector2(0, SPEED))
		
	if collision_info:
		var thing_we_hit = collision_info.get_collider()
		spawn_explosion()
		if thing_we_hit.is_in_group("enemies"):
			SignalBus.enemy_hit.emit(thing_we_hit.awarded_points)
			thing_we_hit.queue_free()
			queue_free()
		if thing_we_hit is Starship:
			thing_we_hit.decrease_health(1)
			queue_free()
		if thing_we_hit is Bullet:
			if thing_we_hit.is_friendly != is_friendly:
				thing_we_hit.queue_free()
				queue_free()
		if thing_we_hit is Bunker:
			thing_we_hit.damage_at(self.global_position)
			queue_free()
	if (position.y < 0) or (position.y > get_viewport_rect().size.y):
		queue_free()


func spawn_explosion():
	explosion.global_position = self.global_position
	get_tree().root.add_child(explosion)
