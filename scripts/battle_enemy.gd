extends Node2D
class_name battle_enemy

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
signal ready_attack
signal dead
var hp : int
var damage : int


func _process(delta):
	var timer = $ready_to_attack
	$Control/attack_meter.max_value = timer.wait_time
	$Control/attack_meter.value = timer.wait_time - timer.time_left

func setup(pos : Vector2, stats : enemy_data):
	sprite.texture = stats.skin
	$Sprite2D.vframes = stats.Vframes
	$Sprite2D.hframes = stats.Hframes
	hp = stats.health
	damage = stats.damage
	$Control/hp_bar.max_value = hp
	$Control/hp_bar.value = hp
	$Control/PanelContainer/MarginContainer/name.text = stats.name
	for lib_name in anim_player.get_animation_library_list():
		anim_player.remove_animation_library(lib_name) #removes possible excess library's
	if stats.anim_library:
		anim_player.add_animation_library("", stats.battle_anim_library) #lets it set up for easy 
	position = pos
	anim_player.play("idle")
	$ready_to_attack.wait_time = stats.react_speed
	$ready_to_attack.start()
	
	
func _on_ready_to_attack_timeout() -> void:
	print("done")
	ready_attack.emit()
	
func take_damage(damage_taken):
	hp -= damage_taken
	$Control/hp_bar.value = hp
	print(hp)
	if hp <= 0:
		die()
	
func die():
	print("dead")
	dead.emit()
