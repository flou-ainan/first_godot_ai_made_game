# Autonomous `.tscn` Node Injection Rules (Agent Protocol)

This document establishes the step-by-step protocol for an AI agent to directly inject nodes, components, and connections into existing `.tscn` files without corrupting scene formatting.

---

## 1. When to Inject into `.tscn`

Inject components directly into `.tscn` when:
* Adding a `Timer` (e.g. CoyoteTimer, AttackCooldown, DespawnTimer).
* Adding an `AudioStreamPlayer` or `AudioStreamPlayer2D/3D`.
* Adding a `GPUParticles2D` or `GPUParticles3D` visual effect.
* Adding a `CollisionShape2D/3D` or `RayCast2D/3D`.
* Adding UI buttons, labels, and container structures.

---

## 2. Invariant Rules for Modifying `.tscn` Files

1. **Preserve the Header:** Never alter or remove the `[gd_scene ...]` header.
2. **Handle `load_steps`:** If you add a new `[sub_resource]` or `[ext_resource]`, increment `load_steps=N` by 1 for each added resource.
3. **Parent Hierarchy Accuracy:**
   * If adding under the root node, use `parent="."`.
   * If adding under a child node, use the exact node name: `parent="VBoxContainer"` or `parent="Components"`.
4. **Scene Unique Node Registration:** If the node is meant to be accessed safely by the script regardless of future re-parenting, add:
   ```ini
   unique_name_in_owner = true
   ```
5. **Node Placement Order:** Place the new `[node ...]` block immediately after the sibling nodes of that parent, before the `[connection]` blocks.
6. **Connections at Bottom:** Always append `[connection ...]` lines to the very end of the file.

---

## 3. Concrete Example: Injecting a Timer into an Existing Scene

### Existing Scene Before:
```ini
[gd_scene load_steps=2 format=3 uid="uid://xyz"]

[ext_resource type="Script" path="res://player.gd" id="1_abc"]

[node name="Player" type="CharacterBody2D"]
script = ExtResource("1_abc")

[node name="Sprite2D" type="Sprite2D" parent="."]
```

### Injected Scene After:
```ini
[gd_scene load_steps=2 format=3 uid="uid://xyz"]

[ext_resource type="Script" path="res://player.gd" id="1_abc"]

[node name="Player" type="CharacterBody2D"]
script = ExtResource("1_abc")

[node name="Sprite2D" type="Sprite2D" parent="."]

[node name="AttackTimer" type="Timer" parent="."]
unique_name_in_owner = true
wait_time = 0.5
one_shot = true

[connection signal="timeout" from="AttackTimer" to="." method="_on_attack_timer_timeout"]
```

---

## 4. Mandatory Post-Modification Alert

Every time you modify a `.tscn` file, conclude your message with this alert:

> [!IMPORTANT]
> **Scene Modified on Disk:** `<scene_path>.tscn` was updated with new node(s).
> In the Godot Editor, click **Reload** (DO NOT click **Resave**, or the changes will be overwritten).
