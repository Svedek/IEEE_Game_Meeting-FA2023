extends BaseState

@export var attack_time: float = 0.3

@export_category("State Transitions")
@export var idle_node: NodePath
@export var run_node: NodePath
@export var fall_node: NodePath
@export var jump_attack_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var jump_attack_state: BaseState = get_node(jump_attack_node)
@onready var weapon_sprite_2d:Sprite2D = $"../../WeaponSprite2D"

var attack_timer: Timer
var attacking: bool = false
var weapon_sprite_offset:float


func _ready():
	var  end_attack = func(): attacking = false
	attack_timer = create_timer(end_attack, attack_time)
	weapon_sprite_offset = weapon_sprite_2d.position.x

func enter(direction:Vector2):
	super.enter(direction)
	attacking = true
	attack_timer.start()
	weapon_sprite_2d.flip_h = character.sprite.flip_h
	weapon_sprite_2d.show_behind_parent = character.sprite.flip_h
	weapon_sprite_2d.position.x = -weapon_sprite_offset if character.sprite.flip_h else weapon_sprite_offset
	return null

func input(event: InputEvent):
	if event.is_action_pressed("jump") && jump_attack_state.available:
		jump_attack_state.jump_time_remaining = character.stats.jump_time
		jump_attack_state.attack_time_advance = attack_time - attack_timer.time_left
		return jump_attack_state

func physics_process(delta: float) -> BaseState:
	dir = character.get_axis()
	character.velocity.x = move_toward(character.velocity.x, character.stats.move_speed * dir.x, character.stats.air_acceleration )
	if Input.is_action_pressed("ui_down"):
		character.velocity.y = move_toward(character.velocity.y, character.stats.max_fall_speed*1.5, character.stats.gravity)
	else:
		character.velocity.y = move_toward(character.velocity.y, character.stats.max_fall_speed, character.stats.gravity)
	character.move_and_slide()
	if !attacking:
		if !character.is_on_floor():
			return fall_state
		return run_state if dir.x != 0.0 else idle_state
	return null
