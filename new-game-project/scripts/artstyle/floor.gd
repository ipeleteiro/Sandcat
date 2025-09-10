extends Node2D

@onready var floor: Sprite2D = $StaticBody2D/Floor

func _process(_delta: float) -> void:
	floor.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/floor.png")
