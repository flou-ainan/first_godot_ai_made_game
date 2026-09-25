# Signals, Callables, Lambdas & Coroutines (Godot 4.7)

In Godot 4, Signals and Callables are first-class engine types. String-based method calls (`yield`, `"connect"`) are completely obsolete.

---

## 1. First-Class Signals

Signals represent decoupled events. In GDScript 4, they are strongly typed objects.

### 1.1 Declaration & Emission
```gdscript
# Signal declarations with typed arguments
signal health_changed(new_health: float, max_health: float)
signal weapon_swapped(weapon_name: StringName)
signal died

func take_damage(amount: float) -> void:
    var previous := health
    health = max(0.0, health - amount)
    
    # Modern emission syntax (Never use emit_signal("string"))
    health_changed.emit(health, max_health)
    
    if health <= 0.0 and previous > 0.0:
        died.emit()
```

### 1.2 Connection & Disconnection
```gdscript
func _ready() -> void:
    # Connect directly to a Callable (Never use strings!)
    health_changed.connect(_on_health_changed)
    
    # Connect with flags: One-Shot (auto-disconnects after 1 emit)
    died.connect(_on_died, CONNECT_ONE_SHOT)
    
    # Deferred connection (executes on idle frame)
    health_changed.connect(_update_hud, CONNECT_DEFERRED)

func _on_health_changed(new_health: float, _max_health: float) -> void:
    print("Health is now: %s" % new_health)

func _on_died() -> void:
    print("Player died!")

func clean_up() -> void:
    if health_changed.is_connected(_on_health_changed):
        health_changed.disconnect(_on_health_changed)
```

---

## 2. Callables & Lambdas

A `Callable` is an object representing a method or an anonymous function.

### 2.1 Bound Arguments
Pass extra context to a callback using `.bind()`:
```gdscript
func setup_buttons() -> void:
    for i: int in range(button_container.get_child_count()):
        var button := button_container.get_child(i) as Button
        if button:
            # Bind the index i as an argument to _on_button_pressed
            button.pressed.connect(_on_button_pressed.bind(i))

func _on_button_pressed(button_index: int) -> void:
    print("Clicked button at index: %s" % button_index)
```

### 2.2 Anonymous Functions (Lambdas)
```gdscript
func setup_timer() -> void:
    var timer := get_tree().create_timer(3.0)
    timer.timeout.connect(func() -> void:
        print("3 seconds elapsed via inline lambda!")
    )

func filter_enemies(enemy_list: Array[Node2D]) -> Array[Node2D]:
    # Using functional Array operations with lambdas
    return enemy_list.filter(func(enemy: Node2D) -> bool:
        return enemy.global_position.x > 100.0
    )
```

---

## 3. Coroutines with `await`

Godot 4 replaces Godot 3's `yield` with native asynchronous `await`.

### 3.1 Awaiting Signals
```gdscript
func play_hit_reaction() -> void:
    # Wait for a 1-second scene-tree timer
    await get_tree().create_timer(1.0).timeout
    print("Timer finished!")
    
    # Wait for an AnimationPlayer signal
    animation_player.play("stagger")
    await animation_player.animation_finished
    print("Animation finished!")
```

### 3.2 Awaiting Asynchronous Functions
Calling any function containing an `await` turns it into a coroutine:
```gdscript
func load_player_data() -> Dictionary:
    var http_request := HTTPRequest.new()
    add_child(http_request)
    http_request.request("https://api.example.com/player")
    
    # Await response signal
    var response: Array = await http_request.request_completed
    http_request.queue_free()
    return JSON.parse_string(response[3].get_string_from_utf8())

func _ready() -> void:
    # Await the result of the async function
    var data: Dictionary = await load_player_data()
    print("Player data loaded: %s" % data)
```
