extends CanvasLayer

func _ready():
	$PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/Restart.grab_focus() 

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/start.tscn")
