extends CharacterBody2D 

signal start_encounter(enemy, data : enemy_data)

@export var stats : Resource
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
var player
var sees_player = false
var moving = false
var target_position = Vector2.ZERO


func _ready():
	stats = stats.duplicate(true)
	player = global.player
	sprite.texture = stats.skin
	$Sprite2D.vframes = stats.Vframes
	$Sprite2D.hframes = stats.Hframes
	for lib_name in anim_player.get_animation_library_list():
		anim_player.remove_animation_library(lib_name) #removes possible excess library's
	if stats.anim_library:
		var new_library = stats.anim_library.duplicate(true)
		for anim_name in new_library.get_animation_list():
			var anim = new_library.get_animation(anim_name).duplicate(true)
			new_library.add_animation(anim_name, anim)

		anim_player.add_animation_library("", new_library) #lets it set up for easy animations (makes something like "test/spin" into "spin")
	anim_player.play("idle")
	print(anim_player.get_animation_list())
	print(name)
	for track in anim_player.get_animation("idle").get_track_count():
		print(anim_player.get_animation("idle").track_get_path(track))
	
func _physics_process(delta: float) -> void: 
		 #future ref -use this for aniamtions
	if sees_player == false:
		return
	if not moving: 
		var path = global.go_to_player(global_position) 
		if path.size() > 1:
			target_position = global.tilemap.map_to_local(path[1]) 
			moving = true
	if moving:
		move_to(delta) 
func move_to(delta):
	var dir = global_position.direction_to(target_position) 
	if dir.x > 0:
		anim_player.play("move_RL")
		$Sprite2D.flip_h = false
	elif dir.x < 0:
		anim_player.play("move_RL")
		$Sprite2D.flip_h = true
	elif dir.y > 0:
		anim_player.play("move_down")
	elif dir.y < 0:
		anim_player.play("move_up")
	else:
		pass
	global_position = global_position.move_toward(target_position, stats.speed * delta) #wow it moves correctly, its a miracle
	if global_position.distance_to(target_position) < 0.1: #snaps to final position
		global_position = target_position 
		moving = false


func _on_sight_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		sees_player = true


func _on_battle_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): # make it take to battle scene
		start_encounter.emit(self, stats)
