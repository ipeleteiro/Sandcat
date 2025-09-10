extends Control

@onready var panel: Panel = $CanvasLayer/Panel
@onready var art_style_button: Control = $CanvasLayer/ArtStyleButton
@onready var art_style_menu: Control = $CanvasLayer/ArtStyleMenu
@onready var inventory_ui: Control = $CanvasLayer/InventoryUI
var is_menu_opened = false

@onready var item_counts: Control = $CanvasLayer/ItemCounts
@onready var coins_num: Label = $CanvasLayer/ItemCounts/CoinsNum
@onready var feather_num: Label = $CanvasLayer/ItemCounts/FeatherNum
@onready var fish_num: Label = $CanvasLayer/ItemCounts/FishNum

@onready var info: Control = $CanvasLayer/Info
@onready var crow_hits: Label = $CanvasLayer/Info/CrowHits
@onready var timer_1: Label = $CanvasLayer/Info/Timer1
@onready var timer_2: Label = $CanvasLayer/Info/Timer2
@onready var timer_3: Label = $CanvasLayer/Info/Timer3

@onready var reset: Button = $CanvasLayer/Reset
@onready var controls: Label = $CanvasLayer/Controls


func _ready() -> void:
	controls.visible = false
	reset.visible = false
	item_counts.visible = false
	info.visible = false
	art_style_button.visible = false
	panel.visible = false
	art_style_menu.visible = false
	inventory_ui.hide_inventory()

func show_menu():
	controls.visible = false
	reset.visible = false
	item_counts.visible = true
	info.visible = false
	art_style_button.visible = true
	panel.visible = false
	art_style_menu.visible = false
	inventory_ui.hide_inventory()

func _process(_delta: float) -> void:
	# update item counts
	coins_num.text = str(Quest.get_item_quantity("Coins"))
	feather_num.text = str(Quest.get_item_quantity("Feather"))
	fish_num.text = str(Quest.get_item_quantity("Fish"))
	
	if coins_num.text == "-1":
		coins_num.text = "0"
	if feather_num.text == "-1":
		feather_num.text = "0"
	if fish_num.text == "-1":
		fish_num.text = "0"
	
	if Input.is_action_just_pressed("menu"):
		if is_menu_opened == false:
			is_menu_opened = true
			pause_game()
		else:
			is_menu_opened = false
			back_to_game()

func pause_game():
	get_tree().paused = true
	controls.visible = true
	reset.visible = true
	item_counts.visible = false
	art_style_button.visible = false
	info.visible = true
	panel.visible = true
	art_style_menu.visible = true
	inventory_ui.display_inventory()

	crow_hits.text = "Number of crow hits: " + str(Quest.player.crow_count)
	timer_1.text = ArtStyle.digital_time()
	timer_2.text = ArtStyle.pixel_time()
	timer_3.text = ArtStyle.pencil_time()

func back_to_game() -> void:
	controls.visible = false
	reset.visible = false
	item_counts.visible = true
	art_style_button.visible = true
	info.visible = false
	panel.visible = false
	art_style_menu.visible = false
	inventory_ui.hide_inventory()
	get_tree().paused = false

func _on_button_pressed() -> void:
	pause_game()


func _on_digital_art_pressed() -> void:
	ArtStyle.artstyle = "1"
	back_to_game() # Go back to level

func _on_pixel_art_pressed() -> void:
	ArtStyle.artstyle = "2"
	back_to_game() # Go back to level

func _on_pencil_art_pressed() -> void:
	ArtStyle.artstyle = "3"
	back_to_game() # Go back to level

func _on_reset_pressed() -> void:
	Quest.player.reset()
	back_to_game()
