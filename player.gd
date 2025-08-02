extends CharacterBody2D
class_name Player
@onready var sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var collider = $CollisionShape2D
@onready var spikes = get_parent().get_node("SpikeLayer")
@onready var healer = get_parent().get_node("HealLayer")
@onready var shoot_donut = get_parent().get_node("ShootLayer")
@onready var dash_donut = get_parent().get_node("DashLayer")
@onready var jump_donut = get_parent().get_node("JumpLayer")
@export var bullet : PackedScene
@export var max_health := 5

var SPEED = 300.0
var JUMP_VELOCITY = -400.0
var camera_down = false
var is_playing_temp_anim = false
var spike_cooldown := false
var healer_cooldown := false
var rhino_cooldown := false
var dash_cooldown = false
var shoot_unlocked = false
var double_jump_unlocked = false
var dash_unlocked = false
var in_water = false
var jump = 1
var in_end_cutscene = false
signal health_changed(current_health: int)
var current_health := max_health
var spike_active = false
var heal_active = false
var shoot_active = false
var dash_active = false
var jump_active = false
var rhino_active = false

func _ready():
	if Global.saved_data != null:
		position.x = Global.saved_data.pos_x
		position.y = Global.saved_data.pos_y
		current_health = Global.saved_data.current_health
		shoot_unlocked =  Global.saved_data.shoot_unlocked
		dash_unlocked =  Global.saved_data.dash_unlocked
		double_jump_unlocked =  Global.saved_data.double_jump_unlocked
	emit_signal("health_changed", current_health)

func take_damage(amount: int):
	current_health = max(current_health - amount, 0)
	emit_signal("health_changed", current_health)
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)

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
	var b = bullet.instantiate()
	b.transform = $Marker2D.global_transform
	b.direction = 1 if $AnimatedSprite2D.flip_h else -1
	owner.add_child(b)

func _physics_process(delta: float) -> void:
	if current_health > 0:
		if not in_end_cutscene:
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
					if in_water:
						velocity.y += (get_gravity().y - 400) * delta
					else: 
						velocity.y += get_gravity().y * delta
			
			if Input.is_action_just_pressed("jump"):
				if is_on_floor():
					jump = 1
					velocity.y = JUMP_VELOCITY
					if not is_playing_temp_anim:
						sprite.play("jump")
						get_tree().create_timer(0.2).timeout
						sprite.stop()
				elif jump == 1:
					if double_jump_unlocked:
						jump = 2
						velocity.y = JUMP_VELOCITY
						if not is_playing_temp_anim:
							sprite.play("jump")
							get_tree().create_timer(0.2).timeout
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
			if shoot_unlocked:
				if Input.is_action_just_pressed("shoot"):
					if not is_on_wall():
						if current_health > 0:
							play_once("shoot")
							shoot()
							take_damage(1)
						
			if Input.is_action_just_pressed("dash"):
				if dash_unlocked:
					if not dash_cooldown:
						SPEED = 900
						sprite.play("dash")
						is_playing_temp_anim = true
						await get_tree().create_timer(0.2).timeout
						SPEED = 300
						is_playing_temp_anim = false
						dash_cooldown = true
						await get_tree().create_timer(0.5).timeout
						dash_cooldown = false
			
			if Input.is_action_just_pressed("down"):
				if not camera_down:
					camera_down = true
					camera.position_smoothing_enabled = true
					camera.position.y += 200
					await get_tree().create_timer(1).timeout
					camera.position.y -= 200
					camera.position_smoothing_enabled = false
					camera_down = false
			
			move_and_slide()
			if spike_active and not spike_cooldown:
				spike_cooldown = true
				take_damage(1)
				await get_tree().create_timer(0.2).timeout
				spike_cooldown = false
			elif heal_active and not healer_cooldown:
				healer_cooldown = true
				heal(max_health)
				await get_tree().create_timer(3.0).timeout
				healer_cooldown = false
			elif shoot_active:
				shoot_unlocked = true
			elif dash_active:
				dash_unlocked = true
			elif jump_active:
				double_jump_unlocked = true
			elif rhino_active and not rhino_cooldown:
				take_damage(1)
				rhino_cooldown = true
				await get_tree().create_timer(0.2).timeout
				rhino_cooldown = false
			#for i in range(get_slide_collision_count()):
			#	var collision := get_slide_collision(i)
			#	if collision and collision.get_collider() == spikes and not spike_cooldown:
			#		spike_cooldown = true
			#		take_damage(1)
			#		await get_tree().create_timer(0.05).timeout
			#		spike_cooldown = false
			#	elif collision and collision.get_collider() == healer and not healer_cooldown:
			#		healer_cooldown = true
			#		heal(max_health)
			#		await get_tree().create_timer(3.0).timeout
			#		healer_cooldown = false
			#	elif collision and collision.get_collider() == shoot_donut and not shoot_unlocked:
			#		shoot_unlocked = true
			#	elif collision and collision.get_collider() == dash_donut and not dash_unlocked:
			#		dash_unlocked = true
			#	elif collision and collision.get_collider() == jump_donut and not double_jump_unlocked:
			#		double_jump_unlocked = true
			#	elif collision and collision.get_collider().is_in_group("rhino"):
			#		if not rhino_cooldown:
			#			take_damage(1)
			#			rhino_cooldown = true
			#			await get_tree().create_timer(0.2).timeout
			#			rhino_cooldown = false
		else:
			velocity.y += get_gravity().y * delta
	else:
		get_tree().change_scene_to_file("res://UI/ded.tscn")


func _on_animated_sprite_2d_animation_finished() -> void:
	is_playing_temp_anim = false
	sprite.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		take_damage(current_health)


func _on_collider_body_entered(body: Node2D) -> void:
	if body == spikes and not spike_cooldown:
		spike_active = true
	elif body == healer and not healer_cooldown:
		heal_active  = true
	elif body == shoot_donut and not shoot_unlocked:
		shoot_active = true
	elif body == dash_donut and not dash_unlocked:
		dash_active = true
	elif body == jump_donut and not double_jump_unlocked:
		jump_active = true
	elif body.is_in_group("rhino"):
		rhino_active = true

func _on_collider_body_exited(body: Node2D) -> void:
	if body == spikes:
		spike_active = false
	elif body == healer:
		heal_active  = false
	elif body == shoot_donut:
		shoot_active = false
	elif body == dash_donut:
		dash_active = false
	elif body == jump_donut:
		jump_active = false
	elif body.is_in_group("rhino"):
		rhino_active = false
