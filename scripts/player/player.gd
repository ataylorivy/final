extends CharacterBody2D

var info = global.player_info
var stats : player_data = info

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

var move
var input : Vector2
var last_input = null
var sprint = false

func _ready() -> void:
	global.player = self
	sprite.texture = stats.skin
	$Sprite2D.vframes = stats.vframes
	$Sprite2D.hframes = stats.hframes
	for lib_name in anim_player.get_animation_library_list():
		anim_player.remove_animation_library(lib_name) #removes possible excess library's
	if stats.anim_library:
		var new_library = stats.anim_library.duplicate(true)
		for anim_name in new_library.get_animation_list():
			var anim = new_library.get_animation(anim_name).duplicate(true)
			new_library.add_animation(anim_name, anim)
		anim_player.add_animation_library("", new_library)
	print(anim_player.get_animation_list())
	print(name)
	for track in anim_player.get_animation("idle").get_track_count():
		print(anim_player.get_animation("idle").track_get_path(track))
		
func get_input():
	move = Vector2.ZERO
	if Input.is_action_pressed("sprint"):
		sprint = true
		anim_player.speed_scale = stats.sprint_mult
	else:
		sprint = false
		anim_player.speed_scale = 1      
	if Input.is_action_pressed("up"):
		last_input = "up"
		move = Vector2(0, -1)
		anim_player.play("move_up")
	elif Input.is_action_pressed("down"):
		last_input = "down"
		move = Vector2(0, 1)
		anim_player.play("move_down")
	elif Input.is_action_pressed("left"):
		last_input = "left"
		$Sprite2D.flip_h = true
		move = Vector2(-1, 0)
		anim_player.play("move_rl")
	elif Input.is_action_pressed("right"):
		last_input = "right"
		$Sprite2D.flip_h = false
		move = Vector2(1, 0)
		anim_player.play("move_rl")
	else:
		anim_player.play("idle")
	if Input.is_action_just_pressed("interact"):
		print("done")

	return move.normalized()
func _physics_process(delta):
	var action = get_input() 
	if sprint == false: 
		velocity = action * stats.speed * delta
	else: 
		velocity = action * (stats.speed * stats.sprint_mult) * delta
	move_and_slide()
