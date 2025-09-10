# Global Script - Quest + Inventory
extends Node

var player: Node = null
var inventory: Dictionary = {}
var inventory_ui: Control = null

func add_to_inventory(item: Item):
	if item == null:
		return
	print("Adding " + item.id + " to inventory")
	if item.id in inventory:
		print("cur quantity=" + str(inventory[item.id].quantity))
		print(item)
		print(item.quantity)
		inventory[item.id].quantity += item.quantity
		print("new quantity=" + str(inventory[item.id].quantity))
	else:
		# duplicate item
		var new_item: Item = Item.new()
		new_item.id = item.id
		new_item.cost = item.cost
		new_item.desc = item.desc
		new_item.quantity = item.quantity
		new_item.animation = item.animation
		new_item.icon = item.icon
		inventory[item.id] = new_item

func update_quantity(item_id: String, quantity: int):
	if item_id in inventory:
		inventory[item_id].quantity += quantity
	elif item_id == "Coins":
		var new_item: Item = preload("res://assets/items/coins.tres")
		add_to_inventory(new_item)

func remove_from_inventory(item_id: String, quantity: int):
	if check_item_quanitity(item_id, quantity):
		inventory[item_id].quantity -= quantity
		if inventory[item_id].quantity == 0:
			inventory.erase(item_id)
		return true
	else:
		return false

func check_item_quanitity(item_id: String, quantity: int):
	if item_id in inventory:
		if inventory[item_id].quantity >= quantity:
			return true
	return false

func get_item_quantity(item_id: String):
	if item_id in inventory:
		return inventory[item_id].quantity
	return -1
