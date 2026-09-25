# Official Godot Architecture Best Practices Summary

This document synthesizes the core lessons from Godot's official `tutorials/best_practices/` documentation.

---

## 1. Scenes vs Scripts: When to Create Which?

* **Create a `.tscn` (Scene) when:**
  * The object requires multiple nodes working together (e.g. a Sprite + CollisionShape + Timer).
  * The entity needs visual inspection or tweaking in the 2D/3D viewport.
  * You plan to instantiate multiple independent copies in levels.
* **Create a standalone `.gd` (Script) when:**
  * Extending an existing node purely to add utility logic without child nodes.
  * Creating a custom `Resource` data container (`extends Resource`).
  * Creating a pure mathematical or helper utility (`extends RefCounted`).

---

## 2. Autoloads vs Regular Nodes

Autoloads (singletons) are convenient, but overusing them creates hidden dependencies and makes unit testing impossible.

* **DO use an Autoload for:**
  * **Event Bus:** Passing global notifications across decoupled systems.
  * **Audio Director / Music Manager:** Crossfading soundtrack streams across scene transitions.
  * **Save / Game State Manager:** Serializing and deserializing persistent player data.
* **DO NOT use an Autoload for:**
  * Storing references to level-specific nodes (e.g. `GameManager.current_player = self`).
  * Handling level logic that resets when reloading a stage.

---

## 3. Data Preferences: Nodes vs Resources

Never use a `Node` just to store raw data or configuration values.
* Nodes carry significant memory overhead, are bound to the SceneTree, and process virtual frames.
* **`Resource` (`extends Resource`)** is lightweight, serialized directly to `.tres`, cacheable, and easily shared between multiple instances.

| Use Case | Best Approach |
| :--- | :--- |
| **RPG Character Stats** (Base HP, Attack, Defense) | Custom `Resource` (`character_stats.tres`) |
| **Item Database / Inventory Items** | Custom `Resource` (`item_potion.tres`) |
| **Active In-Game Enemy Entity** | Scene (`enemy.tscn`) holding a `CharacterStats` resource |
