@tool
extends Area2D


@onready var sprite = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var item: Item
var picked_up = false

var quest_manager: Node2D = null

func _ready() -> void:
	# show in game
	if not Engine.is_editor_hint():
		sprite.sprite_frames = item.animation
		quest_manager = Quest.player.quest_manager
		up_down()

func up_down():
	var tween = create_tween().set_loops()
	var original_pos = position
	var shake_time = 0.7
	tween.tween_property(self, "position", original_pos + Vector2(0, -5), shake_time)
	tween.tween_property(self, "position", original_pos + Vector2(0, 5), shake_time)


var pick_up_anim = false
var item_velocity
var timer = 0

func _process(delta: float) -> void:
	# show in editor
	if Engine.is_editor_hint():
		sprite.sprite_frames = item.animation
	else:
		sprite.play("default" + ArtStyle.artstyle)
		
		if pick_up_anim:
			item_velocity += Vector2(0, 1500) * delta
			item_velocity *= 0.95 # drag
			sprite.position += item_velocity * delta
			timer += delta
			if timer > 1:
				queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "sandcat" and not picked_up:
		picked_up = true
		Quest.add_to_inventory(item)
		for quest in quest_manager.active_collect_quests():
			quest.complete_collect_obj(item.id)
		# play pick_up animation
		start_pick_up()

func start_pick_up():
	audio_stream_player_2d.play()
	
	pick_up_anim = true
	timer = 0
	var target_x = randf_range(-200.0, 200.0)
	var target_y = -700
	
	var flight_time = randf_range(0.8, 1.2)
	
	var vx = 1.5 * (target_x) / flight_time
	var vy = (target_y - sprite.position.y - 0.5 * 1500 * flight_time * flight_time) / flight_time
	
	item_velocity = Vector2(vx, vy)
