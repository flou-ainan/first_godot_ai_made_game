# Global Event Bus Pattern (Autoload)

The Event Bus is the premier architecture pattern in Godot for broadcasting notifications across disparate scenes without creating tight coupling.

---

## 1. Defining the Event Bus

Create `singletons/event_bus.gd`:

```gdscript
extends Node

# Gameplay Events
signal player_spawned(player: Node2D)
signal player_died
signal player_health_changed(current: float, maximum: float)
signal score_awarded(points: int)

# Level & Progression Events
signal level_completed(level_index: int)
signal game_paused(is_paused: bool)
```

---

## 2. Registering in `project.godot`

To make it globally accessible across all scripts, add it under `[autoload]` in `project.godot`:

```ini
[autoload]

EventBus="*res://singletons/event_bus.gd"
```

The asterisk `*` denotes that it is enabled as an Autoload singleton.

---

## 3. Emitting & Listening

### Emitting from Anywhere:
```gdscript
# Inside Coin.gd:
func _on_pickup() -> void:
    EventBus.score_awarded.emit(100)
    queue_free()
```

### Listening in Unrelated Systems:
```gdscript
# Inside HUD.gd:
func _ready() -> void:
    EventBus.score_awarded.connect(_on_score_awarded)

func _on_score_awarded(points: int) -> void:
    score += points
    score_label.text = "Score: %s" % score
```

---

## 4. Best Practices for Event Bus
* **Keep signals typed:** Always declare parameter types (`signal score_awarded(points: int)`).
* **Only use for broad broadcasts:** If a signal only concerns a parent and its immediate child, use standard local signals ("Call down, Signal up"). Reserve the Event Bus for cross-system messages (e.g. Gameplay $\rightarrow$ HUD, Player $\rightarrow$ Achievement System).
