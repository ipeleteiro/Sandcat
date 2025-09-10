extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var h_box_container: HBoxContainer = $CanvasLayer/HBoxContainer
@onready var item_name: Label = $CanvasLayer/ItemName
@onready var item_cost: Label = $CanvasLayer/ItemCost
@onready var item_desc: Label = $CanvasLayer/ItemDesc
@onready var warning_label: Label = $CanvasLayer/Warning



var empty: TextureRect = TextureRect.new()
var selected_index = 0
var ui_items: Array
var shop_items: Array[Item]

func _ready() -> void:
	empty.texture = preload("res://assets/style1/inventory/empty_item.png")
	empty.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	warning_label.modulate.a = 0
	hide_shop()

func empty_inventory():
	item_name.text = "Empty Shop"
	item_desc.text = "There's no stuff on sale :("
	h_box_container.add_child(empty)

func display_shop():
	load_inventory()
	Quest.player.is_in_shop = true
	canvas_layer.visible = true

func hide_shop():
	for child in h_box_container.get_children():
		h_box_container.remove_child(child)
	Quest.player.is_in_shop = false
	Quest.player.is_interacting = false
	canvas_layer.visible = false

func load_inventory():
	selected_index = 0
	var first_item = true
	if shop_items.is_empty():
		empty_inventory()
	for item in shop_items:
		var new_item: TextureRect = TextureRect.new()
		new_item.texture = item.icon
		new_item.name = item.id
		new_item.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		h_box_container.add_child(new_item)
		if first_item:
			first_item = false
			item_name.text = item.id + ": " + str(item.quantity)
			item_cost.text = "Cost: " + str(item.cost) + " coins"
			item_desc.text = item.desc
	ui_items = h_box_container.get_children()

func reload_shop():
	for child in h_box_container.get_children():
		h_box_container.remove_child(child)
	for item in shop_items:
		var new_item: TextureRect = TextureRect.new()
		new_item.texture = item.icon
		new_item.name = item.id
		new_item.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		h_box_container.add_child(new_item)
	ui_items = h_box_container.get_children()
	select_item(selected_index)

func _input(event):
	if ui_items.size() > 0 and Quest.player.is_in_shop:
		if event.is_action_pressed("move_right"):
			selected_index = (selected_index + 1) % ui_items.size()
			select_item(selected_index)
		elif event.is_action_pressed("move_left"):
			selected_index = (selected_index - 1) % ui_items.size()
			select_item(selected_index)
		elif event.is_action_pressed("interact"):
			buy_item()
		elif event.is_action_pressed("back") or event.is_action_pressed("menu"):
			hide_shop()

func select_item(index):
	if shop_items.size() == 1:
		index = 0
		selected_index = 0
	var item = shop_items[index]
	if item.id == "Coins":
		item_name.text = item.id
		item_cost.text = "Cost: " + str(item.cost) + " fish"
	else:
		item_name.text = item.id + ": " + str(item.quantity)
		item_cost.text = "Cost: " + str(item.cost) + " coins"
	item_desc.text = item.desc
	if item.quantity == 0:
		item_desc.text = "SOLD OUT"
	
	for ui_item: TextureRect in ui_items:
		if item.id == ui_item.name:
			ui_item.position.y = -10
		else:
			ui_item.position.y = 0

func buy_item():
	# attempt to remove coins from 
	var item = shop_items[selected_index]
	if item.id == "Coins": 
		sell_fish()
		reload_shop()
		return
	if item.quantity < 1:
		warning("Item sold out!")
	elif Quest.remove_from_inventory("Coins", item.cost):
		var new_item: Item = Item.new()
		new_item.id = item.id
		new_item.cost = item.cost
		new_item.desc = item.desc
		new_item.quantity = 1
		new_item.animation = item.animation
		new_item.icon = item.icon
		Quest.add_to_inventory(new_item)
		shop_items[selected_index].quantity -= 1
		warning("Item sold! Enjoy!")
		reload_shop()
	else:
		warning("Not enough coins!")

func sell_fish():
	if Quest.remove_from_inventory("Fish", 1):
		Quest.update_quantity("Coins", 5)
		warning("Fish sold!")
	else:
		warning("Not enough fish :(")

func warning(txt: String):
	warning_label.text = txt
	warning_label.modulate.a = 255
	
	var tween = create_tween()
	tween.tween_property(warning_label, "modulate:a", 0, 1)
	
