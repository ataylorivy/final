extends Control

var seen : bool
func _ready():
	if not FileAccess.file_exists("user://seen_first_cs.json"):
		return
	var file = FileAccess.open("user://seen_first_cs.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	if data is Dictionary:
		seen = data["seen"]
	if seen == true:
		get_tree().change_scene_to_file.call_deferred("res://scenes/main.tscn")
	$AudioStreamPlayer.play()


func _on_line_edit_text_submitted(new_text: String) -> void:
	global.player_info.name = new_text
	global.save_player()
	var file = FileAccess.open("user://seen_first_cs.json", FileAccess.WRITE)
	var data = {"seen" : true}
	file.store_string(str(data))
	file.close()
	$AudioStreamPlayer.stop()
	get_tree().change_scene_to_file.call_deferred("res://scenes/main.tscn")


"""
use to unsee (like a reset button)
	var file = FileAccess.open("user://seen_first_cs.json", FileAccess.WRITE)
	var data = {"seen" : false}
	file.store_string(str(data))
	file.close()
"""
