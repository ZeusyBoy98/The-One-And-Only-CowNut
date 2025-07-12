extends Node

@onready var player: Player = get_node("Player")

func _ready():
	var player = $Player
	var ui = $CanvasLayer/DonutsContainer

	player.health_changed.connect(ui.update_donuts)
	ui.update_donuts(player.current_health)
	
	Global.level_instance = self

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()


func pause_game():
	SaveLoad.contents_to_save.pos_x = player.position.x
	SaveLoad.contents_to_save.pos_y = player.position.y
	SaveLoad.contents_to_save.current_health = player.current_health
	SaveLoad._save()
	var root = get_tree().get_root()
	self.get_parent().remove_child(self)

	var pause_menu = preload("res://UI/pause.tscn").instantiate()
	root.add_child(pause_menu)
