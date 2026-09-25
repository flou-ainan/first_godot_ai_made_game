# GDScript 4.7 Type System & Annotations

Godot 4.7 features a robust, compiler-optimized static type system that eliminates runtime errors and accelerates execution.

---

## 1. Static Typing Syntax

### 1.1 Explicit Types vs Type Inference (`:=`)
```gdscript
# Explicit typing (preferred for clarity and public APIs)
var health: float = 100.0
var player_name: String = "Hero"

# Type inference (valid when the assigned value has an unambiguous type)
var direction := Vector2.ZERO
var current_ticks := Time.get_ticks_msec()

# Function parameter & return types (MANDATORY)
func calculate_velocity(input_dir: Vector2, speed: float) -> Vector2:
    return input_dir.normalized() * speed

func reset_state() -> void:
    health = 100.0
```

### 1.2 Typed Arrays and Dictionaries (Godot 4 Feature)
Godot 4 supports fully typed collections:
```gdscript
# Typed Arrays: Array[Type]
var enemies: Array[Node2D] = []
var scores: Array[int] = [10, 25, 90]

# Typed Dictionaries: Dictionary[KeyType, ValueType]
var player_inventory: Dictionary[StringName, int] = {
    &"potion": 5,
    &"arrow": 32,
}
var spawn_table: Dictionary[int, PackedScene] = {}
```

---

## 2. Common Export Annotations (`@export`)

In Godot 4, the old `export(int) var` syntax is completely replaced by `@export` decorators:

```gdscript
# Basic Export
@export var speed: float = 200.0
@export var character_name: String = "Knight"
@export var active: bool = true

# Numeric Range with Step
@export_range(0.0, 100.0, 0.5) var health: float = 100.0
@export_range(1, 10, 1, "or_greater") var lives: int = 3

# String as File or Directory Path
@export_file("*.png", "*.webp") var custom_avatar: String
@export_dir var save_directory: String

# Multiline Text (useful for dialogues or notes)
@export_multiline var quest_dialogue: String

# Enum Export (Dropdown in Inspector)
enum Element { FIRE, WATER, EARTH, AIR }
@export var element_type: Element = Element.FIRE

# Export Grouping & Organizing in the Inspector
@export_group("Combat Stats", "stat_")
@export var stat_damage: float = 25.0
@export var stat_defense: float = 10.0

@export_subgroup("Critical Hits")
@export var stat_crit_rate: float = 0.15
@export var stat_crit_multiplier: float = 2.0
```

---

## 3. Node & Tree Annotations

### `@onready`
Initializes the variable when the node enters the active scene tree and finishes its `_ready()` notification:
```gdscript
# References initialized right before _ready()
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var attack_timer: Timer = %AttackTimer
```

### `@tool`
Instructs Godot that this script runs inside the Godot Editor viewport:
```gdscript
@tool
extends Node2D

@export var circle_radius: float = 50.0:
    set(value):
        circle_radius = value
        queue_redraw()

func _draw() -> void:
    draw_circle(Vector2.ZERO, circle_radius, Color.RED)
```

> [!WARNING]
> In `@tool` scripts, always verify `if Engine.is_editor_hint():` before running gameplay loops or spawning game objects, to prevent editor freeze or unintentional scene contamination.
