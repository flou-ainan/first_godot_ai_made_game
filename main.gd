class_name MainScene
extends Node2D

## Main scene controlling the 2D topdown space shooter prototype.

const BulletScene: PackedScene = preload("res://bullet.tscn")
const EnemyScene: PackedScene = preload("res://enemy.tscn")

@export_group("Player Physics & Inertia")
@export var player_speed: float = 450.0
@export var player_acceleration: float = 4500.0
@export var player_friction: float = 3800.0

@export_group("Enemy Spawning")
@export var enemy_spawn_interval: float = 2.0
@export var enemy_initial_delay: float = 5.0

var _player_velocity: Vector2 = Vector2.ZERO
var _shots_fired: int = 0
var _score: int = 0
var _max_player_health: float = 100.0
var _player_health: float = 100.0
var _half_player_size: Vector2 = Vector2(16.0, 16.0)

@onready var _player: CharacterBody2D = %Player
@onready var _player_visual: ColorRect = %PlayerVisual
@onready var _muzzle: Marker2D = %Muzzle
@onready var _shoot_timer: Timer = %ShootTimer
@onready var _bullets_container: Node2D = %BulletsContainer
@onready var _enemies_container: Node2D = %EnemiesContainer
@onready var _enemy_spawn_timer: Timer = %EnemySpawnTimer
@onready var _health_bar: ProgressBar = %HealthBar
@onready var _score_label: Label = %ScoreLabel
@onready var _shots_label: Label = %ShotsLabel

func _ready() -> void:
	_update_hud()
	get_tree().create_timer(enemy_initial_delay).timeout.connect(_start_enemy_spawning)

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_shooting()

func damage_player(percentage: float = 20.0) -> void:
	_player_health -= _max_player_health * (percentage / 100.0)
	_play_player_damage_feedback()
	if _player_health <= 0.0:
		_player_health = 0.0
		_update_hud()
		get_tree().reload_current_scene()
		return
	_update_hud()

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

func _start_enemy_spawning() -> void:
	if not is_inside_tree():
		return
	_spawn_enemy()
	if _enemy_spawn_timer:
		_enemy_spawn_timer.wait_time = enemy_spawn_interval
		_enemy_spawn_timer.one_shot = false
		if not _enemy_spawn_timer.timeout.is_connected(_on_enemy_spawn_timer_timeout):
			_enemy_spawn_timer.timeout.connect(_on_enemy_spawn_timer_timeout)
		_enemy_spawn_timer.start()

func _on_enemy_spawn_timer_timeout() -> void:
	_spawn_enemy()

func _spawn_enemy() -> void:
	if not EnemyScene or not _enemies_container:
		return
	
	var enemy_instance: Node = EnemyScene.instantiate()
	var enemy := enemy_instance as Area2D
	if not enemy:
		return
	
	enemy.position = Vector2(randf_range(60.0, 1220.0), -40.0)
	if enemy.has_signal(&"destroyed"):
		enemy.connect(&"destroyed", _on_enemy_destroyed)
	_enemies_container.add_child(enemy)

func _on_enemy_destroyed(points: int) -> void:
	_score += points
	_update_hud()

func _play_player_damage_feedback() -> void:
	if not _player_visual:
		return
	_player_visual.color = Color(1.0, 0.2, 0.2, 1.0)
	var tween := create_tween()
	tween.tween_property(_player_visual, "color", Color(1.0, 1.0, 1.0, 1.0), 0.12)

func _update_hud() -> void:
	if _health_bar:
		_health_bar.value = _player_health
	if _score_label:
		_score_label.text = "Score: %d" % _score
	if _shots_label:
		_shots_label.text = "Shots: %d" % _shots_fired
