# Godot 4.7 Atomic Knowledge Base Catalog (INDEX)

This directory contains high-density, token-efficient atomic knowledge files for AI agents developing Godot 4.7+ projects.

---

## Master Directives
* [RULES_GODOT47.md](./RULES_GODOT47.md) - Master inviolable rules, prohibited Python patterns, canonical declaration order, scene-first rules, and reload alert protocol.

---

## 00. Environment & Continuous Co-Development
* [00_environment/vscode_godot_integration.md](./00_environment/vscode_godot_integration.md) - Godot LSP (6005), DAP (6006), external editor settings, and `.vscode` config files.
* [00_environment/scene_reload_synchronization.md](./00_environment/scene_reload_synchronization.md) - File-locking, disk write etiquette, in-memory tree differences, and the crucial `Reload` vs `Resave` handling.
* [00_environment/mcp_and_tooling_spec.md](./00_environment/mcp_and_tooling_spec.md) - Model Context Protocol (MCP) server design spec and CLI hooks for editor control.

---

## 01. GDScript 4.7 Core & Strict Typing
* [01_gdscript_core/gdscript_official_styleguide.md](./01_gdscript_core/gdscript_official_styleguide.md) - Official 14-step declaration order, naming conventions, and docstrings.
* [01_gdscript_core/type_system_and_annotations.md](./01_gdscript_core/type_system_and_annotations.md) - Strict typing, typed arrays/dicts, `@export` groups, `@onready`, and `@tool`.
* [01_gdscript_core/functions_signals_and_callables.md](./01_gdscript_core/functions_signals_and_callables.md) - First-class signals, `Callable`, lambdas, and asynchronous `await`.
* [01_gdscript_core/memory_and_lifecycle_management.md](./01_gdscript_core/memory_and_lifecycle_management.md) - `RefCounted` vs `Node`/`Object`, `queue_free()`, `is_instance_valid()`, and weak references.

---

## 02. Python vs GDScript Disambiguation
* [02_python_vs_gdscript/syntax_anti_patterns.md](./02_python_vs_gdscript/syntax_anti_patterns.md) - Detailed analysis of false Python instincts (`self` parameters, `len()`, `def`, list comprehensions, `import`).
* [02_python_vs_gdscript/builtins_comparison_matrix.md](./02_python_vs_gdscript/builtins_comparison_matrix.md) - Exhaustive side-by-side translation table (Python syntax/builtin $\rightarrow$ GDScript 4.7).

---

## 03. Node Tree Architecture & Lifecycle Flow
* [03_nodes_and_tree/lifecycle_order.md](./03_nodes_and_tree/lifecycle_order.md) - Execution flow (`_init` $\rightarrow$ `_enter_tree` $\rightarrow$ `_ready` $\rightarrow$ `_process`/`_physics_process` $\rightarrow$ `_exit_tree`), top-down vs bottom-up rules.
* [03_nodes_and_tree/communication_principles.md](./03_nodes_and_tree/communication_principles.md) - "Call Down, Signal Up", Groups, and Autoload boundaries.
* [03_nodes_and_tree/node_referencing_strategies.md](./03_nodes_and_tree/node_referencing_strategies.md) - Contextual analysis and trade-offs of `%UniqueName` vs `$Path` vs `@export` vs Groups.

---

## 04. Gameplay Systems & Physics (2D & 3D)
* [04_gameplay_and_physics/character_body_movement.md](./04_gameplay_and_physics/character_body_movement.md) - Canonical 2D and 3D `CharacterBody` controllers, zero-argument `move_and_slide()`, delta timing.
* [04_gameplay_and_physics/collision_layers_and_masks.md](./04_gameplay_and_physics/collision_layers_and_masks.md) - Identity vs sensory bitmasks, 1-indexed APIs, and `Area2D/3D` triggers.
* [04_gameplay_and_physics/raycasting_and_queries.md](./04_gameplay_and_physics/raycasting_and_queries.md) - Node-based `RayCast2D/3D` vs direct space state queries (`intersect_ray`).

---

## 05. UI, Canvas & Theming
* [05_ui_and_canvas/control_node_anchors_and_containers.md](./05_ui_and_canvas/control_node_anchors_and_containers.md) - `layout_mode = 3` (Anchors) vs `layout_mode = 2` (Containers), size flags, and `mouse_filter`.
* [05_ui_and_canvas/ui_gameplay_separation.md](./05_ui_and_canvas/ui_gameplay_separation.md) - Decoupling HUD from game entities using signals, CanvasLayers, and EventBus.
* [05_ui_and_canvas/gamepad_and_keyboard_navigation.md](./05_ui_and_canvas/gamepad_and_keyboard_navigation.md) - `focus_mode = 2`, `grab_focus()`, explicit neighbors, and gamepad menu UX.

---

## 06. Official Best Practices, Resources & Patterns
* [06_patterns_and_resources/official_best_practices_summary.md](./06_patterns_and_resources/official_best_practices_summary.md) - Canonical guidance: Autoloads vs nodes, scenes vs scripts, data preferences.
* [06_patterns_and_resources/composition_over_inheritance.md](./06_patterns_and_resources/composition_over_inheritance.md) - Component-based architecture (`HealthComponent`, `HitboxComponent`, `HurtboxComponent`).
* [06_patterns_and_resources/custom_resources_data_driven.md](./06_patterns_and_resources/custom_resources_data_driven.md) - Custom `Resource` definitions (`.tres`), item databases, and `duplicate()` handling.
* [06_patterns_and_resources/state_machine_pattern.md](./06_patterns_and_resources/state_machine_pattern.md) - Node-based Finite State Machine (FSM) implementation.
* [06_patterns_and_resources/event_bus_autoload.md](./06_patterns_and_resources/event_bus_autoload.md) - Global EventBus singleton setup and cross-system notifications.

---

## 07. Scene Formats & Autonomous Editing
* [07_scenes_and_formats/tscn_syntax_specification.md](./07_scenes_and_formats/tscn_syntax_specification.md) - Internal anatomy of `.tscn` format 3, UIDs, and resource tags.
* [07_scenes_and_formats/autonomous_tscn_node_injection.md](./07_scenes_and_formats/autonomous_tscn_node_injection.md) - Step-by-step rules for injecting Timers, Particles, Colliders, and UI into `.tscn` files.
* [07_scenes_and_formats/procedural_generation_guide.md](./07_scenes_and_formats/procedural_generation_guide.md) - When to instantiate procedurally via code (`PackedScene.instantiate()`).

---

## 08. Testing & Verification
* [08_testing_and_verification/headless_cli_verification.md](./08_testing_and_verification/headless_cli_verification.md) - Static syntax and compilation checking via `godot --headless --check-only`.
* [08_testing_and_verification/gut_unit_testing_patterns.md](./08_testing_and_verification/gut_unit_testing_patterns.md) - Unit testing gameplay math and signals with the GUT framework.
