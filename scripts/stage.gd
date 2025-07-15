class_name Stage
extends Node


class StageOption:
	var text: String
	var functions: Array[Callable]

	func _init(_text = "", _functions = []):
		text = _text
		functions = _functions


var location: String
var text: String
var background: String
var options: Array[StageOption]

func _init(_location = "", _text = "", _background = "", _options = []):
	location = _location
	text = _text
	background = _background
	options = _options
