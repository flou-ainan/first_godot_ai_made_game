class_name Bullet
extends Area2D

## Projectile fired by the player spaceship towards the top of the screen.

@export var speed: float = 750.0
@export var direction: Vector2 = Vector2.UP

@onready var _screen_notifier: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D

func _ready() -> void:
	_screen_notifier.screen_exited.connect(_on_screen_exited)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_screen_exited() -> void:
	queue_free()
