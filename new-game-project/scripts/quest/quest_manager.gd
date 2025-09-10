extends Node2D

var quests = {}

func add_quest(quest: QuestResource):
	quests[quest.quest_id] = quest

func remove_quest(quest_id: String):
	quests.erase(quest_id)

func get_quest(quest_id: String) -> QuestResource:
	return quests.get(quest_id, null)

func update_quest(quest_id: String, state: String):
	var quest = get_quest(quest_id)
	if quest:
		quest.state = state
		if state == "complete":
			remove_quest(quest_id)

func active_quests() -> Array:
	var active_quests_arr = []
	for quest in quests.values():
		if quest.state == "in_progress":
			active_quests_arr.append(quest)
	return active_quests_arr

func active_talk_quests() -> Array:
	var talk_quests = []
	for quest in quests.values():
		if quest.state == "in_progress":
			if quest.objective.target_type == "talk_to":
				talk_quests.append(quest)
	return talk_quests

func active_collect_quests() -> Array:
	var talk_quests = []
	for quest in quests.values():
		if quest.state == "in_progress":
			if quest.objective.target_type == "collect":
				talk_quests.append(quest)
	return talk_quests

func complete_objective(quest_id: String, obj_id: String):
	var quest = get_quest(quest_id)
	if quest:
		quest.complete_obj(int(obj_id))
