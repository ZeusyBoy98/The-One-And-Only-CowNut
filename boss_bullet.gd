extends Area2D

var speed = 750
var direction = 1

func _physics_process(delta):
	var move = Vector2(direction * speed * delta, 0)
	position += move

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		body.take_damage(1)
	elif body.is_in_group("rhino"):
		return
	else:
		queue_free()
