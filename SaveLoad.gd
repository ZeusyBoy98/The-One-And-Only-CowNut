extends Node

const save_location = "user://SaveFile.json"

var contents_to_save: Dictionary = {
	"pos_x": 0.0,
	"pos_y": 0.0,
	"current_health": 5,
	"shoot_unlocked": false,
	"dash_unlocked": false,
	"double_jump_unlocked": false,
}

func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.pos_x = save_data.pos_x
		contents_to_save.pos_y = save_data.pos_y
		contents_to_save.current_health = save_data.current_health
		contents_to_save.dash_unlocked = save_data.dash_unlocked
		contents_to_save.shoot_unlocked = save_data.shoot_unlocked
		contents_to_save.double_jump_unlocked = save_data.double_jump_unlocked
