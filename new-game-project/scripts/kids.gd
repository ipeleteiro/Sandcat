@tool
extends CharacterBody2D

@onready var sprite = $Nutmeg
@onready var ball: Sprite2D = $Ball
@onready var ball_area: Area2D = $Ball/BallArea
@onready var talking_area = $talking_area

@export var npc_name: String
@export var npc_animation: SpriteFrames
@export var area_offset: int
@export var facing_left: bool
@export var beep: AudioStream
var artstyle = "1"

# Dialogue system
@export var dialogue_resource: Dialogue
@export var dialogue_colour: Color
@export var dialogue_text_colour: Color
var npc_dialogue
var current_dialogue = "1.0" # accessed by npc_name + current_dialogue
# .0 are the base dialogues, .5 are the extra info
# progress to 2., 3., etc by progressing with the quests
var current_index = 0
var current_quest = "" # quests go 0, 1, 2, 3...
var give_reward = false
var reward: Item = null

@onready var dialogue_manager: Node2D = $DialogueManager

# Quest system
@export var quests: Array[QuestResource] = []
var quest_manager: Node2D = null
var unlock_game = false
var playing_game = false
var original_ball_pos

@onready var audio_stream_ball: AudioStreamPlayer2D = $Ball/AudioStreamBall

func _ready() -> void:
	# show in game
	if not Engine.is_editor_hint():
		talking_area.position.x = area_offset
		sprite.sprite_frames = npc_animation
	
	# load dialogue data
	dialogue_resource.load_from_json("res://Resources/Dialogue/dialogue_data.json")
	# initialise dialogue manager
	dialogue_manager.npc = self
	quest_manager = Quest.player.quest_manager
	original_sprite_pos = sprite.position
	original_ball_pos = ball.position
	ball.visible = false
	start_movement()

var tween: Tween
var original_sprite_pos 

