extends Node2D

@onready var fish: Sprite2D = $Fish
var fish_velocity
var pick_up_anim = false
var timer = 0

@onready var water_splash: AnimatedSprite2D = $WaterSplash
@onready var fishing_line: Line2D = $FishingLine
var velocity = Vector2.ZERO
var start_pos = Vector2(290, -260)
var gravity = Vector2(0,1500)
var drag = 0.95

var cast_timer = 0
var cast_time = 1.5
var fish_timer = 0
var fish_time = 0
var fish_wait_timer = 0
var fish_wait_time = 0

var can_fish = false
var casting_line = false
var is_reeling = false
var is_waiting = false
var camera: Camera2D

@onready var audio_stream_fish_caught: AudioStreamPlayer2D = $AudioStreamFishCaught
@onready var audio_stream_line: AudioStreamPlayer2D = $AudioStreamLine

func _ready() -> void:
	camera = Quest.player.camera
	water_splash.visible = false
	fish.visible = false

# when player in fishing area "is_fishing" + camera zoom
# camera dealt with here, ignored in sandcat script
func _on_player_area_body_entered(body: Node2D) -> void:
	if body.name == "sandcat":
		body.is_fishing = true
		can_fish = true
func _on_player_area_body_exited(body: Node2D) -> void:
	if body.name == "sandcat" and not Quest.player.is_fishing:
		can_fish = false
	if body.name == "sandcat" and not (casting_line or is_reeling):
		body.is_fishing = false

func _on_fishing_area_body_entered(body: Node2D) -> void:
	if body.name == "sandcat":
		body.is_head_wet = true

func _process(delta: float) -> void:
	if can_fish:
		camera.zoom = camera.zoom.lerp(Vector2(0.4,0.4), 1 * delta)
	
	if pick_up_anim:
			fish_velocity += Vector2(0, 2000) * delta
			fish_velocity *= 0.95 # drag
			fish.position += fish_velocity * delta
			timer += delta
			if timer > 1:
				fish.visible = false
	
	if not Quest.player.is_fishing:
		fishing_line.points[0] = Vector2(233.0, -240.0)
		fishing_line.points[1] = Vector2(200.0, -20.0)
		return
	
	# can press 'interact' for x amount of time to adjust velocity
	# point2 of fishing line starts at (290, -260) when 'interact' is released
	# continues moving until fishing area is hit
	# camera zooms out dynamically
	if Input.is_action_just_pressed("interact") and can_fish:
		casting_line = true
		Quest.player.is_casting_line = true
		fishing_line.points[1] = start_pos
		velocity = Vector2(randf_range(-500, -450), randf_range(-300, -350))
		can_fish = false
	
	if casting_line and Input.is_action_pressed("interact") and cast_timer<cast_time:
		cast_timer += delta
		fishing_line.points[1] += velocity * delta
	elif casting_line:
		velocity += gravity * delta
		velocity *= drag  # slow it down
		fishing_line.points[1] += velocity * delta
		camera.offset = camera.offset.lerp(Vector2(0 + velocity.x, -200), 1 * delta)
		
		# when fishing area is hit, start random timer between 1-3 secs
		if fishing_line.points[1].y > 45:
			cast_timer = 0
			casting_line = false
			Quest.player.is_casting_line = false
			velocity = Vector2.ZERO
			fish_wait_timer = 0
			fish_wait_time = randf_range(1.5, 4)
			is_waiting = true
	
	if fish_wait_timer < fish_wait_time and is_waiting:
		fish_wait_timer += delta
	elif is_waiting:
		if not audio_stream_fish_caught.playing:
			audio_stream_fish_caught.play()
		is_waiting = false
		fish_time = randf_range(1, 3)
		water_splash.position = fishing_line.points[1] + Vector2(0, -120)
		water_splash.visible = true
		fish_timer = 0
		is_reeling = true
	
	# THEN, fish bites, camera zoom in
	# a few seconds in which the player must hold 'interact'
		# if either are not met, fish not caught
		# player speed very slow
		# fishing line point1 is set to (-415, -88) relative to player pos
		# point2 remains in the same place
	if fish_timer < fish_time:
		camera.zoom = camera.zoom.lerp(Vector2(0.8,0.8), fish_time * delta)
		fish_timer += delta
	if fish_timer < fish_time and Input.is_action_pressed("interact") and is_reeling:
		if not audio_stream_line.playing:
			audio_stream_line.play()
		var global_point = Quest.player.global_position + Vector2(-90, -20)
		fishing_line.set_point_position(0, fishing_line.to_local(global_point))
		Quest.player.animated_sprite.play("fish" + ArtStyle.artstyle)
		Quest.player.animated_sprite.flip_h = false
	elif fish_timer < fish_time and Input.is_action_just_released("interact"):
		audio_stream_line.stop()
		Quest.player.is_fishing = false
		is_reeling = false
		water_splash.visible = false
	elif fish_timer > fish_time and Input.is_action_pressed("interact") and is_reeling:
		audio_stream_line.stop()
		var new_fish: Item = Item.new()
		new_fish.id = "Fish"
		new_fish.cost = 5
		new_fish.desc = "Best sold to Mocha, Sandcat isn't excalty... a fan."
		new_fish.quantity = 1
		new_fish.icon = preload("res://assets/style1/inventory/fish_icon.png")
		Quest.add_to_inventory(new_fish)
		Quest.player.is_fishing = false
		is_reeling = false
		water_splash.visible = false
		start_pick_up()
	elif fish_timer > fish_time and is_reeling:
		audio_stream_line.stop()
		Quest.player.is_fishing = false
		is_reeling = false
		water_splash.visible = false
	
	print(Quest.player.is_fishing)

func start_pick_up():
	fish.texture = load("res://assets/style" +ArtStyle.artstyle+ "/inventory/fish.png")
	fish.visible = true
	fish.global_position = Quest.player.global_position
	
	pick_up_anim = true
	timer = 0
	var target_x = randf_range(-200.0, 200.0)
	var target_y = -700
	
	var flight_time = randf_range(0.8, 1.2)
	
	var vx = 1.5 * (target_x) / flight_time
	var vy = (target_y - fish.position.y - 0.5 * 1500 * flight_time * flight_time) / flight_time
	
	fish_velocity = Vector2(vx, vy)
