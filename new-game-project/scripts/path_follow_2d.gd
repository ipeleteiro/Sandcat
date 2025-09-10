extends PathFollow2D

@export var speed: float = 300
var previous_offset: float = 0.0
var flipped: bool = false
@onready var crow: AnimatedSprite2D = $StaticBody2D/AnimatedSprite2D
var flipped_already
@export var flip_crow: bool = false

@onready var audio_stream_caws: AudioStreamPlayer2D = $AudioStreamCaws

func _ready():
	flipped_already = flip_crow
	previous_offset = progress

func _process(delta):
	crow.play("default" + ArtStyle.artstyle)
	
	progress += speed * delta

	# Detect loop
	if progress_ratio > 0.5 and not flipped_already:
		flipped_already = true
		flip_sprite()
	if progress_ratio < 0.5 and flipped_already:
		flipped_already = false
		flip_sprite()

	previous_offset = progress

func flip_sprite():
	flipped = !flipped
	crow.flip_h = flipped

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
