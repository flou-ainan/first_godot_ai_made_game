class_name Bullet
extends Area2D

## Ephemeral bullet projectile traveling towards the top of the screen.

@export var speed: float = 800.0

func _physics_process(delta: float) -> void:
	position.y -= speed * delta
	if position.y < -50.0:
		queue_free()
