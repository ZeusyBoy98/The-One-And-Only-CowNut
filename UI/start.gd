extends CanvasLayer

@onready var player: Player = get_node("Player")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_new_pressed() -> void:
	if Global.level_instance != null:
		Global.level_instance.queue_free()
		Global.level_instance = null

	Global.level_instance = preload("res://level.tscn").instantiate()
	get_tree().get_root().add_child(Global.level_instance)
	self.queue_free()

func _on_load_pressed() -> void:
	SaveLoad._load()
	Global.saved_data = SaveLoad.contents_to_save
	get_tree().change_scene_to_file("res://level.tscn")
