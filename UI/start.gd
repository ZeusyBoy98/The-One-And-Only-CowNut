extends CanvasLayer

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_new_pressed() -> void:
	if Global.level_instance != null:
		if Global.level_instance.is_inside_tree():
			Global.level_instance.queue_free()
		Global.level_instance = null
	
	get_tree().paused = false
	print_tree_pretty()

	Global.level_instance = preload("res://level.tscn").instantiate()
	get_tree().get_root().add_child(Global.level_instance)
	self.queue_free()

func _on_load_pressed() -> void:
	SaveLoad._load()
	Global.saved_data = SaveLoad.contents_to_save
	Global.level_instance = null
	get_tree().paused = false
	get_tree().change_scene_to_file("res://level.tscn")
