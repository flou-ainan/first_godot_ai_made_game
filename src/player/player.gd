class_name Player
extends CharacterBody2D

## Floating player square controlled via Arrow keys or Gamepad, firing bullets upwards.

const BulletClass = preload("res://src/bullet/bullet.gd")

signal bullet_fired(bullet: Area2D)

@export_group("Movement")
@export var max_speed: float = 420.0
@export var acceleration: float = 1400.0
@export var friction: float = 900.0

@export_group("Combat")
@export var bullet_scene: PackedScene = preload("res://src/bullet/bullet.tscn")

var _half_size: Vector2 = Vector2(16.0, 16.0)

@onready var _muzzle: Marker2D = %Muzzle
@onready var _shoot_timer: Timer = %ShootTimer

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_shooting()
	_clamp_to_viewport()

func _handle_movement(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()

func _handle_shooting() -> void:
	var wants_to_shoot: bool = Input.is_action_pressed("shoot") or Input.is_action_pressed("ui_accept")
	if wants_to_shoot and _shoot_timer.is_stopped():
		_shoot()

func _shoot() -> void:
	_shoot_timer.start()
	if not bullet_scene:
		return
	
	var bullet_instance: Node = bullet_scene.instantiate()
	var bullet := bullet_instance as Area2D
	if not bullet:
		return
	
	bullet.global_position = _muzzle.global_position
	bullet_fired.emit(bullet)
	get_tree().current_scene.add_child(bullet)

func _clamp_to_viewport() -> void:
	var viewport_rect: Rect2 = get_viewport_rect()
	if viewport_rect.size.x > 0.0 and viewport_rect.size.y > 0.0:
		global_position.x = clampf(global_position.x, _half_size.x, viewport_rect.size.x - _half_size.x)
		global_position.y = clampf(global_position.y, _half_size.y, viewport_rect.size.y - _half_size.y)
