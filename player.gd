extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
@export var Bullet : PackedScene
@export var max_health := 5

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_playing_temp_anim = false
signal health_changed(current_health: int)
var current_health := max_health

func _ready():
	emit_signal("health_changed", current_health)

func take_damage(amount: int):
	current_health = max(current_health - amount, 0)
	emit_signal("health_changed", current_health)

func heal(amount: int):
	current_health = min(current_health + amount, max_health)
	emit_signal("health_changed", current_health)

func play_once(animation_name: String):
	if is_playing_temp_anim:
		return
	is_playing_temp_anim = true
	sprite.play(animation_name)
	if not sprite.is_connected("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished")):
		sprite.connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished"))
		
func shoot():
	var b = Bullet.instantiate()
	b.transform = $Marker2D.global_transform
	b.direction = 1 if $AnimatedSprite2D.flip_h else -1
	owner.add_child(b)

func _physics_process(delta: float) -> void:
	if current_health > 0:
		if not is_on_floor():
			if is_on_wall():
				if not is_playing_temp_anim:
					if Input.is_action_pressed("jump"):
						velocity.y = JUMP_VELOCITY
						sprite.play("climb")
					elif velocity.y < 0:
						velocity.y = 0
						sprite.stop()
			else:
				velocity.y += get_gravity().y * delta
		
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				if not is_playing_temp_anim:
					sprite.play("jump")
					sprite.stop()
			elif is_on_wall():
				velocity.y = JUMP_VELOCITY
				if not is_playing_temp_anim:
					sprite.play("jump")

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			sprite.flip_h = direction > 0
			if not is_on_wall():
				if not is_playing_temp_anim:
					sprite.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_wall():
				if not is_playing_temp_anim:
					sprite.stop()
			else:
				if not is_playing_temp_anim:
					sprite.play("idle")
				
		if Input.is_action_just_pressed("shoot"):
			if not is_on_wall():
				if current_health > 0:
					play_once("shoot")
					shoot()
					take_damage(1)

		move_and_slide()
	else:
		get_tree().change_scene_to_file("res://UI/ded.tscn")


func _on_animated_sprite_2d_animation_finished() -> void:
	is_playing_temp_anim = false
	sprite.play("idle")
