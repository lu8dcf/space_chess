extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sound_intro.play()
	pass # Replace with function body.



func _on_play_pressed() -> void: # al hacer click en el boton de JUGAR empieza el juego en el nivel 1
	$VBoxContainer/buttons.play()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_quit_pressed() -> void: # al hacer click en el boton de SALIR se cerrará el programa 
	$VBoxContainer/buttons.play()
	get_tree().quit()


func _on_options_pressed() -> void:  # al hacer click en el boton de OPCIONES se reedirige al menu de opciones
	$VBoxContainer/buttons.play()
	$SettingMenu.popup()
