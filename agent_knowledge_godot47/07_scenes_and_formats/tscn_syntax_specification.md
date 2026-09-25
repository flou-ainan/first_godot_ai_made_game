# Godot 4.7 `.tscn` Scene Syntax Specification

Godot scenes are saved as human-readable plain text files (`.tscn`). This document breaks down the internal structure of Godot 4 format 3 scene files.

---

## 1. Anatomy of a `.tscn` File

A standard `.tscn` file consists of 5 distinct sections in order:

```ini
[gd_scene load_steps=3 format=3 uid="uid://c5q3x..."]

[ext_resource type="Script" path="res://player.gd" id="1_script"]
[ext_resource type="Texture2D" path="res://icon.svg" id="2_texture"]

[sub_resource type="CircleShape2D" id="CircleShape2D_1"]
radius = 16.0

[node name="Player" type="CharacterBody2D"]
script = ExtResource("1_script")

[node name="Sprite2D" type="Sprite2D" parent="."]
texture = ExtResource("2_texture")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = SubResource("CircleShape2D_1")

[node name="CoyoteTimer" type="Timer" parent="."]
unique_name_in_owner = true
wait_time = 0.15
one_shot = true

[connection signal="timeout" from="CoyoteTimer" to="." method="_on_coyote_timer_timeout"]
```

---

## 2. Header & Resource Tags

### 2.1 The Header Tag `[gd_scene]`
* `format=3`: Mandated for Godot 4.x.
* `load_steps=N`: The total count of all external resources + sub-resources + 1 (the scene itself).
* `uid="uid://..."`: Unique Identifier used by Godot's asset tracking system. If generating a scene from scratch, the UID can be omitted; Godot will generate one upon saving.

### 2.2 External Resources `[ext_resource]`
Links to files existing independently in the project (`.gd`, `.svg`, `.png`, `.wav`):
```ini
[ext_resource type="Script" path="res://player.gd" id="1_script"]
```

### 2.3 Sub-Resources `[sub_resource]`
Embedded resources created inside the scene itself (e.g. `CircleShape2D`, `StyleBoxFlat`, `Animation`):
```ini
[sub_resource type="CircleShape2D" id="CircleShape2D_1"]
radius = 16.0
```

---

## 3. Node Hierarchy & Attributes

* **Root Node:** Has no `parent` attribute:
  ```ini
  [node name="RootName" type="NodeType"]
  ```
* **Child Nodes:** Specify the relative path to their parent:
  * `parent="."`: Direct child of the root node.
  * `parent="VBoxContainer"`: Child of a node named `VBoxContainer`.
  * `parent="VBoxContainer/MarginContainer"`: Nested child.
* **Scene Unique Nodes:**
  ```ini
  unique_name_in_owner = true
  ```
* **Property Serialization:**
  * Boolean: `true` / `false`
  * Vector2: `Vector2(100, 200)`
  * Colors: `Color(1, 0, 0, 1)`
  * Strings: `"My string"`
  * Resources: `ExtResource("id")` or `SubResource("id")`

---

## 4. Signal Connections `[connection]`

Appears at the very bottom of the file:
```ini
[connection signal="pressed" from="Button" to="." method="_on_button_pressed"]
```
* `signal`: The signal emitted.
* `from`: Node emitting the signal.
* `to`: Target node receiving the call (usually `.` for scene root).
* `method`: Function name on the target node.
