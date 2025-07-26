extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D

const SPEED = 299
var player = null
var player_chase = false
var direction = 0

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
		velocity.x = 0
		sprite.play("idle")
		
	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detector_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
