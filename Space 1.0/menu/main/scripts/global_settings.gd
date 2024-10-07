extends Node

#signal brightness_updated(value)
signal mouse_sens_updated(value)
signal game_multiplayer(value)
signal game_multiplayer_main(value)
# funciones de video

func change_display_mode(toggle: bool):
	if toggle:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)

# funciones de audio
#func updated_brightness(value):
	#emit_signal("brightness_updated", value)
	
#func update_master_vol(bus_inx, vol): # -50 es el valor mínimo del slider
	#AudioServer.set_bus_volume_db(bus_inx,vol if vol >-50 else AudioServer.set_bus_mute(bus_inx,true))
func update_master_vol(bus_inx, vol):
	if vol > -50:
		AudioServer.set_bus_volume_db(bus_inx, vol)
		AudioServer.set_bus_mute(bus_inx, false)
	else:
		AudioServer.set_bus_mute(bus_inx, true)
		
	
# funciones de gameplay
func game_mode_multiplayer(toggle):
	emit_signal("game_multiplayer",toggle)
	emit_signal("game_multiplayer_main",toggle)
	
	
func update_mouse_sens(value):
	emit_signal("mouse_sens_updated", value)
