# Raycasting & Direct Space State Queries (Godot 4.7)

Godot 4 offers two methods for physics queries: **Node-based RayCasts** (`RayCast2D/3D`) and **Direct Space State Queries**.

---

## 1. Node-based RayCasts (`RayCast2D` & `RayCast3D`)

Best for persistent sensory checks (e.g. wall checks, line-of-sight checks, ground sensors).

### 1.1 Advantages
* Visual arrows drawn in the 2D/3D editor viewport for easy tuning.
* Automatically calculated each physics frame.

### 1.2 Usage
```gdscript
class_name LedgeDetector
extends Node2D

@onready var floor_ray: RayCast2D = %FloorRay
@onready var wall_ray: RayCast2D = %WallRay

func check_environment() -> void:
    # If the node moved during this frame and needs instant re-calculation:
    floor_ray.force_raycast_update()
    
    if floor_ray.is_colliding():
        var collider: Object = floor_ray.get_collider()
        var hit_point: Vector2 = floor_ray.get_collision_point()
        var hit_normal: Vector2 = floor_ray.get_collision_normal()
        print("Floor hit at: %s on: %s" % [hit_point, collider])
    else:
        print("Air beneath ledge!")
```

---

## 2. Direct Space State Raycasting (Code-Only Queries)

Best for instant, dynamic queries (e.g. bullet hitscan, player aiming at crosshair, laser sweeps).

> [!IMPORTANT]
> Direct space state queries MUST be executed within `_physics_process()` or deferred calls when the physics server is in sync.

### 2.1 2D Raycast Query
```gdscript
func fire_hitscan_2d(origin: Vector2, target: Vector2, mask: int = 1) -> Dictionary:
    var space_state := get_world_2d().direct_space_state
    
    # Configure the query parameter object
    var query := PhysicsRayQueryParameters2D.create(origin, target, mask)
    query.exclude = [get_rid()] # Ignore self
    query.collide_with_areas = true
    query.collide_with_bodies = true
    
    # Intersect ray against physics world
    var result: Dictionary = space_state.intersect_ray(query)
    
    if not result.is_empty():
        # result contains: position, normal, collider, collider_id, rid, shape
        var hit_pos: Vector2 = result.position
        var hit_collider: Object = result.collider
        print("Hit 2D object: %s at %s" % [hit_collider, hit_pos])
        return result
        
    return {}
```

### 2.2 3D Camera-to-World Raycast (Mouse Aiming)
```gdscript
func raycast_from_camera(mouse_pos: Vector2, camera: Camera3D) -> Dictionary:
    var space_state := get_world_3d().direct_space_state
    var ray_origin := camera.project_ray_origin(mouse_pos)
    var ray_end := ray_origin + camera.project_ray_normal(mouse_pos) * 1000.0
    
    var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
    var result := space_state.intersect_ray(query)
    
    if not result.is_empty():
        print("Aiming at: %s" % result.position)
        return result
        
    return {}
```
