extends StateManagedCharacter


func get_axis() -> Vector2:
	return Vector2(Input.get_axis("ui_left", "ui_right"), 0.0)

func _on_character_death():
	pass # Replace with function body.
