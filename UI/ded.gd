extends CanvasLayer

func _ready():
	$PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/Continue.grab_focus() 

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/start.tscn")

func _on_continue_pressed() -> void:
	SaveLoad._load()
	Global.saved_data = SaveLoad.contents_to_save
	get_tree().paused = false
	get_tree().change_scene_to_file("res://level.tscn")
