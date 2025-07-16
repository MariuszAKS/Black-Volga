extends Node


signal game_started
signal ending_reached
signal stage_changed

var stages: Dictionary = {}
var current_stage: Stage

var bandage_count = 1
var battery_count = 4
var suspicious_person = false


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
	match value:
		"stay_home":
			print("Ending: Stayed home")
		_:
			print("Not prepared ending:", value)
	
	ending_reached.emit()
