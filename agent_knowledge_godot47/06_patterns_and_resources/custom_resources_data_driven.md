# Data-Driven Design with Custom Resources (Godot 4.7)

Custom `Resource` classes are one of Godot's most powerful architectural features. They allow you to create data-driven systems (items, weapons, dialogue, stats) without database bloat.

---

## 1. Defining a Custom Resource

Declare a script inheriting from `Resource` with a `class_name`:

```gdscript
class_name ItemData
extends Resource

@export var id: StringName = &"potion_health"
@export var display_name: String = "Health Potion"
@export_multiline var description: String = "Restores 50 HP upon consumption."
@export var icon: Texture2D
@export_range(1, 99) var max_stack: int = 20
@export var heal_amount: float = 50.0
```

Once defined, this resource type will appear in Godot's **Create New Resource** menu in the FileSystem dock!

---

## 2. Using Custom Resources in Nodes

Attach the resource to an entity via `@export`:

```gdscript
class_name InventorySlot
extends Node

@export var item_data: ItemData

func use_item(target: HealthComponent) -> void:
    if item_data:
        target.heal(item_data.heal_amount)
```

---

## 3. The Resource Duplication Gotcha (`duplicate()`)

By default, Godot **shares resource references**:
* If `Enemy A` and `Enemy B` are both assigned the same `enemy_stats.tres` resource in the Inspector, modifying `stats.health -= 10` on Enemy A will also reduce the health of Enemy B!

### Solution:
When an entity modifies its own resource state at runtime, call `.duplicate()`:

```gdscript
class_name Enemy
extends CharacterBody2D

@export var base_stats: EnemyStats
var current_stats: EnemyStats

func _ready() -> void:
    if base_stats:
        # Create an independent, unique copy for this specific instance
        current_stats = base_stats.duplicate()
```
