# Python vs GDScript 4.7: Syntax Anti-Patterns

Large Language Models (LLMs) trained heavily on Python frequently hallucinate Python syntax into GDScript files. This document details the top failure modes and their mandatory GDScript replacements.

---

## 1. The `self` Parameter in Function Signatures (FATAL ERROR)

* **Python Instinct:** Methods declare `self` as the first parameter.
* **GDScript Reality:** Methods **never** declare `self` in parameters. `self` is an implicit keyword available inside any method.

```gdscript
# WRONG (Python Hallucination - Fails to compile):
func take_damage(self, amount: float):
    self.health -= amount

# CORRECT (GDScript 4.7):
func take_damage(amount: float) -> void:
    health -= amount
```

---

## 2. Function Definitions: `def` vs `func`

* **Python Instinct:** `def my_function():`
* **GDScript Reality:** `func my_function() -> void:`

```gdscript
# WRONG (Python):
def calculate_area(width, height):
    return width * height

# CORRECT (GDScript 4.7):
func calculate_area(width: float, height: float) -> float:
    return width * height
```

---

## 3. Constructors: `__init__` vs `_init`

* **Python Instinct:** `def __init__(self):`
* **GDScript Reality:** `func _init() -> void:` (Single underscore, no double underscore, no `self`).

```gdscript
# WRONG (Python):
def __init__(self, start_hp):
    self.hp = start_hp

# CORRECT (GDScript 4.7):
func _init(start_hp: float = 100.0) -> void:
    hp = start_hp
```

---

## 4. Collection Length: `len()` vs `.size()`

* **Python Instinct:** `len(my_list)`, `len(my_dict)`, `len(my_string)`
* **GDScript Reality:** `my_list.size()`, `my_dict.size()`, `my_string.length()`

```gdscript
# WRONG (Python):
if len(enemies) == 0:
    win()

# CORRECT (GDScript 4.7):
if enemies.is_empty(): # or enemies.size() == 0
    win()
```

---

## 5. List Comprehensions (DO NOT EXIST)

* **Python Instinct:** `[x * 2 for x in numbers if x > 0]`
* **GDScript Reality:** Use explicit `for` loops or functional `.filter()` / `.map()` methods.

```gdscript
# WRONG (Python):
active_units = [u for u in units if u.is_alive()]

# CORRECT OPTION A (Imperative loop):
var active_units: Array[Unit] = []
for u: Unit in units:
    if u.is_alive():
        active_units.append(u)

# CORRECT OPTION B (Functional):
var active_units: Array[Unit] = units.filter(func(u: Unit) -> bool: return u.is_alive())
```

---

## 6. Exception Handling: `try / except` (DO NOT EXIST)

* **Python Instinct:** `try: ... except Exception as e: ...`
* **GDScript Reality:** GDScript **does not have exceptions**. Operations return error codes from the `Error` enum or boolean success flags.

```gdscript
# WRONG (Python):
try:
    file = open("save.dat", "r")
except IOError:
    print("Failed")

# CORRECT (GDScript 4.7):
var file := FileAccess.open("user://save.dat", FileAccess.READ)
var error := FileAccess.get_open_error()
if error != OK:
    printerr("Failed to open file, error code: %s" % error)
    return
var content := file.get_as_text()
```

---

## 7. Boolean & Null Literals

* **Python:** `True`, `False`, `None` (Capitalized)
* **GDScript:** `true`, `false`, `null` (Strictly lowercase)

```gdscript
# WRONG:
is_active = True
target = None

# CORRECT:
is_active = true
target = null
```

---

## 8. String Formatting: F-Strings vs `%` Formatting

* **Python:** `f"Score: {score} - Lives: {lives}"`
* **GDScript:** `"Score: %s - Lives: %s" % [score, lives]` or `str("Score: ", score, " - Lives: ", lives)`

```gdscript
# WRONG (Python f-string):
print(f"Health remaining: {health}")

# CORRECT (GDScript 4.7):
print("Health remaining: %s" % health)
# or
print(str("Health remaining: ", health))
```

---

## 9. Imports: `import` vs `preload` / Global Classes

* **Python Instinct:** `import math`, `from entities.player import Player`
* **GDScript Reality:** 
  - Standard math functions (`sin`, `cos`, `deg_to_rad`, `clamp`) are built-in global functions.
  - Scripts with `class_name MyClass` are globally accessible everywhere without importing.
  - Other scripts are loaded with `preload("res://path/to/script.gd")`.

```gdscript
# WRONG (Python):
import math
import player from "res://player.gd"

# CORRECT (GDScript 4.7):
# 1. Math is global:
var angle_rad := deg_to_rad(90.0)
var clamped_val := clampf(value, 0.0, 100.0)

# 2. Scripts with class_name are globally available automatically:
# Just use Player directly!

# 3. Non-class_name scripts are preloaded:
const EnemyScript = preload("res://enemies/enemy.gd")
```
