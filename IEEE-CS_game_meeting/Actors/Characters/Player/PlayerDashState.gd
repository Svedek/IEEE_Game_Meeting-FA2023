extends BaseState

@export var dash_time: float = 0.3
@export var dash_mod: float = 2.0
@export var dash_cooldown: float = 0.2

@export_category("State Transitions")
@export var run_node: NodePath
@export var fall_node: NodePath
@export var jump_node: NodePath
@export var attack_node: NodePath
@export var air_attack_node: NodePath

@onready var run_state: BaseState = get_node(run_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var jump_state: BaseState = get_node(jump_node)
@onready var attack_state: BaseState = get_node(attack_node)
@onready var air_attack_state: BaseState = get_node(air_attack_node)

var dash_cooldown_timer: Timer
var dash_timer: Timer
var dashing: bool = false
var queued_input: BaseState = null


func _ready():
	var  end_dash = func(): dashing = false
	dash_timer = create_timer(end_dash, dash_time)
	var  dash_available = func(): available = true
	dash_cooldown_timer = create_timer(dash_available, dash_cooldown)

func enter(direction:Vector2):
	super.enter(direction)
	if dir.x == 0:
		dir.x = -1 if character.sprite.flip_h else 1
	available = false
	dashing = true
	dash_timer.start()
	queued_input = null
	return null
	
func exit():
	dash_cooldown_timer.start()
	return super.exit()
	
func input(event: InputEvent):
	if event.is_action_pressed("jump") && character.is_on_floor():
		queued_input = jump_state
	if event.is_action_pressed("attack"):
		queued_input = attack_state if character.is_on_floor() else air_attack_state

func process(delta: float) -> BaseState:
	if !dashing:
		if queued_input != null && queued_input.available:
			return queued_input
		return fall_state if character.is_on_floor() else run_state
	return null

func physics_process(delta: float) -> BaseState:
	# TODO possibly step-up mechanic
	
	character.velocity.y = 0.0
	character.velocity.x = character.stats.move_speed * dir.x * dash_mod
	character.move_and_slide()
	return null
