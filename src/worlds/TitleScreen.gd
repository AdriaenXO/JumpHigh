extends Control

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var buttonClicked: String

func _on_newGameButton_pressed() -> void:
	buttonClicked = "newGame"
	$fade_in.show()
	$fade_in.fade_in()
	


func _on_QuitGameButton_pressed() -> void:
	buttonClicked = "quitGame"
	$fade_in.show()
	$fade_in.fade_in()


func _on_fade_in_fade_finished() -> void:
	if (buttonClicked == "newGame"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://src/worlds/Level_template.tscn")
	elif (buttonClicked == "quitGame"):
		get_tree().quit()
