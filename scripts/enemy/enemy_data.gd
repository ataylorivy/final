extends Resource
class_name enemy_data


@export var name : String

#looks and animations
@export var skin : Texture2D
@export var anim_library: AnimationLibrary
@export var battle_anim_library: AnimationLibrary  
@export var Vframes : int
@export var Hframes : int

#battle only
@export var health : int
@export var damage : int
@export var react_speed : float

@export var speed : float
