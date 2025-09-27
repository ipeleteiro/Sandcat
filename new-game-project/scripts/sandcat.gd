extends CharacterBody2D


var speed = 800.0
var jump_velocity = -600.0
var jump_time = 0.25
var coyote_time = 0.075
var gravity_multiplier = 2.00

var is_jumping = false
var jump_timer = 0
var coyote_timer = 0
var prejump_timer = 0

var is_down = false
var is_scared = false
var crow_direction
var crow_count = 0
var is_fishing = false
var is_casting_line = false

var is_taken_by_crow = false
var can_end_game = false

# audio streams
@onready var audio_stream_walking: AudioStreamPlayer2D = $AudioStreamWalking
@onready var audio_stream_jump: AudioStreamPlayer2D = $AudioStreamJump
@onready var audio_stream_lie_down: AudioStreamPlayer2D = $AudioStreamLieDown
@onready var audio_stream_shake: AudioStreamPlayer2D = $AudioStreamShake


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var artstyle = "1"
@onready var down_collision: CollisionShape2D = $down_collision
@onready var up_collision: CollisionShape2D = $up_collision
@onready var sprint_collision: CollisionPolygon2D = $sprint_collision

# camera
@onready var camera: Camera2D = $Camera2D
# Quest Manager
@onready var quest_manager: Node2D = $QuestManager
# Hit area for Nutmeg game
@onready var player_hit: Area2D = $PlayerHit

func _ready() -> void:
	Quest.player = self
	player_hit.monitoring = false
	crow_count = 0

func _physics_process(delta: float) -> void:
	artstyle = ArtStyle.artstyle
	
	# check if the player wants to interact with NPC
	interact()
	# check if can play nutmeg's game
	nutmeg_game()
	
	# camera zoom
	if can_interact or is_scared or can_end_game:
		camera.zoom = camera.zoom.lerp(Vector2(0.8,0.8), 1 * delta)
		camera.offset = camera.offset.lerp(Vector2(0, -100), 1 * delta) 
	elif not is_fishing: # camera for fishing dealt with separately
		camera.zoom = camera.zoom.lerp(Vector2(0.5,0.5), 1 * delta)
		camera.offset = camera.offset.lerp(Vector2(0, -200), 1 * delta)
	
	
	# Add the gravity.
	if not is_on_floor() and not is_jumping:
		velocity += get_gravity() * delta * gravity_multiplier
		coyote_timer += delta
	else:
		coyote_timer = 0


	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	# manage movement
	if shake_off and shake_off_timer < shake_off_max:
		# play sfx
		if not audio_stream_shake.playing:
			audio_stream_shake.play()
		animated_sprite.play("shake" + artstyle)
		shake_off_timer += delta
		velocity.x = 0
		velocity += get_gravity() * delta * gravity_multiplier
	elif is_interacting:
		shake_off_timer = 0
		shake_off = false
		velocity.x = 0
		velocity += get_gravity() * delta * gravity_multiplier
	elif is_scared:
		is_down = false
		shake_off_timer = 0
		shake_off = false
		velocity = crow_direction * 300
		animated_sprite.play("scared" + artstyle)
	elif is_casting_line:
		velocity.x = 0
		velocity += get_gravity() * delta * gravity_multiplier
	elif not is_taken_by_crow:
		speed = 800
		shake_off_timer = 0
		shake_off = false
		
		jump(delta)
		sprint()
		down()
		if is_down:
			speed = 500
			is_head_wet = false
		if is_fishing:
			speed = 100
		
		if direction:
			#play sound
			velocity.x = direction * speed
			if not audio_stream_walking.playing:
				audio_stream_walking.play()
		else:
			#stop sound
			audio_stream_walking.stop()
			velocity.x = move_toward(velocity.x, 0, speed)
		
		if not is_on_floor():
			audio_stream_walking.stop()
		
		if is_head_wet:
			head_wet(delta)
	
	
	
	# flip sprite
	if direction>0:
		animated_sprite.flip_h = false
	elif direction<0:
		animated_sprite.flip_h = true
	
	# handle animations
	if not is_down and not shake_off and not is_scared and not is_taken_by_crow: # down/shake have specific animation
		if is_jumping:
			animated_sprite.play("prejump" + artstyle)
		elif not is_on_floor():
			animated_sprite.play("fall" + artstyle)
		elif is_sprinting:
			animated_sprite.play("sprint" + artstyle)
		elif is_interacting:
			animated_sprite.flip_h = should_face_left # ensure talking in right direction
			animated_sprite.play("idle" + artstyle)
		elif direction == 0:
			if is_head_wet:
				animated_sprite.play("idle_wet" + artstyle)
			else:
				animated_sprite.play("idle" + artstyle)
		else:
			if is_head_wet:
				animated_sprite.play("run_wet" + artstyle)
			else:
				animated_sprite.play("run" + artstyle)
	
	# collision shapes
	if is_down:
		up_collision.disabled = true
		sprint_collision.disabled = true
		down_collision.disabled = false
	elif is_sprinting:
		up_collision.disabled = true
		sprint_collision.disabled = false
		down_collision.disabled = true
	else:
		up_collision.disabled = false
		sprint_collision.disabled = true
		down_collision.disabled = true
	
	move_and_slide()


