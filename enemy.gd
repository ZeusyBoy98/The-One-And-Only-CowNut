extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D

const SPEED = 300.0
var direction = -1

func _ready() -> void:
	sprite.play("walking")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	velocity.x = direction * SPEED
	sprite.flip_h = direction > 0
	if direction == -1:
		await get_tree().create_timer(1.0).timeout
		direction = 1
	elif direction == 1:
		await get_tree().create_timer(1.0).timeout
		direction = -1
	move_and_slide()
