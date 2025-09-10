extends Node2D

@onready var no_zone: Area2D = $StaticBody2D/no_zone
@onready var crow: AnimatedSprite2D = $StaticBody2D/AnimatedSprite2D
@onready var audio_stream_caws: AudioStreamPlayer2D = $AudioStreamCaws

var original_pos

func _ready() -> void:
	original_pos = no_zone.position
	#start_looping_tween()

func start_looping_tween():
	var tween = create_tween()
	tween.set_loops()  # Loop forever

	tween.tween_property(no_zone, "position", original_pos + Vector2(130, 0), 0.35)
	tween.tween_property(no_zone, "position", original_pos + Vector2(130, 0), 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(no_zone, "position", original_pos, 0.35)
	
	tween.tween_property(no_zone, "position", original_pos + Vector2(-130, 0), 0.35)
	tween.tween_property(no_zone, "position", original_pos + Vector2(-130, 0), 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(no_zone, "position", original_pos, 0.35)


var move_timer = 0
var going_left = false
@export var left_timer: float = 1
var going_right = false
var right_timer = 0

func _process(delta: float) -> void:
	if going_left == true:
		going_left = false
		crow.play("right" + ArtStyle.artstyle)
		left_timer = 0
		right_timer = 0
		var tween = create_tween()
		tween.tween_property(no_zone, "position", original_pos + Vector2(-150, 0), 0.2)
		tween.tween_property(no_zone, "position", original_pos + Vector2(150, 0), 0.5)
	
	if left_timer < 1.6:
		left_timer += delta
	else:
		going_right = true
	
	if going_right == true:
		going_right = false
		crow.play("left" + ArtStyle.artstyle)
		right_timer = 0
		left_timer = 0
		var tween = create_tween()
		tween.tween_property(no_zone, "position", original_pos + Vector2(150, 0), 0.2)
		tween.tween_property(no_zone, "position", original_pos + Vector2(-150, 0), 0.5)
	
	if right_timer < 1.6:
		right_timer += delta
	else:
		going_left = true


func _on_no_zone_body_entered(body: Node2D) -> void:
	if body.name == "sandcat":
		# make player do the following:
		# 	walk AWAY from the crow slowly (use velocity)
		# 	play "scared" animation
		
		body.is_scared = true
		body.crow_direction = (body.global_position - crow.global_position).normalized()
		body.crow_count += 1
		audio_stream_caws.play()

func _on_no_zone_body_exited(body: Node2D) -> void:
	if body.name == "sandcat":
		body.is_scared = false
