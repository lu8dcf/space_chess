extends CharacterBody2D

# Propiedades de la Nave
var speed = GlobalSettings.speed_main # velocidad de movimiento de la nave
var direction = Vector2.ZERO
var deadzone_radius : float = GlobalSettings.deadzone_radius_main  # Zona muerta para cuando el mouse se alinea con la nave

var mouse_sensitivy = GlobalSettings.mouse_sens # se utiliza la variable global que se modifica en el menu de opciones

# Propiedades del Disparo laser
var laser_scene = preload("res://player/laser.tscn")  # Cargar la escena del láser
var fire_rate = 0.3  # Tiempo entre disparos (en segundos)
var time_since_last_shot = 0.0  # Contador de tiempo para controlar el disparo

var shoot_cooldown = 0.5  # Tiempo entre disparos
var can_shoot = true

# Propiedades de la Pantalla y dispositivos
var pantalla_ancho = Global.pantalla_ancho
var pantalla_alto = Global.pantalla_alto
var switch_keyboard_mouse = GlobalSettings.player1_switch_keyboard_mouse # si es true es mouse, si es false son teclas
var arrows_or_awsd = GlobalSettings.player1_arrows_or_awsd #si es true, juega con flechas, si es false, juega con AWSD



func _physics_process(delta):
	# depende de lo que elija el jugador, se ejecutara el movimiento con teclado o con mouse.
	if switch_keyboard_mouse:
		move_with_mouse();
		shoot_with_click();
	else:
		move_with_keyboards();
		shoot_with_key();

	pass

#movimiento con teclado, depende que elija el usuario, ejecuta la funcion de flechas o "awsd"
func move_with_keyboards():
	var multip = $"/root/GlobalSettings".game_multiplayer
	if arrows_or_awsd or multip:
		move_with_arrows();
	else:
		move_with_key();

#Movimiento y disparo con teclas
func move_with_key(): #se mueve usando a,w,s,d
	var move_vector = Vector2.ZERO
	
	if Input.is_action_pressed("ui_w") and position.y > 10:
		move_vector.y -= 1
	if Input.is_action_pressed("ui_s") and position.y < pantalla_alto -20:
		move_vector.y += 1
	if Input.is_action_pressed("ui_a"):
		move_vector.x -= 1
	if Input.is_action_pressed("ui_d"):
		move_vector.x += 1
		
		#normaliza el movimiento
	if move_vector.length() > 0:
		move_vector = move_vector.normalized() * speed * mouse_sensitivy # el mouse sensitivity para que tenga la misma sensibilidad que elmouse
	velocity = move_vector
	move_and_slide()
	pass

func move_with_arrows(): # se mueve usando las flechas
	var move_vector = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up") and position.y > 10:
		move_vector.y -= 1
	if Input.is_action_pressed("ui_down") and position.y < pantalla_alto -20:
		move_vector.y += 1
	if Input.is_action_pressed("ui_left"):
		move_vector.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_vector.x += 1
		
		#normaliza el movimiento
	if move_vector.length() > 0:
		move_vector = move_vector.normalized() * speed * mouse_sensitivy # el mouse sensitivity para que tenga la misma sensibilidad que elmouse
	velocity = move_vector
	move_and_slide()

func shoot_with_key():
	if Input.is_action_just_pressed("ui_ctrl") and can_shoot:  # disparo con la telca R
		_fire_laser()	 # Disparo del laser
	pass


#Movimiento y disparo con mouse
func move_with_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN) # oculta el mouse y evita que salga de la pantalla del videojuego
	var move_vector = Vector2.ZERO
	var mouse_position = get_viewport().get_mouse_position() #posicion del mouse
	var direction_to_mouse = (mouse_position - global_position) #la distancia entre el mouse y la nave
	#position.x = clamp (position.x,20, pantalla_ancho* .98) # Limite de movimientos en ancho de pantalla
	#position.y = clamp (position.y,10, pantalla_alto*0.95) # Limite de movimientos en altoo de pantalla

	
	if direction_to_mouse.length() > deadzone_radius:
		direction_to_mouse = direction_to_mouse.normalized() * speed * mouse_sensitivy #si no está dentro de la zona muerta, se mueve
	else:
		direction_to_mouse = Vector2.ZERO  # Si está en la zona muerta, no se mueve
	move_vector += direction_to_mouse
	velocity = move_vector
	move_and_slide()
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
