class_name GameSpace
extends Node2D

## Main topdown space shooter scene managing gameplay space, player events, and HUD.

const PlayerClass = preload("res://src/player/player.gd")

var _shots_fired: int = 0

@onready var _player: CharacterBody2D = %Player
@onready var _shots_label: Label = %ShotsLabel

func _ready() -> void:
	if _player and _player.has_signal(&"bullet_fired"):
		_player.connect(&"bullet_fired", _on_player_bullet_fired)
	_update_hud()

func _on_player_bullet_fired(_bullet: Area2D) -> void:
	_shots_fired += 1
	_update_hud()

func _update_hud() -> void:
	if _shots_label:
		_shots_label.text = "Shots Fired: %d" % _shots_fired
