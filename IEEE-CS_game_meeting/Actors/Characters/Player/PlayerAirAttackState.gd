extends BaseState

@export var attack_time: float = 0.3

@export_category("State Transitions")
@export var idle_node: NodePath
@export var run_node: NodePath
@export var fall_node: NodePath
@export var jump_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var jump_state: BaseState = get_node(jump_node)
@onready var weapon_sprite_2d:Sprite2D = $"../../WeaponSprite2D"

var attack_timer: Timer
var attacking: bool = false
var weapon_sprite_offset:float
var jump_timer: Timer
var jumping: bool = false
var jump_time_remaining: float = 0.25:
	set(value):
		if value >= 0:
			jumping = true
			jump_timer.start(value)
var attack_time_advance: float = 0.0


func _ready():
	var  end_jump = func(): jumping = false
	jump_timer = create_timer(end_jump, %CharacterStats.jump_time)
	var  end_attack = func(): attacking = false
	attack_timer = create_timer(end_attack, attack_time)
	weapon_sprite_offset = weapon_sprite_2d.position.x

func enter(direction:Vector2):
	dir = direction
	if attack_time_advance == 0:
		character.play_animation(animation_name)
	attacking = true
	attack_timer.start(attack_time - attack_time_advance)
	attack_time_advance = 0.0
	weapon_sprite_2d.flip_h = character.sprite.flip_h
	weapon_sprite_2d.show_behind_parent = character.sprite.flip_h
	weapon_sprite_2d.position.x = -weapon_sprite_offset if character.sprite.flip_h else weapon_sprite_offset
	return null

func physics_process(delta: float) -> BaseState:
	dir = character.get_axis()
	character.velocity.x = move_toward(character.velocity.x, character.stats.move_speed * dir.x, character.stats.air_acceleration)
	if jumping:
		character.velocity.y = character.stats.jump_velocity
		if !Input.is_action_pressed("jump"):
			character.velocity.y = 0
			jumping = false
	else:
		if Input.is_action_pressed("ui_down"):
			character.velocity.y = move_toward(character.velocity.y, character.stats.max_fall_speed*1.5, character.stats.gravity)
		else:
			character.velocity.y = move_toward(character.velocity.y, character.stats.max_fall_speed, character.stats.gravity)
			
	character.move_and_slide()
	if !attacking:
		if jumping:
			jump_state.jump_time_remaining = jump_timer.time_left
			return jump_state
		if !character.is_on_floor():
			return fall_state
		return run_state if dir.x != 0.0 else idle_state
	return null
