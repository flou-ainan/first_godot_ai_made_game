# Python vs GDScript 4.7: Built-in & Standard Library Comparison Matrix

Use this matrix for immediate side-by-side translation of standard Python patterns into idiomatic GDScript 4.7.

---

## 1. Syntax & Core Keywords

| Python Construct | GDScript 4.7 Equivalent | Notes |
| :--- | :--- | :--- |
| `def func(a, b):` | `func func(a: Type, b: Type) -> ReturnType:` | Typed parameters and return type |
| `def func(self):` | `func func() -> void:` | Never include `self` in parameter lists |
| `__init__(self)` | `func _init() -> void:` | Constructor name |
| `None` | `null` | Must be lowercase |
| `True` / `False` | `true` / `false` | Must be lowercase |
| `and` / `or` / `not` | `and` / `or` / `not` (or `&&` / `\|\|` / `!`) | Both word and C-style operators supported |
| `elif condition:` | `elif condition:` | Identical |
| `is None` | `== null` | Strict equality check |
| `is not None` | `!= null` (or `is_instance_valid(x)`) | Use `is_instance_valid()` for freed nodes |
| `isinstance(obj, Class)`| `obj is Class` | Direct `is` keyword check |
| `try: ... except:` | Return `Error` / check `if err != OK:` | No exception handling in GDScript |
| `pass` | `pass` | Identical |
| `break` / `continue` | `break` / `continue` | Identical |
| `match val:` / `case:` | `match val:` / `pattern:` | Godot pattern matching |

---

## 2. Arrays & Sequences

| Python List Operation | GDScript 4.7 Array Equivalent | Notes |
| :--- | :--- | :--- |
| `len(arr)` | `arr.size()` | `.is_empty()` to test if zero |
| `arr.append(x)` | `arr.append(x)` or `arr.push_back(x)` | Both valid |
| `arr.pop()` | `arr.pop_back()` | Pops from end |
| `arr.pop(0)` | `arr.pop_front()` | Pops from beginning |
| `arr.insert(i, x)` | `arr.insert(i, x)` | Identical |
| `arr.remove(x)` | `arr.erase(x)` | Erases first matching value |
| `del arr[i]` | `arr.remove_at(i)` | Removes at index |
| `arr.clear()` | `arr.clear()` | Identical |
| `x in arr` | `x in arr` or `arr.has(x)` | Both supported |
| `arr.index(x)` | `arr.find(x)` | Returns `-1` if not found (no exception) |
| `arr.count(x)` | `arr.count(x)` | Identical |
| `arr.sort()` | `arr.sort()` | In-place sort |
| `arr.sort(key=...)` | `arr.sort_custom(callable)` | Custom comparator: `func(a, b): return a < b` |
| `arr.reverse()` | `arr.reverse()` | In-place reverse |
| `arr[start:end]` | `arr.slice(start, end)` | Explicit method |
| `list(range(5))` | `range(5)` | Range creates an Array |
| `[x for x in arr]` | `arr.map(lambda)` | Or use a standard `for` loop |
| `[x for x in arr if c]`| `arr.filter(lambda)` | Or use a standard `for` loop |

---

## 3. Dictionaries & Hash Maps

| Python Dict Operation | GDScript 4.7 Dictionary Equivalent | Notes |
| :--- | :--- | :--- |
| `len(d)` | `d.size()` | `.is_empty()` to test empty |
| `d[key]` | `d[key]` | Throws error if key missing |
| `d.get(key, default)` | `d.get(key, default)` | Identical |
| `key in d` | `key in d` or `d.has(key)` | Both supported |
| `del d[key]` | `d.erase(key)` | Removes key |
| `d.keys()` | `d.keys()` | Returns `Array` of keys |
| `d.values()` | `d.values()` | Returns `Array` of values |
| `d.items()` | Loop `for key in d: var val = d[key]` | No `.items()` iterator |
| `d.clear()` | `d.clear()` | Identical |
| `d.update(other)` | `d.merge(other, true)` | `true` to overwrite duplicates |

---

## 4. Strings & Text

| Python String Operation | GDScript 4.7 String Equivalent | Notes |
| :--- | :--- | :--- |
| `len(s)` | `s.length()` | Note: Arrays use `.size()`, Strings use `.length()` |
| `f"Hello {name}"` | `"Hello %s" % name` | `%` formatting |
| `s.lower()` / `s.upper()`| `s.to_lower()` / `s.to_upper()` | `to_` prefix |
| `s.strip()` | `s.strip_edges()` | Strips leading and trailing whitespace |
| `s.startswith(x)` | `s.begins_with(x)` | Different method name |
| `s.endswith(x)` | `s.ends_with(x)` | Different method name |
| `s.split(",")` | `s.split(",")` | Returns `PackedStringArray` |
| `",".join(arr)` | `",".join(arr)` | Identical |
| `s.replace(a, b)` | `s.replace(a, b)` | Identical |
| `str(num)` | `str(num)` | Identical |
| `int("123")` | `int("123")` or `"123".to_int()` | Both valid |
| `float("1.23")` | `float("1.23")` or `"1.23".to_float()` | Both valid |

---

## 5. Math & Common Libraries

| Python Library / Call | GDScript 4.7 Global Equivalent | Notes |
| :--- | :--- | :--- |
| `math.sin(x)` | `sin(x)` | Global engine function |
| `math.cos(x)` | `cos(x)` | Global engine function |
| `math.tan(x)` | `tan(x)` | Global engine function |
| `math.sqrt(x)` | `sqrt(x)` | Global engine function |
| `math.pi` | `PI` | Built-in constant (`TAU` also available) |
| `math.radians(deg)` | `deg_to_rad(deg)` | Global function |
| `math.degrees(rad)` | `rad_to_deg(rad)` | Global function |
| `min(a, b)` / `max(a, b)`| `min(a, b)` / `max(a, b)` | Global functions |
| `clamp(x, min, max)` | `clamp(x, min, max)` | Global function (`clampf` for floats) |
| `abs(x)` | `abs(x)` | Global function |
| `random.random()` | `randf()` | Returns float between `0.0` and `1.0` |
| `random.randint(a, b)`| `randi_range(a, b)` | Inclusive integer range |
| `random.uniform(a, b)`| `randf_range(a, b)` | Inclusive float range |
| `random.choice(arr)` | `arr.pick_random()` | Array built-in method |
| `random.shuffle(arr)` | `arr.shuffle()` | Array built-in method |

---

## 6. OS, Filesystem & Time

| Python Module | GDScript 4.7 Class Equivalent | Notes |
| :--- | :--- | :--- |
| `open(path, "r")` | `FileAccess.open(path, FileAccess.READ)` | Static factory method |
| `os.path.exists(path)` | `FileAccess.file_exists(path)` or `DirAccess.dir_exists_absolute(path)` | Class methods |
| `os.listdir(path)` | `DirAccess.get_files_at(path)` | Static helper |
| `os.mkdir(path)` | `DirAccess.make_dir_absolute(path)` | Static helper |
| `time.time()` | `Time.get_unix_time_from_system()` | Singleton class |
| `time.sleep(sec)` | `await get_tree().create_timer(sec).timeout` | Non-blocking asynchronous delay |
| `sys.exit()` | `get_tree().quit()` | Clean engine shutdown |
| `print(..., file=sys.stderr)` | `printerr(...)` | Writes to debugger error console |
