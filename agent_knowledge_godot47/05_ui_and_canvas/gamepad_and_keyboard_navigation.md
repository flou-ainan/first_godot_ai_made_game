# Gamepad & Keyboard UI Navigation (Godot 4.7)

Ensuring user interfaces work seamlessly with both mouse clicks and gamepad/keyboard navigation is essential for console, Steam Deck, and accessible PC games.

---

## 1. Focus Modes (`focus_mode`)

Every `Control` node has a `focus_mode` property:

| Mode | Enum / Value | Behavior |
| :--- | :--- | :--- |
| **`FOCUS_NONE`** | `0` | Cannot receive keyboard/gamepad focus. Used for Labels, Panel backgrounds. |
| **`FOCUS_CLICK`**| `1` | Can only be focused via mouse click. |
| **`FOCUS_ALL`**  | `2` | Can be focused via Tab, arrow keys, Gamepad D-pad, AND mouse clicks. **Mandatory for all buttons and sliders in interactive menus.** |

In `.tscn` files:
```ini
[node name="StartButton" type="Button" parent="VBoxContainer"]
layout_mode = 2
focus_mode = 2
text = "Start Game"
```

---

## 2. Grabbing Initial Focus

When opening a menu or pause screen, Godot does not automatically select a button. You **must** explicitly call `grab_focus()` on the default button:

```gdscript
class_name PauseMenu
extends Control

@onready var resume_button: Button = %ResumeButton

func open_menu() -> void:
    show()
    # Always call grab_focus() so the controller/keyboard cursor appears immediately
    resume_button.grab_focus()
```

---

## 3. Explicit Focus Neighbors

By default, Godot calculates navigation automatically based on geometric distance. If a menu layout causes the focus to jump unpredictably, define explicit neighbors:

```gdscript
func setup_custom_navigation() -> void:
    # Set explicit navigation loop
    resume_button.focus_neighbor_bottom = options_button.get_path()
    options_button.focus_neighbor_top = resume_button.get_path()
    options_button.focus_neighbor_bottom = quit_button.get_path()
    quit_button.focus_neighbor_top = options_button.get_path()
```

---

## 4. Handling the "Back" Button (`ui_cancel`)

Always listen for the standard `ui_cancel` action (B on Xbox, Circle on PlayStation, Escape on Keyboard):

```gdscript
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel") and visible:
        close_menu()
        get_viewport().set_input_as_handled()
```
