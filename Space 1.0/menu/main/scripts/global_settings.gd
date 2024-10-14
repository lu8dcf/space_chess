extends Node

# señales 
#signal brightness_updated(value)
signal mouse_sens_updated(value)
signal game_multiplayer_main(value)

# variables
var game_multiplayer = false
var mouse_sens = 0.5
var respawn = false

# propiedades de las naves
var speed_main = 500
var deadzone_radius_main = 20 

# predeterminar los valores para que el jugador 1 empiece con mouse y el 2 empiece con teclas WSAD
var player1_switch_keyboard_mouse = true# si es true es mouse, si es false son teclas
var player1_arrows_or_awsd =  true #si es true, juega con flechas, si es false, juega con AWSD
var player2_switch_keyboard_mouse = false # si es true es mouse, si es false son teclas
var player2_arrows_or_awsd =  false #si es true, juega con flechas, si es false, juega con AWSD

# pantalla
var pantalla_ancho = 1200
var pantalla_alto = 720

# creditos


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
	emit_signal("game_multiplayer_main",toggle)
	game_multiplayer = toggle

func move_player1(index): # indice= 0-mouse  1-arrow keys   2- WSAD keys
	if index == 0:
		player1_switch_keyboard_mouse = true
	elif index == 1:
		player1_arrows_or_awsd = true
		player1_switch_keyboard_mouse = false
	elif index == 2:
		player1_arrows_or_awsd = false
		player1_switch_keyboard_mouse = false
	
func move_player2(index):
	if index == 0:
		player2_switch_keyboard_mouse = true
	elif index == 1:
		player2_arrows_or_awsd = true
		player2_switch_keyboard_mouse = false
	elif index == 2:
		player2_arrows_or_awsd = false
		player2_switch_keyboard_mouse = false
	
	
	
func update_mouse_sens(value):
	emit_signal("mouse_sens_updated", value)
	mouse_sens = value
