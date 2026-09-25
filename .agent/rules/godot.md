# Master Directives: Godot 4.7 & GDScript 2.0 (AI Agent Inviolable Rules)

> **Scope:** These rules are mandatory for any AI coding agent developing, generating, or modifying code and scenes for **Godot Engine 4.7+** projects. Every instruction here is optimized for high token efficiency, architectural correctness, and zero hallucination.

---

## 1. Prime Directives for the AI Agent

1. **You are pairing with a human developer in the Godot Editor:** The developer has the Godot 4.7 Editor running alongside VS Code. Respect the editor's visual strengths (Inspector, 2D/3D viewport, TileMap editor, AnimationPlayer timeline).
2. **Strict GDScript 2.0 Only:** Never emit Python syntax or Godot 3.x deprecated code.
3. **Strict Static Typing:** Always type variable declarations, function parameters, return types, arrays, and dictionaries.
4. **Scene-First Architecture:** Prefer placing persistent components (`Timer`, `AudioStreamPlayer`, `GPUParticles`, `CollisionShape`, UI) in the `.tscn` file so the human developer can tweak curves, sliders, and audio buses visually in the Godot Inspector. Avoid procedurally generating components via code unless creating purely ephemeral entities (e.g. projectile bullets).
5. **Context-Aware Node Referencing:** Guide the developer to choose the cleanest reference pattern:
   - `%UniqueName`: For internal scene components likely to be reorganized or moved into containers.
   - Direct `$Child`: For shallow, permanent, and fixed hierarchies (e.g. immediate `$Sprite2D`).
   - `@export var node`: For external dependencies or designer-assigned references in the Inspector.
   - Groups (`get_first_node_in_group`): For global actor discovery without hardcoded paths.
6. **Mandatory Reload Alert:** Whenever you edit or create a `.tscn` file on disk, you MUST warn the developer to click **Reload** (and NEVER **Resave**) in the Godot Editor.

---

## 2. Inviolable GDScript vs Python Prohibitions

| Prohibited Python Pattern | Mandatory GDScript 4.7 Replacement | Critical Rationale |
| :--- | :--- | :--- |
| `def method(self, x):` | `func method(x: int) -> void:` | GDScript does **NOT** declare `self` as a parameter. |
| `len(collection)` | `collection.size()` | `len()` does not exist in GDScript. |
| `None` | `null` | `None` is a syntax error. |
| `True` / `False` | `true` / `false` | Keywords are strictly lowercase. |
| `import module` | Singletons (`Engine`, `OS`) or `preload("res://...")` | GDScript uses class registration and preloading. |
| `[x for x in list if ...]` | For loops or `arr.filter().map()` | List comprehensions do not exist in GDScript. |
| `try: ... except:` | Return error codes / `Error` enum / assertions | GDScript does **NOT** support exception handling. |
| `print(f"val: {x}")` | `print("val: %s" % x)` or `print(str("val: ", x))` | F-strings do not exist; use `%` format or comma args. |
| `__init__` | `_init(...)` | The constructor is named `_init`. |
| `self.var = 10` in methods | `var_name = 10` (or `self.var` only for setters) | `self` is optional; never use `self` to declare local variables. |

---

## 3. Inviolable Godot 3 vs Godot 4 Prohibitions

| Deprecated Godot 3 Pattern | Mandatory Godot 4.7 Replacement |
| :--- | :--- |
| `yield(timer, "timeout")` | `await timer.timeout` |
| `yield(coroutine(), "completed")` | `await coroutine()` |
| `export(int) var speed = 10` | `@export var speed: int = 10` |
| `onready var sprite = $Sprite` | `@onready var sprite: Sprite2D = $Sprite` |
| `KinematicBody2D` / `KinematicBody` | `CharacterBody2D` / `CharacterBody3D` |
| `move_and_slide(velocity)` | `velocity = ...; move_and_slide()` (no parameters!) |
| `connect("pressed", self, "_on_pressed")` | `pressed.connect(_on_pressed)` (first-class Callable) |
| `setget set_speed, get_speed` | `var speed: float: get = get_speed, set = set_speed` |
| `Spatial` | `Node3D` |
| `File.new()` / `Directory.new()` | `FileAccess.open(...)` / `DirAccess.open(...)` |
| `Array` / `Dictionary` untyped | `Array[Type]` / `Dictionary[KeyType, ValType]` |

---

## 4. Official Declaration Order (Godot Style Guide)

Every `.gd` script must organize its contents strictly in the following 14-step order:

```gdscript
# 01. Tool mode flag
@tool

# 02. Class declaration
class_name PlayerController

# 03. Inheritance
extends CharacterBody2D

# 04. Documentation comment
## Controls player movement, physics, and gameplay states.

# 05. Signals (past tense: health_changed, died)
signal health_changed(new_health: float)
signal died

# 06. Enums
enum State { IDLE, RUNNING, JUMPING, FALLING }

# 07. Constants
const MAX_FALL_SPEED: float = 800.0

# 08. @export variables (categorized with groups)
@export_group("Movement")
@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

# 09. Public variables
var current_state: State = State.IDLE

# 10. Private variables (prefixed with _)
var _health: float = 100.0
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# 11. @onready variables (references)
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var sprite: Sprite2D = $Sprite2D

# 12. Virtual built-in methods (in lifecycle order)
func _init() -> void:
    pass

func _enter_tree() -> void:
    pass

func _ready() -> void:
    _health = 100.0

func _process(delta: float) -> void:
    pass

func _physics_process(delta: float) -> void:
    _apply_gravity(delta)
    move_and_slide()

func _input(event: InputEvent) -> void:
    pass

# 13. Public custom methods
func take_damage(amount: float) -> void:
    _health = max(0.0, _health - amount)
    health_changed.emit(_health)
    if _health <= 0.0:
        died.emit()

# 14. Private custom methods (prefixed with _)
func _apply_gravity(delta: float) -> void:
    if not is_on_floor():
        velocity.y = min(velocity.y + _gravity * delta, MAX_FALL_SPEED)

# 15. Subclasses (if applicable)
class InventoryItem extends RefCounted:
    var item_id: String = ""
```

---

## 5. Scene-First & UI Synchronization Protocol

### 5.1 When to Inject into `.tscn`
* **Inject into `.tscn`:** Timers, Collision Shapes, Audio Players, Particle Systems, RayCasts, AnimationPlayers, UI layouts.
* **Write in `.gd`:** Gameplay logic, movement math, state management, signal wiring, procedural spawns.

### 5.2 Mandatory Reload Warning
When modifying any `.tscn` file, include this exact block in the response:

> [!IMPORTANT]
> **Scene Modified on Disk:** `<scene_path>.tscn` was updated.
> In the Godot Editor, click **Reload** (DO NOT click **Resave**, or the changes will be overwritten).

---

## 6. Testing & Validation Protocol

Always agree with the developer on the preferred verification mode:
* **Interactive Mode:** Fast generation, user presses `F5` (Run Project) or `F6` (Run Current Scene) and pastes back any debugger warnings.
* **Headless CLI Check:** Agent runs `godot --headless --check-only -s <path_to_script.gd>` to ensure zero parse/compilation errors.
* **TDD with GUT:** For mathematical formulas, damage models, inventory calculations, write unit tests extending `GutTest`.
