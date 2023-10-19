extends BaseState

@export_category("State Transitions")
@export var run_node: NodePath
@export var fall_node: NodePath
@export var jump_node: NodePath
@export var dash_node: NodePath
@export var attack_node: NodePath

@onready var run_state: BaseState = get_node(run_node)
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
	dir = character.get_axis()
	if dir.x != 0:
		return run_state
	character.velocity.x = move_toward(character.velocity.x, 0.0, character.stats.ground_acceleration)
	character.move_and_slide()
	if !character.is_on_floor():
		fall_state.coyote_timer.start()
		return fall_state
	return null
