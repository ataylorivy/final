extends Resource
class_name player_data
@export var name : String
@export var skin : Texture2D
@export var hframes : int
@export var vframes : int
@export var anim_library: AnimationLibrary
@export var battle_anim_library: AnimationLibrary  


#overworld only
@export var sprint_mult : float
@export var speed : float


#battle
@export var max_hp : int
@export var current_hp : int
@export var mp : int
@export var base_damage : int
@export var react_speed : float
