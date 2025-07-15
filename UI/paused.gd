extends CanvasLayer
var save_nodes = []

func _ready():
	$PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/Resume.grab_focus() 
	save_nodes = get_tree().get_nodes_in_group("Persist")

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/start.tscn")

func _on_resume_pressed() -> void:
	Global.level_instance.set_process(true)
	Global.level_instance.set_physics_process(true)
	Global.level_instance.set_process_input(true)
	get_tree().get_root().add_child(Global.level_instance)
	self.queue_free()
