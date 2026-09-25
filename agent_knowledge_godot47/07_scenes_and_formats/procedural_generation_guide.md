# Procedural Node Instantiation & Generation (Godot 4.7)

While persistent components belong in the `.tscn` file, dynamic, ephemeral entities (bullets, particles on impact, floating combat text, procedural dungeon rooms) must be instantiated procedurally via GDScript.

---

## 1. Instantiating Packed Scenes (`.instantiate()`)

In Godot 4, the old `instance()` method has been replaced by `instantiate()`.

```gdscript
class_name Gun
extends Node2D

# 1. Preload the scene to instantiate
const BulletScene: PackedScene = preload("res://projectiles/bullet.tscn")

@onready var muzzle: Marker2D = %Muzzle

func fire() -> void:
    # 2. Instantiate a new node from the PackedScene
    var bullet := BulletScene.instantiate() as Bullet
    if not bullet:
        return
        
    # 3. Position and rotate before adding to tree
    bullet.global_position = muzzle.global_position
    bullet.global_rotation = muzzle.global_rotation
    
    # 4. Add to the active level root (NOT to the gun, or bullet will move with the gun!)
    get_tree().current_scene.add_child(bullet)
```

---

## 2. Ephemeral Visual Effects (One-Shot Particles & Sounds)

For instant effects that despawn automatically:

```gdscript
func spawn_explosion(pos: Vector2) -> void:
    var particles := GPUParticles2D.new()
    particles.process_material = preload("res://vfx/explosion_mat.tres")
    particles.texture = preload("res://vfx/smoke.png")
    particles.one_shot = true
    particles.explosiveness = 1.0
    particles.emitting = true
    particles.global_position = pos
    
    # Auto-destroy when finished emitting
    particles.finished.connect(particles.queue_free)
    
    get_tree().current_scene.add_child(particles)
```

---

## 3. Dynamic Scene Saving (`PackedScene.pack()`)

If you build procedural dungeons or levels and want to save them as `.tscn` files to disk:

```gdscript
func save_procedural_scene(root_node: Node, file_path: String) -> Error:
    # Set owner of all children to the root node (required for pack())
    for child in root_node.get_children():
        child.owner = root_node
        
    var packed_scene := PackedScene.new()
    var pack_error := packed_scene.pack(root_node)
    if pack_error != OK:
        return pack_error
        
    return ResourceSaver.save(packed_scene, file_path)
```
