extends Node

@onready var player: Player = get_node("Player")
@onready var parallax_background = get_node("ParallaxBackground")
@onready var paused = $paused

func _ready():
	var ui = $CanvasLayer/DonutsContainer

	player.health_changed.connect(ui.update_donuts)
	ui.update_donuts(player.current_health)

	paused.hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()

func pause_game():
	SaveLoad.contents_to_save.pos_x = player.position.x
	SaveLoad.contents_to_save.pos_y = player.position.y
	SaveLoad.contents_to_save.current_health = player.current_health
	SaveLoad.contents_to_save.dash_unlocked = player.dash_unlocked
	SaveLoad.contents_to_save.shoot_unlocked = player.shoot_unlocked
	SaveLoad._save()
	get_tree().paused = true
	paused.show()

func _on_forest_checkpoint_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SaveLoad.contents_to_save.pos_x = player.position.x
		SaveLoad.contents_to_save.pos_y = player.position.y
		SaveLoad.contents_to_save.current_health = player.current_health
		SaveLoad._save()
		parallax_background.change_background_to_forest()


func _on_grass_again_body_entered(body: Node2D) -> void:
	parallax_background.change_background_to_fields()


func _on_forest_again_body_entered(body: Node2D) -> void:
	parallax_background.change_background_to_forest()


func _on_desert_again_body_entered(body: Node2D) -> void:
	parallax_background.change_background_to_desert()


func _on_desert_checkpoint_area_shape_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SaveLoad.contents_to_save.pos_x = player.position.x
		SaveLoad.contents_to_save.pos_y = player.position.y
		SaveLoad.contents_to_save.current_health = player.current_health
		SaveLoad._save()
		parallax_background.change_background_to_desert()
