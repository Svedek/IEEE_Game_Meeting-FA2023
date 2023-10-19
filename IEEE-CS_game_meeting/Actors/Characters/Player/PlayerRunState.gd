extends BaseState

@export_category("State Transitions")
@export var idle_node: NodePath
@export var fall_node: NodePath
@export var jump_node: NodePath
@export var dash_node: NodePath
@export var attack_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var jump_state: BaseState = get_node(jump_node)
@onready var dash_state: BaseState = get_node(dash_node)
@onready var attack_state: BaseState = get_node(attack_node)


func input(event: InputEvent):
	if event.is_action_pressed("jump") && jump_state.available:
		return jump_state
	if event.is_action_pressed("dash") && dash_state.available:
		return dash_state
	if event.is_action_pressed("attack") && attack_state.available:
		return attack_state
	return null

func physics_process(delta):
	if character.get_axis().x == 0.0:
		return idle_state
	dir = character.get_axis()
	character.sprite.flip_h = dir.x < 0.0
	character.velocity.x = move_toward(character.velocity.x, character.stats.move_speed * dir.x, character.stats.ground_acceleration)
	character.move_and_slide()
	if !character.is_on_floor():
		fall_state.coyote_timer.start()
		return fall_state
	return null
