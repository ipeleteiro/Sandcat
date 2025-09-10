extends Control

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var item_name: Label = $ItemName
@onready var item_desc: Label = $ItemDesc

var empty: TextureRect = TextureRect.new()
var selected_index = 0
var items: Array

func _ready() -> void:
	empty.texture = preload("res://assets/style1/inventory/empty_item.png")
	empty.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	
	empty_inventory()
	Quest.inventory_ui = self

func empty_inventory():
	item_name.text = "Empty Inventory"
	item_desc.text = "Go find stuff, it's not exactly hidden."
	h_box_container.add_child(empty)

func display_inventory():
	load_inventory()
	self.visible = true

func hide_inventory():
	for child in h_box_container.get_children():
		h_box_container.remove_child(child)
	self.visible = false

func load_inventory():
	selected_index = 0
	var first_item = true
	if Quest.inventory.is_empty():
		empty_inventory()
	for key in Quest.inventory:
		var new_item: TextureRect = TextureRect.new()
		var item: Item = Quest.inventory[key]
		new_item.texture = item.icon
		new_item.name = item.id
		new_item.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		h_box_container.add_child(new_item)
		if first_item:
			first_item = false
			item_name.text = item.id + ": " + str(item.quantity)
			item_desc.text = item.desc
	items = h_box_container.get_children()
	

func _input(event):
	if Quest.inventory.size() > 0:
		if event.is_action_pressed("move_right"):
			selected_index += 1
			select_item(selected_index  % items.size())
		elif event.is_action_pressed("move_left"):
			selected_index -= 1
			select_item(selected_index % items.size())

func select_item(index):
	var item = Quest.inventory.get(items[index].name)
	item_name.text = item.id + ": " + str(item.quantity)
	item_desc.text = item.desc
	
	for ui_item: TextureRect in items:
		if item.id == ui_item.name:
			ui_item.position.y = -10
		else:
			ui_item.position.y = 0
