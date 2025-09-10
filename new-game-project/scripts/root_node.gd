extends Node2D

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var menu: Control = $Menu

var video_played

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not video_stream_player.is_playing() and not video_played:
		play_video()

func play_video():
	menu.visible = false
	get_tree().paused = true
	video_stream_player.play()
	await video_stream_player.finished
	get_tree().paused = false
	video_played = true
	menu.visible = true
	menu.show_menu()
