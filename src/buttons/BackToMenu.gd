extends Control

func _on_BackToMenu_pressed() -> void:
	$fade_in.show()
	$fade_in.fade_in()

func _on_fade_in_fade_finished() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/worlds/TitleScreen.tscn")
