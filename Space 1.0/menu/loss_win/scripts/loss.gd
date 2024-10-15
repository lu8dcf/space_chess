extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$loss.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main/index.tscn")


func _on_button_restart_pressed() -> void:
		get_tree().change_scene_to_file("res://game/main.tscn")
		GlobalSettings.respawn = false



func _on_button_exit_pressed() -> void:
	get_tree().quit()
