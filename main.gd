class_name MainScene
extends Control

## Main entry scene for AI pair-programming and editor synchronization verification.

signal button_clicked_count(new_count: int)

var _click_count: int = 0

@onready var test_button: Button = %TestButton
@onready var click_label: Label = %ClickLabel

func _ready() -> void:
	test_button.pressed.connect(_on_test_button_pressed)
	test_button.grab_focus()

func _on_test_button_pressed() -> void:
	_click_count += 1
	click_label.text = "Clicks: %s" % _click_count
	button_clicked_count.emit(_click_count)
