extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
@onready var label = $Label
@export var bullet : PackedScene

const SPEED = 300
var player = null
var player_chase = false
var dir = -1
var change = false
var choice
var rhino = preload("res://enemy.tscn")
var wait = false
var health = 1
var direction = -1

func _ready() -> void:
	sprite.play("idle")

func take_damage(d: int):
	health -= d
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)

func _physics_process(delta: float) -> void:
	if health > 0:
		label.text = str(health) + "/20"
		if not is_on_floor():
			velocity.y += get_gravity().y * delta
		velocity.x = direction * SPEED
		if direction == -1:
			await get_tree().create_timer(1.0).timeout
			direction = 1
		elif direction == 1:
			await get_tree().create_timer(1.0).timeout
			direction = -1
		if player_chase and player:
			sprite.play("run")
			if choice == 0 and !wait:
				wait = true
				var spawned_rhino = rhino.instantiate()
				spawned_rhino.position = position
				spawned_rhino.position.y -= 200
				spawned_rhino.position.x -= 200
				spawned_rhino.add_to_group("rhino")
				get_parent().add_child(spawned_rhino)
				await get_tree().create_timer(2.0).timeout
				wait = false
			if choice == 1 and !wait:
				wait = true
				var b = bullet.instantiate()
				b.transform = $Marker2D.global_transform
				b.direction = 1 if $AnimatedSprite2D.flip_h else -1
				owner.add_child(b)
				await get_tree().create_timer(2.0).timeout
				wait = false
			if choice == 2 and !wait:
				wait = true
				velocity.y = -400.00
				await get_tree().create_timer(2.0).timeout
				wait = false
			if !change:
				change = true
				choice = randi() % 3
				await get_tree().create_timer(2.0).timeout
				change = false
		move_and_slide()
	else:
		self.queue_free()

func _on_detector_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detector_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
