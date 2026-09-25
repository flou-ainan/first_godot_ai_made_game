# Node Referencing Strategies & Context Analysis

In Godot, there is no single dogmatic way to reference nodes. A senior developer evaluates the scene architecture and selects the optimal referencing pattern. This document guides the AI agent and developer in choosing the right tool for each scenario.

---

## 1. Strategy Comparison Matrix

| Strategy | Syntax | Best Used For | Key Advantage | Trade-Off / Risk |
| :--- | :--- | :--- | :--- | :--- |
| **Scene Unique Nodes** | `%NodeName` | Internal scene components, UI buttons, timers, visual effect sub-nodes. | **Immune to hierarchy changes.** Re-parenting or nesting into containers never breaks the script. | Limited strictly to nodes within the same scene root. |
| **Direct Path** | `$ChildNode` | Shallow, permanent, immediate child nodes (e.g. `$Sprite2D`, `$CollisionShape2D`). | Minimal syntax, zero configuration overhead. | **Fragile.** Breaks immediately if the child is moved into a sub-folder or sub-node. |
| **Exported Node** | `@export var node: Node` | External scene references, sibling nodes, or references assigned by level designers. | Total structural decoupling; visual drag-and-drop in Godot Inspector. | Requires manual assignment in the Inspector dock. |
| **Group Query** | `get_tree().get_first_node_in_group("name")` | Cross-scene single actors (e.g. active Player, Camera, Boss). | Zero coupling to scene tree location or parentage. | Slower string-based lookup; requires group tagging. |

---

## 2. In-Depth Strategies & Concrete Code

### 2.1 Scene Unique Nodes (`%UniqueName`)
In Godot 4, right-clicking any node in the Scene dock and selecting **"Access as Unique Name"** marks it with a `%` badge (`unique_name_in_owner = true`).

```gdscript
# Always works regardless of tree depth inside this scene
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var health_bar: ProgressBar = %HealthBar

func _ready() -> void:
    coyote_timer.start()
```
* **When to recommend:** Whenever a node might be wrapped in a `MarginContainer`, moved inside a `SubViewport`, or grouped inside a `Components/` folder.

---

### 2.2 Direct Node Paths (`$ChildNode`)
Direct paths access nodes relative to the current script's node:

```gdscript
# Works only if Sprite2D and CollisionShape2D remain immediate children
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
```
* **When to recommend:** Trivial scenes with 2 or 3 fixed nodes (e.g. a simple Coin pickup containing only an Area2D, a Sprite2D, and a CollisionShape2D).

---

### 2.3 Exported Node References (`@export var target: Node`)
Allows connecting nodes visually in the Godot Inspector dock:

```gdscript
# Can be assigned to ANY node in the active scene via Inspector drag-and-drop
@export var follow_target: Node2D
@export var target_camera: Camera2D

func _physics_process(_delta: float) -> void:
    if is_instance_valid(follow_target):
        global_position = follow_target.global_position
```
* **When to recommend:** Level design scenarios where a trigger zone activates a specific door, an NPC follows a specific waypoint, or a weapon targets an assigned node.

---

### 2.4 Groups for Global Actor Discovery
```gdscript
# In Player.gd:
func _ready() -> void:
    add_to_group("player")

# In EnemyAI.gd:
func find_player() -> Player:
    return get_tree().get_first_node_in_group("player") as Player
```
* **When to recommend:** When a spawned enemy or floating damage number needs to find the player without passing references through multiple layers of parent scenes.
