# Global Script - ArtStyle
extends Node

var artstyle: String = "1"

var digital_timer: float = 0.0
var pixel_timer: float = 0.0
var pencil_timer: float = 0.0

func _process(delta: float) -> void:
	if artstyle == "1":
		digital_timer += delta
	elif artstyle == "2":
		pixel_timer += delta
	else:
		pencil_timer += delta

func digital_time() -> String:
	var minutes = int(digital_timer) / 60
	var seconds = int(digital_timer) % 60
	return "%02d:%02d" % [minutes, seconds]

func pixel_time() -> String:
	var minutes = int(pixel_timer) / 60
	var seconds = int(pixel_timer) % 60
	return "%02d:%02d" % [minutes, seconds]

func pencil_time() -> String:
	var minutes = int(pencil_timer) / 60
	var seconds = int(pencil_timer) % 60
	return "%02d:%02d" % [minutes, seconds]