func start_movement():
	tween = create_tween().set_loops()
	
	var shake_time = 1
	tween.tween_property(sprite, "position", original_sprite_pos + Vector2(20, 0), shake_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "position", original_sprite_pos + Vector2(-20, 0), shake_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	

func start_dialogue():
	check_quest_status()
	
	npc_dialogue = dialogue_resource.get_npc_dialogue(npc_name)
	if npc_dialogue.is_empty():
		return
	current_quest = get_current_quest() # quests are npc_name + 0/1/2/..
	if current_quest != "" and int(current_quest[-1]) < quests.size():
		var quest = quests[int(current_quest[-1])]
		# all quests immediately start when interacting with characters
		if quest_manager.get_quest(quest.quest_id) == null:
			quest.state = "in_progress"
			quest_manager.add_quest(quest)
	
	dialogue_manager.show_dialogue(self)

func get_current_quest():
	for branch in npc_dialogue:
		if branch["branch_id"] == npc_name + current_dialogue:
			return branch["quest"]
	return null

func check_quest_status():
	# check if NPC's current quest is completed
	if current_quest != "" and int(current_quest) < quests.size():
		var quest = quests[int(current_quest)]
		if quest.is_completed():
			var obj = quest.objective
			var txt = obj.next_dialogue
			current_dialogue = txt.substr(txt.length() - 3, 3)
			reward = quest.reward
			give_reward = true
			return
	# should work that if an NPC has a completed quest AND an active talk-to
	# quest, then the dialogue of the completed quest is shown first
	
	# check if NPC is part of talk-to quest
	for quest in quest_manager.active_talk_quests():
		var obj = quest.objective
		if npc_name in obj.target_dialogue:
			quest.complete_talk_obj()
		

func get_current_dialogue():
	for branch in npc_dialogue:
		if branch["branch_id"] == npc_name + current_dialogue:
			if branch["text"].size() > current_index:
				return branch["text"][current_index]
	return null

func next_dialogue():
	# progress to next dialogue, triggered when interacting with NPC
	current_index += 1
	if get_current_dialogue() == null:
		# if the main branch is complete, go to extra
		if current_dialogue[-1] == "0":
			# need to talk to kids once before unlocking game
			unlock_game = true 
			Quest.player.can_play = true
			current_dialogue[-1] = "5"
			
			# if there's a reward to be given, give it
			if give_reward and reward != null:
				give_reward = false
				Quest.add_to_inventory(reward)
				for quest in quest_manager.active_collect_quests():
					quest.complete_collect_obj(reward.id)
			
		# either way, reset the index to 0 to restart convo
		current_index = 0

func set_current_dialogue(new_dialogue):
	current_dialogue = new_dialogue

func end_dialogue():
	dialogue_manager.hide_dialogue()

var hits = 0
var ball_velocity = Vector2.ZERO
var gravity = Vector2(0,2000)
var drag = 0.95
var nutmeg_moving = false
var ball_rotation_speed: float = 0.0

func start_game():
	if unlock_game:
		for quest in quest_manager.active_quests():
			var obj: Objective = quest.objective
			if obj.target_type == "play":
				quest.complete_play_obj()
		
		ball.visible = true
		playing_game = true
		ball.position = original_ball_pos
		hits = 0
		tween.kill()
		talking_area.monitoring = false
		ball_area.monitorable = true
		hit_ball_to_player()

func end_game():
	if hits >= 20:
		for quest in quest_manager.active_quests():
			var obj: Objective = quest.objective
			if obj.target_type == "score":
				quest.complete_score_obj()
	playing_game = false
	talking_area.monitoring = true
	ball_area.monitorable = false
	ball.visible = false
	# return sprite to original position
	tween = create_tween()
	tween.tween_property(sprite, "position", original_sprite_pos, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.kill()
	start_movement()

# triggered when nutmeg area is hit
func hit_ball_to_player():    
	# Random landing point around player head
	var target_x = randf_range(-1200.0, -500.0)
	var target_y = -1000
	var flight_time = randf_range(0.8, 1.2)
	
	if sprite.position.x < 0:
		target_x += 200
	
	var vx = 1.5 * (target_x) / flight_time
	var vy = (target_y - ball.position.y - 0.5 * gravity.y * flight_time * flight_time) / flight_time
	
	ball_velocity = Vector2(vx, vy)
	hits += 1
	nutmeg_moving = false
	
	ball_rotation_speed = randf_range(-2.0, 2.0) * ball_velocity.length() / 1000.0
	audio_stream_ball.play()

# triggered in player side when area is hit
func hit_ball_to_nutmeg():
	# Random landing point around NPC head
	var target_x = randf_range(500.0, 1200.0)
	var target_y = -1000
	var flight_time = randf_range(0.8, 1.2)
	
	var vx = 1.5 * (target_x) / flight_time
	var vy = (target_y - ball.position.y - 0.5 * gravity.y * flight_time * flight_time) / flight_time
	
	ball_velocity = Vector2(vx, vy)
	hits += 1
	nutmeg_moving = true
	
	ball_rotation_speed = randf_range(-2.0, 2.0) * ball_velocity.length() / 1000.0
	audio_stream_ball.play()

var timer = 0
var game_over = false

func _process(delta: float) -> void:
	# show in editor
	if Engine.is_editor_hint():
		talking_area.position.x = area_offset
		sprite.sprite_frames = npc_animation
	else:
		artstyle = ArtStyle.artstyle
		sprite.play("idle" + artstyle)
		
		if playing_game:
			ball.texture = load("res://assets/style" +ArtStyle.artstyle+ "/other/ball.png")
			ball.visible = true
			# ball movement
			ball_velocity += gravity * delta
			ball_velocity *= drag
			ball.position += ball_velocity * delta
			ball.rotation += ball_rotation_speed * delta
			
			# nutmeg movement
			if nutmeg_moving:
				var nutmeg_velocity = 1.2 * Vector2(ball.position.x - sprite.position.x,0)
				if ball.position.x - sprite.position.x > 0:
					nutmeg_velocity += Vector2(100,0)
				elif ball.position.x - sprite.position.x < 0:
					nutmeg_velocity -= Vector2(-100,0)
				sprite.position += nutmeg_velocity * delta
			
			# if ball gets too low
			if ball.position.y > -10:
				end_game()
				dialogue_manager.show_dialogue(self, "Nice we got "+ str(hits) +" hits!")
				game_over = true
				timer = 0
			
		if game_over:
			timer += delta
			if timer > 2:
				game_over = false
				dialogue_manager.hide_dialogue()

func _on_talking_area_body_entered(body: Node2D) -> void:
	if body.name == "sandcat":
		body.can_interact = true
		body.interacting_with = self
		body.should_face_left = facing_left
		if unlock_game:
			body.can_play = true

func _on_talking_area_body_exited(body: Node2D) -> void:
	if body.name == "sandcat":
		body.can_interact = false
		body.can_play = false

func _on_ball_area_body_entered(body: Node2D) -> void:
	if body.name == "sandcat" and ball.position.y < -200:
		hit_ball_to_nutmeg()

func _on_nutmeg_hit_area_entered(area: Area2D) -> void:
	if area.name == "BallArea":
		hit_ball_to_player()
