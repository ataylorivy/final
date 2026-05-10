extends Node2D
class_name battle_player
signal dead

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
var max_hp
var current_hp

func setup(pos : Vector2, stats : player_data):
	max_hp = stats.max_hp
	current_hp = stats.current_hp
	$attack_cd.wait_time = stats.react_speed
	$Control/hp_bar.max_value = max_hp
	$Control/hp_bar.value = current_hp
	print(stats.speed, stats.skin)
	sprite.texture = stats.skin
	$Sprite2D.vframes = stats.vframes
	$Sprite2D.hframes = stats.hframes
	$Control/PanelContainer/name.text = stats.name
	for lib_name in anim_player.get_animation_library_list():
		anim_player.remove_animation_library(lib_name) #removes possible excess library's
	if stats.anim_library:
		var new_library = stats.anim_library.duplicate(true)
		for anim_name in new_library.get_animation_list():
			var anim = new_library.get_animation(anim_name).duplicate(true)
			new_library.add_animation(anim_name, anim)
		anim_player.add_animation_library("", new_library)
	position = pos


func take_damage(damage):
	current_hp -= damage
	$Control/hp_bar.value = current_hp
	print(current_hp)
	if current_hp <= 0:
		die()
	
func die():
	dead.emit()
