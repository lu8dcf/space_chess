extends CharacterBody2D

# Propiedades de la Nave
var speed = 500.0 # velocidad de movimiento de la nave
var speed2 = 5.5
var direction = Vector2.ZERO

# Propiedades del Disparo laser
var laser_scene = preload("res://laser.tscn")  # Cargar la escena del láser
var fire_rate = 0.3  # Tiempo entre disparos (en segundos)
var time_since_last_shot = 0.0  # Contador de tiempo para controlar el disparo

var shoot_cooldown = 0.5  # Tiempo entre disparos
var can_shoot = true

# Propiedades de la Pantalla y dispositivos
var pantalla_alto = 650
var pantalla_ancho = 1200
var switch_keyboard_mouse = null



func _physics_process(delta):
	Move_with_keyboard()

	
	if Input.is_action_just_pressed("ui_r") and can_shoot:  # disparo cuando se presiona la tecla "R"
		_fire_laser()	 # Disparo del laser
	
	if Input.is_action_just_pressed("ui_esc"):
		get_node("../../main/Control/Panel/Pausa").button_pressed = true
		pass
		
	pass
	# PARA AGREGAR CUANDO EL MENÚ ESTÉ HECHO // es para la elección del modo de juego (mouse - teclado)
	
	#var node2d_nave = $"../../main" #MAIN 
	#if switch_keyboard_mouse == "keyboard":
		#Mover_con_teclado();
		#Disparar_con_tecla();
	#elif switch_keyboard_mouse == "mouse":
		#move_with_mouse()
		#shoot_with_click()	
		#pass
	#pass	
	
	# ------------------------------------

	
	
	

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
	
	
# --

func Move_with_keyboard():
	Move_up()
	Move_down()
	Move_right()
	Move_left()
	Stop()
	move_and_collide(direction)
	pass
	
func Move_up():
	if Input.is_action_pressed("ui_w"):
		direction.y = -speed2
	pass

func Move_down():
	if Input.is_action_pressed("ui_s"):
		direction.y = speed2
	pass

func Move_right():
	if Input.is_action_pressed("ui_d"):
		direction.x = speed2
	pass

func Move_left():
	if Input.is_action_pressed("ui_a"):
		direction.x = -speed2
	pass

func Stop():
	if (Input.is_action_just_released("ui_d") or
			Input.is_action_just_released("ui_a") or
			Input.is_action_just_released("ui_s") or
			Input.is_action_just_released("ui_w")):
		direction.x = 0
		direction.y = 0
	pass



	
func move_with_mouse(): #mover la nave con el mouse
	var main = $"../../main"
	position = main.get_local_mouse_position() # Asingna la posicion de la nave con respecto al mouse
	position.x = clamp (position.x,20, pantalla_ancho*0.94) # Limite de movimientos en ancho de pantalla
	position.y = clamp (position.y,10, pantalla_alto*0.95) # Limite de movimientos en altoo de pantalla
	Input.set_custom_mouse_cursor(load("res://recursos/cursor/point.png")) #ocultar el cursor
	pass
