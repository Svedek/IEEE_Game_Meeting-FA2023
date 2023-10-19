extends CharacterBody2D
class_name StateManagedCharacter

@onready var sprite: Sprite2D = $Sprite2D
@onready var stats: CharacterStats = $CharacterStats
@onready var state_manager: StateManager = $StateManager
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready():
	state_manager.init(self)
	
func _input(event):
	state_manager.input(event)
	
func _process(delta):
	state_manager.process(delta)

func _physics_process(delta):
	state_manager.physics_process(delta)
	
func get_axis() -> Vector2:
	print("unimplemented get_axis() in - " + self.name)
	return Vector2(Input.get_axis("ui_left", "ui_right"), 0.0)

func play_animation(animation: String):
	animation_playback.travel(animation)
