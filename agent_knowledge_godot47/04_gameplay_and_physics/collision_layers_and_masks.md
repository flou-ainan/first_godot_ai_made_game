# Collision Layers & Masks Architecture (Godot 4.7)

Misconfiguring collision layers and masks is one of the most common causes of gameplay bugs (objects passing through floors or missing bullet hits).

---

## 1. The Core Law of Layers vs Masks

| Property | Concept | Plain English Question |
| :--- | :--- | :--- |
| **`collision_layer`** | Identity | *"What layer do I exist on?"* |
| **`collision_mask`** | Sensory | *"What layers do I scan, collide with, or listen to?"* |

> [!NOTE]
> Two bodies collide if and only if **Body A's mask includes Body B's layer**, OR **Body B's mask includes Body A's layer**.

---

## 2. Standard 2D/3D Layer Setup Template

In **Project Settings** $\rightarrow$ **Layer Names** $\rightarrow$ **2D/3D Physics**, define named layers:

| Layer # | Name | Description |
| :--- | :--- | :--- |
| **1** | `World` | Static geometry, terrain, walls, platforms |
| **2** | `Player` | Player CharacterBody |
| **3** | `Enemies` | Enemy CharacterBodies |
| **4** | `PlayerProjectiles` | Bullets/spells fired by the player |
| **5** | `EnemyProjectiles` | Bullets/spells fired by enemies |
| **6** | `Hitboxes / Hurtboxes`| Damage detection trigger areas (`Area2D/3D`) |
| **7** | `Collectibles` | Coins, keys, power-ups (`Area2D/3D`) |

---

## 3. Practical Layer & Mask Configuration

### 3.1 Player Character Configuration
* **Layer:** `2 (Player)` (I am the player).
* **Mask:** `1 (World)` | `5 (EnemyProjectiles)` | `7 (Collectibles)` (I bump into the world, get hit by enemy bullets, and touch coins).

### 3.2 Player Bullet Configuration
* **Layer:** `4 (PlayerProjectiles)` (I am a player bullet).
* **Mask:** `1 (World)` | `3 (Enemies)` (I explode against walls or damage enemies. I ignore the player!).

---

## 4. Configuring via GDScript (Godot 4 1-Indexed API)

Never perform manual bitwise shift math (`1 << 2`) unless necessary. Godot 4 provides convenient 1-indexed methods:

```gdscript
func setup_bullet_collision() -> void:
    # 1. Clear all existing layers and masks
    collision_layer = 0
    collision_mask = 0
    
    # 2. Set Layer 4 (PlayerProjectiles)
    set_collision_layer_value(4, true)
    
    # 3. Set Masks 1 (World) and 3 (Enemies)
    set_collision_mask_value(1, true)
    set_collision_mask_value(3, true)
```

---

## 5. Area Trigger Detection (`Area2D` / `Area3D`)

Areas detect overlap without causing physics rebound:

```gdscript
class_name CoinPickup
extends Area2D

signal coin_collected(value: int)

@export var value: int = 1

func _ready() -> void:
    # Set to Layer 7 (Collectibles), scan Layer 2 (Player)
    set_collision_layer_value(7, true)
    set_collision_mask_value(2, true)
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body is Player2D:
        coin_collected.emit(value)
        queue_free()
```
