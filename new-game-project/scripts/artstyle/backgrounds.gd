extends Node2D

@onready var backgrounds_1_5: Sprite2D = $Parallax2D/Backgrounds1_5
@onready var backgrounds_2_5: Sprite2D = $Parallax2D/Backgrounds2_5
@onready var backgrounds_2: Sprite2D = $Parallax2D2/Backgrounds2
@onready var backgrounds_1: Sprite2D = $Parallax2D2/Backgrounds1

func _process(_delta: float) -> void:
	backgrounds_1.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/backgrounds1.png")
	backgrounds_1_5.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/backgrounds1.5.png")
	backgrounds_2.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/backgrounds2.png")
	backgrounds_2_5.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/backgrounds2.5.png")
