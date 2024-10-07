extends CharacterBody2D

# Propiedades de la Nave
var speed = 500.0 # velocidad de movimiento de la nave
var speed2 = 10
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



func _physics_process(delta):
	Move_with_keyboard()
	shoot_with_key()
	
	pass


func Move_with_keyboard():
	Move_up()
	Move_down()
	Move_right()
	Move_left()
	Stop()
	#if direction != Vector2.ZERO:
		#direction = direction.normalized()
		#direction = direction*speed
	move_and_collide(direction)
	pass
	
func Move_up():
	if Input.is_action_pressed("ui_w") and position.y > 10:
		direction.y = -speed2
	pass

func Move_down():
	if Input.is_action_pressed("ui_s") and position.y < pantalla_alto -20:
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

func shoot_with_key():
	if Input.is_action_just_pressed("ui_r") and can_shoot:  # disparo cuando se presiona la tecla "R"
		_fire_laser()	 # Disparo del laser
		_fire_laser()
	pass	

# La explosion de la nave
@export var explosion: PackedScene  # Exporta la escena de explosión
func _choco_player():
	# Instanciar la escena de explosión
	var explosion_instance = explosion.instantiate()
	explosion_instance.position = position  # Colocar la explosión en la posición del player
	get_parent().add_child(explosion_instance)
	explosion_instance.emitting = true
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
	pass
