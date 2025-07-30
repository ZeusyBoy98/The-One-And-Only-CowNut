extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D

const SPEED = 200
var player = null
var player_chase = false
var dir = -1

func _ready() -> void:
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else: 
		velocity.y = 0
	
	if player_chase and player:
		sprite.play("run")
		var pos = player.position.x - position.x
		if pos < -264.5:
			var direction = -1
			velocity.x = direction * SPEED
			sprite.flip_h = direction > 0
		elif pos > -264.5:
			var direction = 1
			velocity.x = direction * SPEED
			sprite.flip_h = direction > 0
		else:
			var direction = 0
			velocity.x = direction * SPEED
	else:
		if not is_on_floor():
			velocity.y += (get_gravity().y - 400) * delta
		velocity.x = dir * SPEED
		sprite.flip_h = dir > 0
		if is_on_floor():
			velocity.y = -400
		if dir == -1:
			await get_tree().create_timer(1.0).timeout
			dir = 1
		elif dir == 1:
			await get_tree().create_timer(1.0).timeout
			dir = -1
		move_and_slide()
		
	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_chase = true

func _on_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		player_chase = false
