extends Node


signal game_started
signal ending_reached
signal stage_changed

var stages: Dictionary = {}
var current_stage: Stage

var bandage_count = 1
var battery_count = 4
var suspicious_person = false
var ending_image = ""


func _ready():
	game_started.connect(on_game_started)
	prepare_stages_from_json()


func prepare_stages_from_json():
	var file = FileAccess.open("res://stages.json", FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())

	for stage_data in json["stages"]:
		var new_options: Array[Stage.StageOption] = []

		for option_data in stage_data["options"]:
			var new_functions: Array[Callable] = []

			for function_data in option_data["functions"]:
				new_functions.append(Callable(self, function_data["name"]).bindv(function_data["param"]))

			new_options.append(Stage.StageOption.new(option_data["text"], new_functions))

		var new_stage = Stage.new(stage_data["location"], stage_data["text"], stage_data["background"], new_options)

		stages[stage_data["id"]] = new_stage


func on_game_started():
	change_stage("home_start")

func change_stage(stage_id: String):
	if stage_id == "playground_inside" and battery_count >= 2:
		current_stage = stages[stage_id + "_flashlight"]
	elif stage_id == "ending_hut":
		current_stage = stages[stage_id + ("_good" if suspicious_person else "_bad")]
	elif stage_id == "ending_clearing":
		current_stage = stages[stage_id + ("_neutral" if suspicious_person else "_bad")]
	else:
		current_stage = stages[stage_id]
	
	stage_changed.emit()


func set_bandages(value: int):
	bandage_count = value

func set_batteries(value: int):
	battery_count = value

func set_suspicious_person(value: bool):
	suspicious_person = value


func add_bandages(value: int):
	bandage_count += value

func add_batteries(value: int):
	battery_count += value


func execute_ending(value: String):
	ending_image = "ending_" + value + ".png"
	
	ending_reached.emit()
