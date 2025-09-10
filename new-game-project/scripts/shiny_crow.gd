extends Node2D

@onready var info_overlay: Area2D = $InfoOverlay
@onready var action_zone: Area2D = $ActionZone
@onready var crow: PathFollow2D = $Path2D2/PathFollow2D
@onready var lata: Sprite2D = $Path2D2/PathFollow2D/Lata
var can_pick_up = false
var is_picking_up = false
var down_played_already = false
var picked_up_yet = false

func _ready() -> void:
	info_overlay.label_visible = false
	lata.visible = false

func _process(_delta: float) -> void:
	if crow.progress_ratio > 0.5:
		lata.texture = load("res://assets/style" +ArtStyle.artstyle+ "/other/lata.png")
		lata.visible = true
	else:
		lata.visible = false
	
	if Input.is_action_just_pressed("interact2") and can_pick_up:
		info_overlay.label_visible = false
		is_picking_up = true
		Quest.player.is_taken_by_crow = true
		crow.pick_up = true
		down_played_already = false
		picked_up_yet = false
	
	if is_picking_up:
		lata.visible = false
		
		if crow.progress_ratio < 0.5:
			picked_up_yet = true
		if crow.progress_ratio > 0.5 and picked_up_yet:
			Quest.player.global_position = crow.crow_position + Vector2(100, 20)
			Quest.player.animated_sprite.play("fall" + ArtStyle.artstyle)
		elif not down_played_already:
			down_played_already = true
			Quest.player.animated_sprite.play("down" + ArtStyle.artstyle)
		if crow.progress_ratio > 0.95 and picked_up_yet:
			is_picking_up = false
			Quest.player.is_taken_by_crow = false
			crow.pick_up = false


func _on_action_zone_body_entered(body: Node2D) -> void:
	if body.name == "sandcat" and Quest.check_item_quanitity("Shiny Collar", 1):
		can_pick_up = true
		info_overlay.label_visible = true

func _on_action_zone_body_exited(body: Node2D) -> void:
	if body.name == "sandcat":
		can_pick_up = false
