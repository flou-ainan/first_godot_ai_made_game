class_name Enemy
extends Area2D

## Red square enemy that descends towards the bottom, takes 3-5 hits, and damages player on collision.

signal destroyed(points: int)

const HIT_FLASH_COLOR: Color = Color(1.0, 1.0, 1.0, 1.0)
const BASE_COLOR: Color = Color(0.95, 0.2, 0.2, 1.0)

@export var speed: float = 120.0
@export var hits_to_destroy: int = 3

var _current_hits: int = 0

@onready var _visual: ColorRect = %Visual

func _ready() -> void:
	hits_to_destroy = randi_range(3, 5)
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position.y += speed * delta
	if position.y > 760.0:
		queue_free()

func take_damage(amount: int = 1) -> void:
	_current_hits += amount
	_play_hit_feedback()
	if _current_hits >= hits_to_destroy:
		destroyed.emit(5)
		queue_free()

func _play_hit_feedback() -> void:
	if not _visual:
		return
	_visual.color = HIT_FLASH_COLOR
	var tween := create_tween()
	tween.tween_property(_visual, "color", BASE_COLOR, 0.08)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group(&"bullet") or (area.collision_layer & 2) != 0:
		area.queue_free()
		take_damage(1)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player") or body.name == "Player":
		var main_scene := get_tree().current_scene
		if main_scene and main_scene.has_method(&"damage_player"):
			main_scene.call(&"damage_player", 20.0)
		queue_free()