func jump(delta: float):
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer<coyote_time):
		audio_stream_jump.play()
		if is_down:
			is_down = false
		velocity.y = jump_velocity
		is_jumping = true
	elif Input.is_action_pressed("jump") and is_jumping:
		velocity.y = jump_velocity
	
	if is_jumping and Input.is_action_pressed("jump") and jump_timer<jump_time:
		jump_timer += delta
	else:
		is_jumping = false
		jump_timer = 0

func down():
	if Input.is_action_pressed("down") and not is_down and not is_scared:
		audio_stream_lie_down.play()
		is_down = true
		animated_sprite.play("down" + artstyle)

var is_sprinting = false

func sprint():
	if Input.is_action_pressed("sprint") and is_head_wet:
		is_sprinting = true
		speed = 1100
	else:
		is_sprinting = false
		

var is_head_wet = false
var head_wet_timer = 0
var head_wet_max = 5
var shake_off = false
var shake_off_timer = 0
var shake_off_max = 1


func head_wet(delta: float):
	head_wet_timer += delta
	if head_wet_timer > head_wet_max:
		is_head_wet = false
		head_wet_timer = 0
		shake_off = true
		is_sprinting = false


# interacting with characters
var can_interact = false
var interacting_with = null
var should_face_left = false
var is_interacting = false
var is_in_shop = false

func interact():
	if Input.is_action_just_pressed("interact") and is_interacting:
		# Mocha (shop seller) should keep 'interacting' if in shop 
		if interacting_with.npc_name == "Mocha":
			if not is_in_shop:
				interacting_with.next_dialogue()
				interacting_with.start_dialogue()
			if interacting_with.current_index == 0:
				interacting_with.end_dialogue()
				if not is_in_shop:
					is_interacting = false
		
		# normal npc
		else:
			# if interact is pressed again, go to next dialogue
			interacting_with.next_dialogue()
			interacting_with.start_dialogue() # show (next) dialogue
			if interacting_with.current_index == 0:
				interacting_with.end_dialogue()
				is_interacting = false
	elif Input.is_action_just_pressed("interact") and can_interact:
		# if not interacting yet, start dialogue
		is_interacting = true
		interacting_with.start_dialogue()


var is_playing = false
var can_play = false

func nutmeg_game():
	if Input.is_action_just_pressed("interact2") and can_play:
		player_hit.monitoring = true
		is_playing = true
		interacting_with.start_game()

func _on_player_hit_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		interacting_with.hit_ball_to_nutmeg()

func reset():
	speed = 800.0
	jump_velocity = -600.0
	jump_time = 0.25
	coyote_time = 0.075
	gravity_multiplier = 2.00

	is_jumping = false
	jump_timer = 0
	coyote_timer = 0
	prejump_timer = 0

	is_down = false
	is_scared = false
	crow_direction
	crow_count = 0
	is_fishing = false
	is_casting_line = false

	is_taken_by_crow = false
	can_end_game = false
	can_interact = false
	interacting_with = null
	should_face_left = false
	is_interacting = false
	is_in_shop = false
	
	is_head_wet = false
	head_wet_timer = 0
	head_wet_max = 5
	shake_off = false
	shake_off_timer = 0
	shake_off_max = 1
