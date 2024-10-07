extends Area2D
@onready var Fondo = $Fondo  # Es el nodo del fondo
@onready var star = $star  # Es en nodo de las estrellas
var nuevo_fondo = preload("res://recursos/fondo/Fondo0.png")  # fondo por defecto


func _on_main_stage(stage_actual):
	
	match stage_actual:   # Cambio de fondo al cambiar de STAGE
		1: 
			nuevo_fondo = preload("res://recursos/fondo/Fondo1.png")  # Carga la nueva imagen
			
		2:
			
			nuevo_fondo = preload("res://recursos/fondo/Fondo2.png")  # Carga la nueva imagen
			
		3:
			nuevo_fondo = preload("res://recursos/fondo/Fondo3.png")  # Carga la nueva imagen
			
		4:
			nuevo_fondo = preload("res://recursos/fondo/Fondo4.png")  # Carga la nueva imagen
	
	# Pausa		
	get_tree().paused = true
	await get_tree().create_timer(1).timeout  # Esperar el tiempo de cooldown
	get_tree().paused = false	
	
	# Asigna el nuevo fondo
	Fondo.texture = nuevo_fondo  # Cambia la textura del sprite
	
	# reinicia las estrellas
	
	star.position = Vector2(0, 0)  # Restablece la posición a (0, 0)
	
	star.linear_velocity = Vector2.ZERO  # Detiene el movimiento
	#star.angular_velocity = 0  # Detiene la rotación
	
	# Cambia a estático para detener el cuerpo
	#star.set_deferred("mode",RigidBody2D.STAT)
	
	#position = Vector2(0, 0)  # Restablece la posición
	#linear_velocity = Vector2.ZERO  # Detiene el movimiento
	#angular_velocity = 0  # Detiene la rotación

	# Espera un momento y luego cambia a RIGID
	#await get_tree().create_timer(0.1).timeout  # Esperar el tiempo de cooldown
	
	#set_deferred("mode", RigidBody2D.MODE_RIGID)  # Reactiva la física
	
	
	pass 
