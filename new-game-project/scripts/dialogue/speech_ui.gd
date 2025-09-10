extends Control

@onready var panel: Panel = $CanvasLayer/Panel
@onready var dialogue_speaker: Label = $CanvasLayer/Panel/dialogue_box/dialogue_speaker
@onready var dialogue_text: Label = $CanvasLayer/Panel/dialogue_box/dialogue_text
@onready var audio_stream_speech: AudioStreamPlayer2D = $AudioStreamSpeech

var typing_speed := 0.02  # seconds per character
var typing := false
var full_text := ""

func _ready() -> void:
	audio_stream_speech.volume_db = -10
	hide_dialogue()

func change_dialogue_colour(colour: Color):
	var style := StyleBoxFlat.new()
	style.bg_color = colour
	panel.add_theme_stylebox_override("panel", style)

func change_text_colour(colour: Color):
	dialogue_speaker.add_theme_color_override("font_color", colour)
	dialogue_text.add_theme_color_override("font_color", colour)

func show_dialogue(speaker: String, text: String, speech_sfx: AudioStream) -> void:
	panel.visible = true
	dialogue_speaker.text = speaker
	full_text = text
	dialogue_text.text = ""
	typing = true
	audio_stream_speech.stream = speech_sfx
	start_typing(full_text)

# Coroutine that types out text
func start_typing(text: String) -> void:
	await get_tree().process_frame  # let UI update first
	for i in range(text.length()):
		if not typing or not Quest.player.is_interacting or Quest.player.is_in_shop:  # interrupted (skipped)
			break
		dialogue_text.text = text.substr(0, i + 1)
		
		audio_stream_speech.pitch_scale = 0.8 + randf_range(-0.1,0.1)
		if text.substr(0, i + 1) in ['a','e','i','o','u']:
			audio_stream_speech.pitch_scale += 0.2
		audio_stream_speech.play()
		
		#await audio_stream_speech.finished
		await get_tree().create_timer(typing_speed).timeout
		audio_stream_speech.stop()
		#new_audio_player.queue_free()

	# Ensure full text is shown at the end
	dialogue_text.text = text
	typing = false

func next_dialogue():
	pass

func hide_dialogue():
	panel.visible = false
