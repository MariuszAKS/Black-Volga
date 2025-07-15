extends Control


@export var location: RichTextLabel
@export var text: RichTextLabel


@export var items: HBoxContainer

const bandage_texture = preload("res://art/bandage.png")
const battery_texture = preload("res://art/battery.png")

var bandage_count = 1
var battery_count = 4


@export var options: VBoxContainer


func _ready():
    update_location("Home")
    update_text("You are home\nYou will leave home")
    update_items()


func update_location(value: String):
    location.text = value

func update_text(value: String):
    text.text = value

func update_items():
    for item in items.get_children():
        item.queue_free()
    
    for i in range(bandage_count):
        var bandage = TextureRect.new()
        bandage.texture = bandage_texture
        items.add_child(bandage)

    for i in range(battery_count):
        var battery = TextureRect.new()
        battery.texture = battery_texture
        items.add_child(battery)
