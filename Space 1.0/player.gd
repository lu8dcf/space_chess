extends CharacterBody2D

# Propiedades de la Nave
var speed = 500.0 # velocidad de movimiento de la nave
var direction = Vector2.ZERO

# Propiedades del Disparo laser
var laser_scene = preload("res://laser.tscn")  # Cargar la escena del láser
var fire_rate = 0.3  # Tiempo entre disparos (en segundos)
var time_since_last_shot = 0.0  # Contador de tiempo para controlar el disparo

var shoot_cooldown = 0.5  # Tiempo entre disparos
var can_shoot = true

# Propiedades de la Pantalla y dispositivos
var pantalla_alto = 720
var pantalla_ancho = 1280
var switch_keyboard_mouse = "mouse"



func _physics_process(delta):
	# depende de lo que elija el jugador, se ejecutara el movimiento con teclado o con mouse.
	if switch_keyboard_mouse == "keyboard":
		move_with_keyboard();
		mueve_la_nave();
		shoot_with_key();
	elif switch_keyboard_mouse == "mouse":
		move_with_mouse();
		shoot_with_click();	
		pass	
			
			
	#if Input.is_action_just_pressed("ui_esc"): # Para pausar el juego apretando la telca "esc"
		#get_tree().change_scene_to_file("res://menu/pause/pause.tscn")
#
		##$"../../main/Control/Panel/Pausa".pressed()
		#pass
		
		
		
	pass

#Movimiento y disparo con teclas
func move_with_keyboard():
	
	if Input.is_action_pressed("ui_up") and position.y > 10:
		direction.y -= 1
	if Input.is_action_pressed("ui_down") and position.y < pantalla_alto -20:
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	
	 # Aplica el movimiento
	pass
func shoot_with_key():
	if Input.is_action_just_pressed("ui_r") and can_shoot:  # disparo con la telca R
		_fire_laser()	 # Disparo del laser
	pass
func mueve_la_nave(): # Normalizar y aplicar movimiento
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

#Movimiento y disparo con mouse
func move_with_mouse(): #mover la nave con el mouse
	var main = $"../../main"
	position = main.get_local_mouse_position() # Asingna la posicion de la nave con respecto al mouse
	position.x = clamp (position.x,20, pantalla_ancho*0.94) # Limite de movimientos en ancho de pantalla
	position.y = clamp (position.y,10, pantalla_alto*0.95) # Limite de movimientos en altoo de pantalla
	Input.set_custom_mouse_cursor(load("res://recursos/cursor/point.png")) #ocultar el cursor
	pass
func shoot_with_click():
	if Input.is_action_just_pressed("ui_click_izq") and can_shoot:  # disparo con el mouse 
		_fire_laser()	 # Disparo del laser
	pass




# Función para disparar el láser
func _fire_laser():
	var laser_instance = laser_scene.instantiate()  # Instanciar el láser
	laser_instance.position = position + Vector2(0, -25) # Colocar el láser en la posición del jugador un poco adelante
	get_parent().add_child(laser_instance)  # Añadir el láser a la escena
	
	# Temporizador para control de disparo
	can_shoot = false # Detiene el disparo simulando un tiempo de recarga o calentamiento del cañon
	await get_tree().create_timer(shoot_cooldown).timeout #tiempo de espera
	can_shoot = true # vuelve  a habiliar el disparo

# La explosion de la nave
@export var explosion: PackedScene  # Exporta la escena de explosión
func _choco_player():
	# Instanciar la escena de explosión
	var explosion_instance = explosion.instantiate()
	explosion_instance.position = position  # Colocar la explosión en la posición del player
	get_parent().add_child(explosion_instance)
	explosion_instance.emitting = true
	
