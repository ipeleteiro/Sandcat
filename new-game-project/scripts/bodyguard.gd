@tool
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var talking_area = $talking_area
@onready var wall_collision: CollisionShape2D = $Wall/WallCollision

@export var npc_name: String
@export var npc_animation: SpriteFrames
@export var area_offset: int
@export var height_offset: int
@export var wall_offset: int
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

func _ready() -> void:
	# show in game
	if not Engine.is_editor_hint():
		talking_area.position.x = area_offset
		wall_collision.position.x = wall_offset
		sprite.position.y = height_offset
		sprite.sprite_frames = npc_animation
	wall_collision.disabled = false
	
	# load dialogue data
	dialogue_resource.load_from_json("res://Resources/Dialogue/dialogue_data.json")
	# initialise dialogue manager
	dialogue_manager.npc = self
	quest_manager = Quest.player.quest_manager

func start_dialogue():
	check_quest_status()
	
	npc_dialogue = dialogue_resource.get_npc_dialogue(npc_name)
	if npc_dialogue.is_empty():
		return
	
	var new_quest = get_current_quest() # quests are npc_name + 0/1/2/..
	if new_quest != current_quest:
		# remove items from collect quest
		if current_quest != "" and int(current_quest) < quests.size():
			var cur_quest = quests[int(current_quest)]
			var obj = cur_quest.objective
			if obj.target_type == "collect":
				Quest.remove_from_inventory(obj.target_id, obj.required_quantity)
		
	current_quest = new_quest
	
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
			if branch["quest"] == "":
				wall_collision.disabled = true
			return branch["quest"]
	return ""

func check_quest_status():
	# check if NPC's current quest is completed
	if current_quest != "" and int(current_quest) < quests.size():
		var quest = quests[int(current_quest)]
		var obj = quest.objective
		# make sure that collect objectives are actually fullfilled
		if obj.target_type == "collect":
			quest.complete_collect_obj(obj.target_id)
		
		if quest.is_completed():
			var txt = obj.next_dialogue
			current_dialogue = txt.substr(txt.length() - 3, 3)
			reward = quest.reward
			give_reward = true
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
			current_dialogue[-1] = "5"
		
		# either way, reset the index to 0 to restart convo
		current_index = 0

func set_current_dialogue(new_dialogue):
	current_dialogue = new_dialogue

func end_dialogue():
	# if there's a reward to be given, give it
	if give_reward and reward != null:
		give_reward = false
		Quest.add_to_inventory(reward)
		for quest in quest_manager.active_collect_quests():
			quest.complete_collect_obj(reward.id)
	
	dialogue_manager.hide_dialogue()


func _process(_delta: float) -> void:
	# show in editor
	if Engine.is_editor_hint():
		talking_area.position.x = area_offset
		wall_collision.position.x = wall_offset
		sprite.position.y = height_offset
		sprite.sprite_frames = npc_animation
	else:
		artstyle = ArtStyle.artstyle
		sprite.play("idle" + artstyle)

func _on_talking_area_body_entered(body: Node2D) -> void:
	if body.name == "sandcat":
		body.can_interact = true
		body.interacting_with = self
		body.should_face_left = facing_left

func _on_talking_area_body_exited(body: Node2D) -> void:
	if body.name == "sandcat":
		body.can_interact = false
