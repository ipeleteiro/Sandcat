extends Node2D

@onready var area_2d: Area2D = $StaticBody2D/Area2D
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/Area2D/CollisionShape2D
@onready var breaking_platform: Sprite2D = $StaticBody2D/BreakingPlatform
@onready var smoke_right: Sprite2D = $StaticBody2D/BreakingPlatform/SmokeRight
@onready var smoke_left: Sprite2D = $StaticBody2D/BreakingPlatform/SmokeLeft
@export var smoke_is_left: bool
@onready var audio_stream_break: AudioStreamPlayer2D = $AudioStreamBreak


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	smoke_right.visible = false
	smoke_left.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	smoke_left.texture = load("res://assets/style"+ ArtStyle.artstyle +"/environment/smoke.png")
	smoke_right.texture = load("res://assets/style"+ ArtStyle.artstyle +"/environment/smoke.png")
	
	if body.name == "sandcat":
		if body.is_sprinting:
			if smoke_is_left:
				smoke_right.visible = true
			else:
				smoke_right.visible = true
			
			break_wall()
	
func break_wall():
	var tween = create_tween()
	audio_stream_break.play()
	
	# Shake up/down a few times
	var original_pos = position
	var shake_time = 0.1
	
	tween.tween_property(self, "position", original_pos + Vector2(50, -1), shake_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_callback(Callable(self, "disable_and_hide"))
	
func disable_and_hide():
	breaking_platform.visible = false
	collision_shape_2d.disabled = true
	smoke_right.visible = false
	smoke_left.visible = false
	queue_free()

func _process(_delta: float) -> void:
	breaking_platform.texture = load("res://assets/style"+ ArtStyle.artstyle +"/environment/breaking_platform.png")
