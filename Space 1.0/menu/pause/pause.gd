extends Node


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_esc"): # al presionarse la tecla ESC configurada en el proyecto el juego pasará a estar en el estado de pausa
		# de la siguiete forma se detiene el juego y si este código se recnoce que ya está en pausa, con la misma tecla se puede regresar al juego
		
		if get_tree().paused == true :
			$sound_pause_off.play()
		else:
			$sound_pause_on.play()
			
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = not get_tree().paused
		$VBoxContainer.visible = not $VBoxContainer.visible
		#$Popup.visible = not $Popup.visible

#
func _on_button_pressed() -> void:
	$VBoxContainer/buttons.play()
	get_tree().paused = not get_tree().paused
	get_tree().change_scene_to_file("res://menu/main/index.tscn")
	


func _on_button_exit_pressed() -> void:
	$VBoxContainer/buttons.play()
	get_tree().quit()
