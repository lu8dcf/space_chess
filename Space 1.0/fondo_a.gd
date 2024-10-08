extends Area2D
@onready var Fondo = $Fondo  # Es el nodo del fondo
@onready var star = $star  # Es en nodo de las estrellas
var nuevo_fondo = preload("res://recursos/fondo/Fondo0.png")  # fondo por defecto
@onready var menu_text_stages = $"../menu_text_stages"
@onready var label_text_stages = $label_stage



@export var vibracion : Camera2D  # Nodo Camera2D para el temblor


func _on_main_stage(stage_actual):
	# se muestra en la label de la izq el texto del stage actual
	label_text_stages.text = "STAGE " + str(stage_actual)
	
	match stage_actual:   # Cambio de fondo al cambiar de STAGE
		1: 
			nuevo_fondo = preload("res://recursos/fondo/Fondo1.png")  # Carga la nueva imagen
			
		2:
			
			nuevo_fondo = preload("res://recursos/fondo/Fondo2.png")  # Carga la nueva imagen
			
		3:
			nuevo_fondo = preload("res://recursos/fondo/Fondo3.png")  # Carga la nueva imagen
			
		4:
			nuevo_fondo = preload("res://recursos/fondo/Fondo4.png")  # Carga la nueva imagen
	
	#  vibración de la pantalla	 y mensaje de Stage
	
	show_stage_popup(stage_actual)  # Muestra el popup con el texto del stage
	
	$vibracion.start_shake(10, 1) # vibracion d ela pantalla Intensidad 10, duración 1 segundos
	$subir_nivel.play() # Sonido del nivel
	Fondo.texture = nuevo_fondo  # # Asigna el nuevo fondo
	await get_tree().create_timer(5.5).timeout  # Esperar el tiempo de cooldown
	
	hide_stage_popup()  # Oculta el popup después del temblor
	
	# reinicia las estrellas
	star.position = Vector2(0, 0)  # Restablece la posición a (0, 0)
	
	star.linear_velocity = Vector2.ZERO  # Detiene el movimiento
	#star.angular_velocity = 0  # Detiene la rotación
	
	
# Función para mostrar el popup con animación de agrandar la fuente
func show_stage_popup(stage: int):
	menu_text_stages.popup()  # Muestra el Popup
	var label = menu_text_stages.get_node("Label")
	label.text = "STAGE " + str(stage)  # Actualiza el texto con el número de etapa
	
	# Crea el Tween para animar la escala y el tamaño de la fuente
	var tween = get_tree().create_tween()  # Crea el tween para la animación
	
	# Se utiliza una animación Tween de Godot 4 para hacer crecer la escala y el tamaño de la fuente
	
	# Ajustamos las propiedades de transición y easing en líneas separadas
	tween.tween_property(label, "rect_scale", Vector2(100, 100), 5.5)  # Animar la escala
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	
# Función para ocultar el popup
func hide_stage_popup():
	menu_text_stages.hide()  # Oculta el Popup
