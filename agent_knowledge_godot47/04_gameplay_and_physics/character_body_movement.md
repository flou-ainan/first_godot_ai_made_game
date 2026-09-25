# CharacterBody2D & CharacterBody3D Movement (Godot 4.7)

In Godot 4, `KinematicBody` is completely replaced by `CharacterBody2D` and `CharacterBody3D`. This document covers canonical physics movement implementations.

---

## 1. Fundamental Godot 4 Changes

1. **`velocity` is a built-in property:** You assign directly to `velocity` (e.g. `velocity.x = 200.0` or `velocity = Vector3(...)`).
2. **`move_and_slide()` takes ZERO arguments:**
   * **WRONG (Godot 3):** `velocity = move_and_slide(velocity, Vector2.UP)`
   * **CORRECT (Godot 4.7):** `move_and_slide()`
3. **Delta multiplication:**
   * `velocity` is automatically integrated with `delta` by `move_and_slide()`. Do **not** multiply final velocity by delta when passing it to `move_and_slide()`.
   * Gravity and accelerations **must** be multiplied by `delta` when updating velocity.

---

## 2. Canonical 2D Platformer Character

```gdscript
class_name Player2D
extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -420.0

@export var acceleration: float = 1800.0
@export var friction: float = 1400.0

var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var coyote_timer: Timer = %CoyoteTimer

func _physics_process(delta: float) -> void:
    # 1. Apply Gravity
    if not is_on_floor():
        velocity.y += _gravity * delta
    
    # 2. Handle Jump with Coyote Time
    if Input.is_action_just_pressed("jump"):
        if is_on_floor() or not coyote_timer.is_stopped():
            velocity.y = JUMP_VELOCITY
            coyote_timer.stop()
    
    # 3. Horizontal Movement
    var direction := Input.get_axis("move_left", "move_right")
    if direction != 0.0:
        velocity.x = move_toward(velocity.x, direction * SPEED, acceleration * delta)
    else:
        velocity.x = move_toward(velocity.x, 0.0, friction * delta)
    
    # 4. Check floor status before move for coyote time
    var was_on_floor := is_on_floor()
    
    # 5. Move
    move_and_slide()
    
    # 6. Trigger coyote timer when walking off a ledge
    if was_on_floor and not is_on_floor() and velocity.y >= 0.0:
        coyote_timer.start()
```

---

## 3. Canonical 3D Character Controller

```gdscript
class_name Player3D
extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_pivot: Node3D = %CameraPivot

func _physics_process(delta: float) -> void:
    # 1. Apply Gravity
    if not is_on_floor():
        velocity.y -= _gravity * delta
    
    # 2. Handle Jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY
    
    # 3. Handle 3D Movement relative to Camera orientation
    var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var camera_basis := camera_pivot.global_transform.basis
    var forward := -camera_basis.z
    var right := camera_basis.x
    forward.y = 0.0
    right.y = 0.0
    forward = forward.normalized()
    right = right.normalized()
    
    var direction := (forward * -input_dir.y + right * input_dir.x).normalized()
    if direction != Vector3.ZERO:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0.0, SPEED)
        velocity.z = move_toward(velocity.z, 0.0, SPEED)
        
    move_and_slide()
```
