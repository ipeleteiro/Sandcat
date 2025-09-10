extends Node2D

@onready var spike_1: Sprite2D = $Spike1
@onready var spike_2: Sprite2D = $Spike2
@onready var spike_3: Sprite2D = $Spike3
@onready var spike_4: Sprite2D = $Spike4
@onready var spike_5: Sprite2D = $Spike5


func _process(_delta: float) -> void:
	spike_1.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/spike1.png")
	spike_2.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/spike2.png")
	spike_3.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/spike3.png")
	spike_4.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/spike4.png")
	spike_5.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/spike5.png")
