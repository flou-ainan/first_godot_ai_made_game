class_name MainScene
extends Node2D

## Main scene controlling the 2D topdown space shooter prototype.

const BulletScene: PackedScene = preload("res://bullet.tscn")

@export_group("Player Settings")
@export var player_speed: float = 420.0
@export var player_acceleration: float = 1400.0
@export var player_friction: float = 900.0

var _player_velocity: Vector2 = Vector2.ZERO
var _shots_fired: int = 0
var _half_player_size: Vector2 = Vector2(16.0, 16.0)

@onready var _player: CharacterBody2D = %Player
@onready var _muzzle: Marker2D = %Muzzle
@onready var _shoot_timer: Timer = %ShootTimer
@onready var _bullets_container: Node2D = %BulletsContainer
@onready var _shots_label: Label = %ShotsLabel

func _ready() -> void:
	_update_hud()

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_shooting()

func _handle_movement(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_vector != Vector2.ZERO:
		_player_velocity = _player_velocity.move_toward(input_vector * player_speed, player_acceleration * delta)
	else:
		_player_velocity = _player_velocity.move_toward(Vector2.ZERO, player_friction * delta)
	
	_player.velocity = _player_velocity
	_player.move_and_slide()
	_player_velocity = _player.velocity
	
	var viewport_rect: Rect2 = get_viewport_rect()
	if viewport_rect.size.x > 0.0 and viewport_rect.size.y > 0.0:
		_player.global_position.x = clampf(_player.global_position.x, _half_player_size.x, viewport_rect.size.x - _half_player_size.x)
		_player.global_position.y = clampf(_player.global_position.y, _half_player_size.y, viewport_rect.size.y - _half_player_size.y)

func _handle_shooting() -> void:
	var wants_to_shoot: bool = Input.is_action_pressed("shoot") or Input.is_action_pressed("ui_accept")
	if wants_to_shoot and _shoot_timer.is_stopped():
		_shoot()

func _shoot() -> void:
	_shoot_timer.start()
	if not BulletScene:
		return
	
	var bullet_instance: Node = BulletScene.instantiate()
	var bullet := bullet_instance as Area2D
	if not bullet:
		return
	
	bullet.global_position = _muzzle.global_position
	_bullets_container.add_child(bullet)
	
	_shots_fired += 1
	_update_hud()

func _update_hud() -> void:
	if _shots_label:
		_shots_label.text = "Shots: %d" % _shots_fired
