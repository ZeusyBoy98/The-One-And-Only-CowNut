extends Area2D

var speed = 750
var direction = 1

func _physics_process(delta):
	position += Vector2(direction * speed * delta, 0)

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		return
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
