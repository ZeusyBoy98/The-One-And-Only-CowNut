extends Area2D

var speed = 750
var direction = 1
var distance_traveled = 0.0
const MAX_DISTANCE = 200

func _physics_process(delta):
	var move = Vector2(direction * speed * delta, 0)
	position += move
	distance_traveled += move.length()
	
	if distance_traveled >= MAX_DISTANCE:
		queue_free()

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		return
	if body.is_in_group("rhino"):
		body.queue_free()
	queue_free()
