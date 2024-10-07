extends CharacterBody2D
# enemigo2 Rojo - ALFIL
var pasos = 6  # Tamaño del paso en píxeles (similar a un "cuadro" de ajedrez)
var move_direction = Vector2(1, 1)  # Dirección de descenso
var cantidad_pasos = 0  # pasos para la logica de movimiento lateral
var rand = RandomNumberGenerator.new() #semilla de aleatoriedad

# laser enenmigo
var can_shoot = true # habilita el disparo del laser
var laser_scene = preload("res://laser_enemy.tscn")  # Cargar la escena del láser
var tiempo_entre_laser =  0.1 
# Selector de velocidad por random

func _ready():
	add_to_group("enemy") # Agrega al Grupo enemigo, para poder ser destruido por el laser del player
	
	velocidad_aleatoria()
	

# Mueve al enemigo un paso hacia abajo (simulando una Torre)
func move_down():
	# cada 8 pasos cambia de direccion
	if cantidad_pasos==8:
		var nueva_direccion_x = rand.randi_range(-1, 1)  # Genera un número entre -1  y 1 (inclusive)
		
		if nueva_direccion_x == 0: #invierte el trayecto
			nueva_direccion_x = -move_direction.x  
			_fire_laser() # dispara el laser
		
		move_direction = Vector2(nueva_direccion_x, 1)  # cambia derecha o izquierda
		
	cantidad_pasos +=1		# suma un paso
	position += move_direction * pasos

@export var explosion_enemigo: PackedScene  # Exporta la escena de explosión
func _pego_el_laser():
	#var explosion_instance = explosion_enemigo.instantiate() # Instanciar la escena de explosión
	#explosion_instance.position = position  # Colocar la explosión en la posición del enemigo
	#get_parent().add_child(explosion_instance) # Agregar de hijo 
	#explosion_instance.emitting = true  # Iniciar la emisión de partículas
	pass
	
	
func _on_area_2d_body_entered(body):
	# Destruir la roca y player con el que colisiona
	if body.is_in_group("player"):
		body._choco_player()  # Llama a la función que maneja la destrucción
		body.queue_free()  # Elimina el objeto player
		queue_free()  # Elimina la roca
	

# Función para disparar el láser
func _fire_laser():
	var laser_instance = laser_scene.instantiate()  # Instanciar el láser
	laser_instance.position = position + Vector2(0, 0) # Colocar el láser en la posición del jugador un poco adelante
	get_parent().add_child(laser_instance)  # Añadir el láser a la escena
	
	# Temporizador para control de disparo
	can_shoot = false
	await get_tree().create_timer(tiempo_entre_laser).timeout  # Esperar el tiempo de cooldown
	can_shoot = true

func velocidad_aleatoria():
	var random_integer = rand.randi_range(0, 2)  # Genera un número entre 0  y 2 (inclusive)
	
	if random_integer==1:  # diferentes velocidades con valores random
		pasos *= 2 # duplica la velocidad
	elif  random_integer==2:
		pasos /= 2 # divide la velocidad
