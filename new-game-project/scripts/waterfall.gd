extends Node2D

@onready var splash: AnimatedSprite2D = $splash
@onready var clipping_mask: Sprite2D = $ClippingMask


var current_collision = Vector2(0,0)
var max_collision = Vector2(0,0)
var segment_height
var start_y

@export var offset: int = 160

func _ready():
	start_y = clipping_mask.global_position.y - (clipping_mask.texture.get_height()/2.0) - 400


func _process(_delta: float) -> void:
	splash.play("default" + ArtStyle.artstyle)
	
	var new_collision = get_collision_point(Vector2(clipping_mask.global_position.x, start_y))

	if new_collision != current_collision:
		
		clipping_mask.scale.y = (new_collision.y - start_y) + offset
		clipping_mask.global_position = Vector2(clipping_mask.global_position.x, start_y + (new_collision.y - start_y) / 2.0)

		splash.global_position = new_collision + Vector2(0,-260)
		current_collision = new_collision



func get_collision_point(start: Vector2) -> Vector2:
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsRayQueryParameters2D.create(start, start + Vector2(0,5000))
	var result = space_state.intersect_ray(query)
	if result.size() > 0:
		if result.collider.name == "sandcat":
			if Quest.player.is_down != true:
				Quest.player.is_head_wet = true
				Quest.player.head_wet_timer = 0
		return result.position
	else: 
		return Vector2(0,0)



	
