extends Area2D

# When the player and only the player collides with the portal
# Go to the next level

@export var next_level: PackedScene

func _on_body_entered(body):
	get_tree().change_scene_to_packed(next_level)
