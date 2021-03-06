extends Control

signal pressed
signal finished

var isPressed = false
var wasPressed = false
var finishedNow = false

onready var text_node = $Margin/Text

func _ready():
	if Input.is_action_pressed("ui_accept"):
		finishedNow = true
		wasPressed = true
		isPressed = true

func say(text):
	for i in range(len(text)):
		text_node.add_text(text[i])
		$Timer.start()
		yield($Timer, "timeout")
		if Input.is_action_pressed("ui_accept") and not finishedNow:
			text_node.add_text(text.substr(i+1, len(text)-i-1))
			break
	yield(self, "pressed")
	text_node.clear()
	finishedNow = true
	emit_signal("finished")

func _input(event):
	if (event.is_action_pressed("ui_accept")):
		isPressed = true
		if (not wasPressed) and isPressed:
			emit_signal("pressed")
		wasPressed = true
	if (event.is_action_released("ui_accept")):
		isPressed = false
		finishedNow = false
		wasPressed = false