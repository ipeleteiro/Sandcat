extends Resource

class_name QuestResource

@export var quest_id: String
@export var quest_name: String
@export var state: String = "not_started"
@export var objective: Objective = null
@export var reward: Item = null


func is_completed() -> bool:
	return objective.is_completed


func complete_collect_obj(item_id: String):
	if objective.target_type == "collect" and objective.target_id == item_id:
		objective.collected_quantity = Quest.get_item_quantity(item_id)
		if objective.collected_quantity >= objective.required_quantity:
			objective.is_completed = true
		else:
			objective.is_completed = false
	if is_completed():
		state = "complete"

func complete_talk_obj():
	if objective.target_type == "talk_to":
		objective.is_completed = true
		state = "complete"

func complete_play_obj():
	if objective.target_type == "play":
		objective.is_completed = true
		state = "complete"

func complete_score_obj():
	if objective.target_type == "score":
		objective.is_completed = true
		state = "complete"
