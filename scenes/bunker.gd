class_name Bunker
extends StaticBody2D

const BUNKER_HEIGHT: int = 30
const BUNKER_WIDTH: int = 40

var bunker_image = Image
var bunker_texture = ImageTexture

@onready var sprite = $Sprite2D
@onready var collider = CollisionPolygon2D.new()


func _on_ready():
	var image = load("res://resources/bunker.png")
	
	collider.position = Vector2.ZERO
	add_child(collider)
	sprite.texture = ImageTexture.create_from_image(image)
	
	bunker_texture = sprite.texture.duplicate() 
	bunker_image = bunker_texture.get_image()
	sprite.texture = bunker_texture
	_update_collision_shape()


func damage_at(global_hit_pos: Vector2, radius: float = 12.0):
	var local_pos = sprite.to_local(global_hit_pos)
	for x in range(local_pos.x - radius, local_pos.x + radius):
		for y in range(local_pos.y - radius, local_pos.y + radius):
			if Vector2(x, y).distance_to(local_pos) <= radius:
				if x >= 0 and y >= 0 and x < bunker_image.get_width() and y < bunker_image.get_height():
					bunker_image.set_pixel(x, y, Color(0, 0, 0, 0))

	bunker_texture.set_image(bunker_image)
	_update_collision_shape()


func _update_collision_shape():
	var bm = BitMap.new()
	bm.create_from_image_alpha(bunker_image, 0.1)
	
	var polygons = bm.opaque_to_polygons(Rect2(
					Vector2i(), 
					bunker_image.get_size()
				), 1.0)
	
	if polygons.size() > 0:
		collider.polygon = polygons[0]
	else:
		collider.polygon = PackedVector2Array()
