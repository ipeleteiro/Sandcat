extends Node2D

@onready var platform: Sprite2D = $StaticBody2D/Platform

func _process(_delta: float) -> void:
	platform.texture = load("res://assets/style" +ArtStyle.artstyle+ "/environment/platform.png")
