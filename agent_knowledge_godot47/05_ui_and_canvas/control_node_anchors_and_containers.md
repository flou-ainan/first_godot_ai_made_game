# Control Nodes, Anchors & Container Layouts (Godot 4.7)

Godot's UI system is built on the `Control` node hierarchy. In Godot 4, responsive UI positioning is driven by **Layout Modes** and **Container Sizing Flags**.

---

## 1. The Two UI Worlds: Anchors vs Containers

| UI Hierarchy Position | Governing System | Layout Mode in `.tscn` | Behavior |
| :--- | :--- | :--- | :--- |
| **Direct Child of Root or Viewport** | **Anchors & Presets** | `layout_mode = 3` | Position and size are relative to the viewport/parent boundaries. |
| **Child of a `Container` Node** | **Size Flags** | `layout_mode = 2` | **Anchors are disabled.** The parent container forces position and size based on `size_flags`. |

> [!WARNING]
> Never attempt to set anchor presets or offsets on a node whose parent is a `VBoxContainer`, `HBoxContainer`, or `GridContainer`. The container will immediately override them. Use `size_flags_horizontal` and `size_flags_vertical` instead.

---

## 2. Anchor Presets & `layout_mode = 3`

When designing full-screen HUDs, modal dialogs, or floating health bars, use anchor presets:

```ini
# Canonical Full-Screen HUD Root in .tscn:
[node name="HUD" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
mouse_filter = 2
```

### 2.1 Critical Property Definitions
* `anchors_preset = 15`: `PRESET_FULL_RECT` (covers 100% of parent).
* `grow_horizontal = 2` / `grow_vertical = 2`: `GROW_DIRECTION_BOTH` (expands outwards symmetrically on resolution change).
* `mouse_filter = 2`: `MOUSE_FILTER_IGNORE` (**CRITICAL:** Prevents an invisible background panel from blocking mouse clicks to the game world!).

---

## 3. Container Sizing Flags (`layout_mode = 2`)

Children inside containers expand or align using bitmask size flags:

| Flag Name | Enum / Integer Value | Visual Result |
| :--- | :--- | :--- |
| `SIZE_SHRINK_BEGIN` | `0` | Align to left / top, shrink to minimum size |
| `SIZE_FILL` | `1` | Fill available allocated cell slot |
| `SIZE_EXPAND` | `2` | Claim extra available space in container |
| `SIZE_EXPAND_FILL` | `3` (`1 \| 2`) | Claim extra space AND fill the entire slot |
| `SIZE_SHRINK_CENTER`| `4` | Center within the slot |
| `SIZE_SHRINK_END` | `8` | Align to right / bottom |

### 3.1 Container Child Example in `.tscn`
```ini
[node name="HealthBar" type="ProgressBar" parent="VBoxContainer"]
custom_minimum_size = Vector2(250, 28)
layout_mode = 2
size_flags_horizontal = 3
size_flags_vertical = 4
```

---

## 4. Mouse Filter Behavior (`mouse_filter`)

The #1 UI bug in Godot is a Control node accidentally intercepting mouse clicks meant for gameplay.

| Filter Mode | Enum Value | Behavior | When to Use |
| :--- | :--- | :--- | :--- |
| **`STOP`** | `0` (Default) | Consumes the mouse event; prevents anything behind from receiving clicks. | Interactive Buttons, Sliders, Text inputs. |
| **`PASS`** | `1` | Consumes event for self, but forwards event to underlying controls. | Semi-interactive containers, draggable zones. |
| **`IGNORE`** | `2` | Transparent to mouse clicks. | **Full-screen HUD roots, decorative panels, labels, reticles.** |
