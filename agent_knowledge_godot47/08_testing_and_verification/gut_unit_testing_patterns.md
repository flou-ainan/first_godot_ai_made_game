# Unit Testing with GUT (Godot Unit Test)

GUT is the industry-standard unit testing framework for Godot projects, ideal for Test-Driven Development (TDD) of core gameplay math, damage formulas, inventory logic, and state machines.

---

## 1. Writing a GUT Test Case

Create a script inside `test/unit/` (e.g. `test/unit/test_health_component.gd`) inheriting from `GutTest`:

```gdscript
extends GutTest

var health_comp: HealthComponent

func before_each() -> void:
    # Setup fresh instance before every test
    health_comp = HealthComponent.new()
    health_comp.max_health = 100.0
    add_child_autofree(health_comp)
    health_comp._ready()

func test_initial_health_equals_max() -> void:
    assert_eq(health_comp.current_health, 100.0, "Current health should initialize to max health")

func test_damage_reduces_health() -> void:
    health_comp.damage(30.0)
    assert_eq(health_comp.current_health, 70.0, "Health should decrease by damage amount")

func test_health_cannot_drop_below_zero() -> void:
    health_comp.damage(150.0)
    assert_eq(health_comp.current_health, 0.0, "Health should clamp to zero")
```

---

## 2. Testing Signals

GUT provides built-in signal watchers:

```gdscript
func test_died_signal_emitted_on_zero_health() -> void:
    watch_signals(health_comp)
    
    health_comp.damage(100.0)
    
    # Verify that the died signal fired exactly once
    assert_signal_emitted(health_comp, "died", "Should emit 'died' signal when health reaches zero")
    assert_signal_emit_count(health_comp, "died", 1)
```

---

## 3. Testing Asynchronous Code & Timers

To test coroutines or timer-delayed logic:

```gdscript
func test_invulnerability_expires() -> void:
    var player := Player2D.new()
    add_child_autofree(player)
    
    player.trigger_invulnerability(0.2)
    assert_true(player.is_invulnerable, "Player should be invulnerable immediately")
    
    # Wait for the async timer in test
    await wait_seconds(0.25)
    
    assert_false(player.is_invulnerable, "Invulnerability should expire after wait time")
```

---

## 4. Running GUT Tests via CLI (Automated CI/Agent)

```bash
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://test/unit/ -gexit
```
* `-gdir`: Points to test directory.
* `-gexit`: Closes the engine with exit code `0` on success, or `1` on test failures.
