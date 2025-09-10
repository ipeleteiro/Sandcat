extends Area2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/Label
@export var txt: String
var label_visible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = txt


func _on_body_entered(body: Node2D) -> void:
	if body.name == "sandcat" and label_visible:
		canvas_layer.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "sandcat":
		canvas_layer.visible = false
