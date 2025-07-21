extends CanvasLayer

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_new_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")

func _on_load_pressed() -> void:
	SaveLoad._load()
	Global.saved_data = SaveLoad.contents_to_save
	get_tree().paused = false
	get_tree().change_scene_to_file("res://level.tscn")
