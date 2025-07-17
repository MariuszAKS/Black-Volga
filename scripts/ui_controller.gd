extends Control


@export var background: TextureRect
@export var ending_texture: TextureRect
@export var location: RichTextLabel
@export var text: RichTextLabel
@export var items: HBoxContainer
@export var options: VBoxContainer

const bandage_texture = preload("res://art/bandage.png")
const battery_texture = preload("res://art/battery.png")

@export var menu: Control

func _ready():
	GameController.stage_changed.connect(update_ui)
	GameController.ending_reached.connect(on_ending_reached)
	(menu.get_node("StartButton") as Button).pressed.connect(start_the_game)


func start_the_game():
	GameController.game_started.emit()
	menu.visible = false

func on_ending_reached():
	menu.visible = true
	var foreground_path = "res://art/backgrounds/" + GameController.ending_image
	ending_texture.texture = load(foreground_path) if ResourceLoader.exists(foreground_path) else null


func update_ui():
	location.text = GameController.current_stage.location
	text.text = GameController.current_stage.text

	var background_path = "res://art/backgrounds/" + GameController.current_stage.background
	background.texture = load(background_path) if ResourceLoader.exists(background_path) else null

	update_items()
	update_options()

func update_items():
	for item in items.get_children():
		items.remove_child(item)
		item.queue_free()
	
	for i in range(GameController.bandage_count):
		var bandage = TextureRect.new()
		bandage.texture = bandage_texture
		items.add_child(bandage)

	for i in range(GameController.battery_count):
		var battery = TextureRect.new()
		battery.texture = battery_texture
		items.add_child(battery)

func update_options():
	for option in options.get_children():
		options.remove_child(option)
		option.queue_free()
	
	for new_option_data in GameController.current_stage.options:
		var new_option = Button.new()
		new_option.text = new_option_data.text

		# new_option.pressed.connect(on_option_pressed)
		for function in new_option_data.functions:
			new_option.pressed.connect(function)
		
		options.add_child(new_option)

# func on_option_pressed():
# 	print("option pressed")
