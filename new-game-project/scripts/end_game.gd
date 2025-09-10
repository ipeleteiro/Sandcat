extends Area2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var feather_count: Label = $CanvasLayer/FeatherCount
@onready var crow_hits: Label = $CanvasLayer/CrowHits
@onready var timer_1: Label = $CanvasLayer/Timer1
@onready var timer_2: Label = $CanvasLayer/Timer2
@onready var timer_3: Label = $CanvasLayer/Timer3

func _ready() -> void:
	canvas_layer.visible = false
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact2") and Quest.player.can_end_game:
		if Quest.check_item_quanitity("Feather", 7):
			canvas_layer.visible = true
			feather_count.text = "Congrats! You got "+ str(Quest.get_item_quantity("Feather")) + " feathers!"
			crow_hits.text = "Number of crow hits: " + str(Quest.player.crow_count)
			timer_1.text = ArtStyle.digital_time()
			timer_2.text = ArtStyle.pixel_time()
			timer_3.text = ArtStyle.pencil_time()
			get_tree().paused = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "sandcat":
		body.can_end_game = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "sandcat":
		body.can_end_game = false
