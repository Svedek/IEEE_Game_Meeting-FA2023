extends Node
class_name CharacterStats

signal death

@export var move_speed: float = 250.0
@export var ground_acceleration: float = 40
@export var air_acceleration: float = 25
@export var gravity: float = 20.0
@export var max_fall_speed: float = 200.0

@export var jump_time: float = 0.25
@export var jump_velocity: float = -250

@export var max_health: int = 1
@onready var health: int = max_health:
	set(value):
		health = value
		if health <= 0:
			on_death()
			
func on_death():
	emit_signal("death")
