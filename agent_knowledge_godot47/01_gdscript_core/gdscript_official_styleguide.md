# GDScript Official Style Guide & Code Ordering (Godot 4.7)

This document encodes the canonical formatting, naming conventions, and file layout rules mandated by the official Godot Engine documentation.

---

## 1. Canonical Code Order (Inviolable 14 Steps)

Every GDScript file must arrange its top-level elements strictly in this order:

```gdscript
# 01. Tool mode flag (only if script runs in editor)
@tool

# 02. Global class registration and optional custom icon
class_name PlayerController
@icon("res://icons/player.svg")

# 03. Inheritance
extends CharacterBody2D

# 04. Documentation comment (double hash ##)
## Controls player 2D physics movement, jumping, and health states.

# 05. Signals (always past tense or event names: health_changed, died)
signal health_changed(new_health: float)
signal died

# 06. Enums (PascalCase enum name, CONSTANT_CASE values)
enum State {
    IDLE,
    RUNNING,
    JUMPING,
    FALLING,
}

# 07. Constants (CONSTANT_CASE)
const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

# 08. Exported variables (@export with groups/subgroups)
@export_group("Stats")
@export var max_health: float = 100.0

@export_group("Physics")
@export_range(100.0, 2000.0, 50.0) var acceleration: float = 1200.0

# 09. Public member variables
var current_health: float = 100.0
var current_state: State = State.IDLE

# 10. Private member variables (prefixed with single underscore _)
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _invulnerable: bool = false

# 11. @onready variables (Scene references)
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var sprite: Sprite2D = $Sprite2D

# 12. Built-in virtual methods (in engine lifecycle order)
func _init() -> void:
    pass

func _enter_tree() -> void:
    pass

func _ready() -> void:
    current_health = max_health

func _process(delta: float) -> void:
    pass

func _physics_process(delta: float) -> void:
    _apply_gravity(delta)
    move_and_slide()

func _input(event: InputEvent) -> void:
    pass

func _unhandled_input(event: InputEvent) -> void:
    pass

func _exit_tree() -> void:
    pass

# 13. Public custom methods
func take_damage(amount: float) -> void:
    if _invulnerable:
        return
    current_health = max(0.0, current_health - amount)
    health_changed.emit(current_health)
    if current_health <= 0.0:
        died.emit()

# 14. Private custom methods (prefixed with single underscore _)
func _apply_gravity(delta: float) -> void:
    if not is_on_floor():
        velocity.y += _gravity * delta

# 15. Inner Subclasses (at the bottom)
class HitData extends RefCounted:
    var damage: float = 0.0
```

---

## 2. Naming Conventions

| Item | Convention | Example |
| :--- | :--- | :--- |
| **Files & Directories** | `snake_case` | `player_controller.gd`, `main_menu.tscn` |
| **Classes & Nodes** | `PascalCase` | `CharacterBody2D`, `PlayerController` |
| **Functions & Variables** | `snake_case` | `take_damage()`, `current_health` |
| **Private Members** | `_snake_case` (leading underscore) | `_health`, `_calculate_trajectory()` |
| **Signals** | `snake_case` (past tense / event) | `weapon_fired`, `target_acquired` |
| **Constants & Enum Values**| `CONSTANT_CASE` | `MAX_SPEED`, `State.JUMPING` |
| **Type Parameters / Enums**| `PascalCase` | `enum WeaponType { PISTOL, RIFLE }` |

---

## 3. Formatting Rules

* **Indentation:** 1 Tab per level (Godot standard).
* **Whitespace around operators:** `var x: int = 10 + y` (never `var x:int=10+y`).
* **Line length:** Soft limit of 100 characters.
* **Docstrings:** Use `##` above classes, properties, and methods for automatic documentation generation by Godot.
