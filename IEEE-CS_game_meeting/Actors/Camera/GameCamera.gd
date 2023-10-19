extends Camera2D

@onready var player: StateManagedCharacter = %Player
@export var x_offset: float


func _process(delta):
	position = player.position + (player.state_manager.current_state.dir * x_offset)
