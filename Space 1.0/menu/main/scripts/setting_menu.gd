extends Popup


# iniciar los botones de opciones

#Video settings
@onready var display_options = $settings_tabs/Video/MarginContainer/video_settings/OptionButton

# Audio settingss
@onready var master_slider = $settings_tabs/Audio/MarginContainer/audio_settings/HBoxContainer/master_slider
@onready var music_slider = $settings_tabs/Audio/MarginContainer/audio_settings/HBoxContainer2/music_slider
@onready var sfx_slider = $settings_tabs/Audio/MarginContainer/audio_settings/HBoxContainer3/sfx_slider

# Gameplay settings
@onready var check_multi = $"settings_tabs/Game Mode/MarginContainer/game_settings/HBoxContainer4/check_multiplayer"
@onready var mouse_sens_amount = $"settings_tabs/Game Mode/MarginContainer/game_settings/HBoxContainer3/gameplay_label3"
@onready var mouse_slider = $"settings_tabs/Game Mode/MarginContainer/game_settings/HBoxContainer3/mouse_slider"

func _ready() -> void:
	pass
	
	




func _on_option_button_item_selected(index: int) -> void:
	GlobalSettings.change_display_mode(index) # se envia un 0 = windowed o un 1 = fullscreen, para que la funcion se encargue de cambiar el tamañao de la pantalla


func _on_master_slider_value_changed(value: float) -> void:
	GlobalSettings.update_master_vol(0,value)

func _on_music_slider_value_changed(value: float) -> void:
	GlobalSettings.update_master_vol(1,value)

func _on_sfx_slider_value_changed(value: float) -> void:
	GlobalSettings.update_master_vol(2,value)

#func _on_check_multiplayer_pressed(button_pressed: bool) -> void:
	#GlobalSettings.game_mode_multiplayer(button_pressed)

func _on_check_multiplayer_toggled(toggled_on: bool) -> void:
	GlobalSettings.game_mode_multiplayer(toggled_on)
	print(toggled_on)

func _on_mouse_slider_value_changed(value: float) -> void:
	GlobalSettings.update_mouse_sens(value)
	mouse_sens_amount.text = str(value)
