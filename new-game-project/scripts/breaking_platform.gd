extends Node2D

@onready var area_2d: Area2D = $StaticBody2D/Area2D
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var breaking_platform: AnimatedSprite2D = $StaticBody2D/BreakingPlatform
@onready var audio_stream_break: AudioStreamPlayer2D = $AudioStreamBreak

var break_platform = false
var restore_platform = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "sandcat":
		if body.is_head_wet:
			break_platform = true

var restore_timer = 0
var break_timer = 0

func _ready() -> void:
	breaking_platform.play("restore" + ArtStyle.artstyle)
	
func _process(delta: float) -> void:
	if break_platform:
		restore_timer = 0
		restore_platform = true
		break_timer += delta
		if break_timer > 0.5:
			break_platform = false
			collision_shape_2d.disabled = true
			collision_shape_2d.disabled = true
			breaking_platform.play("break" + ArtStyle.artstyle)
			audio_stream_break.play()
	
	if restore_platform:
		restore_timer += delta
		if restore_timer > 5:
			collision_shape_2d.disabled = false
			restore_platform = false
			breaking_platform.play("restore" + ArtStyle.artstyle)
			audio_stream_break.play()
