extends CharacterBody2D
# enemigo4 BOSS - CABALLO
var pasos = 5  # Tamaño del paso en píxeles (similar a un "cuadro" de ajedrez)
var move_direction = Vector2(1, 0)  # Dirección de descenso
var cantidad_pasos = 0  # pasos para la logica de movimiento lateral
var rand = RandomNumberGenerator.new() #semilla de aleatoriedad
var vida_boss = 20
var nueva_direccion_y=0

# laser enenmigo
var can_shoot = true # habilita el disparo del laser
var laser_scene = preload("res://laser_enemy.tscn")  # Cargar la escena del láser
var tiempo_entre_laser =  0.1 

# pantalla
var pantalla_ancho = 1200
var pantalla_alto = 720

func _ready():
	add_to_group("enemy") # Agrega al Grupo enemigo, para poder ser destruido por el laser del player
	
	change_velocity()
	

func change_velocity():
	var random_integer = rand.randi_range(0, 1)  # Genera un número entre 0  y 2 (inclusive)
	if random_integer==0:  # diferentes velocidades con valores random
		pasos *= 2
	elif  random_integer==1:
		pasos /= 2
		
# Mueve al enemigo un paso hacia abajo (simulando un Caballo)
func move_down():
	if cantidad_pasos == 30: # cada 30 pasos cambia de direccion
		_fire_laser() # dispara el laser
		cantidad_pasos = 0 # reseteo los pasos
		
		# Cambio horizontal
		var nueva_direccion_x = rand.randi_range(-1, 1)  # Genera un número entre -1  y 1 para determinar la direccion x
		# -1 - izquierda , 1 - derecha , 0 salto
		if nueva_direccion_x == 0: #Salto
			position.x += 50
			# Cambnio Vertical
		var nueva_direccion_y = rand.randi_range(-1, 1)  # Genera un número entre -1  y 1 para determinar la direccion y
		
		
		#if nueva_direccion_y == 0: #invierte el trayecto
			#position.y += 20
		#else:
			#position.y -= 20
		#clamp (position.y,0,80)
		move_direction = Vector2(nueva_direccion_x, nueva_direccion_y)  # cambia derecha o izquierda
		
		
	# logica de saltos largos, cambia 6 veces que corresponden a 3 cuadros , 
	if position.x < 100:  # que no se valla de la pantalla
		position.x *= 6
	if position.x > 0.8 * pantalla_ancho:
		position.x /= 6
	if position.y < -10:  # que no se valla de la pantalla
		position.y *= -10 # salta haci abajo
	if position.y > .5 * pantalla_alto:
		position.y /= 6 # salta hacia arriba
	cantidad_pasos +=1	# agrega un paso
	position += move_direction * pasos

@export var explosion_enemigo: PackedScene  # Exporta la escena de explosión boss
@export var pego_laser: PackedScene  # Exporta la escena de lcada laser que pega en el boss

# Cuando el laser del player impacta en el Boss
func _pego_el_laser():
	
	var explosion_instance = pego_laser.instantiate() # Instanciar la escena de laser
	explosion_instance.position = position  # Colocar la explosión en la posición del enemigo
	get_parent().add_child(explosion_instance) # Agregar de hijo 
	explosion_instance.emitting = true  # Iniciar la emisión de partículas
	
	vida_boss -= 1 # le quita una vida al boss
	
	if vida_boss == 0:  # si se queda sin vidas el boss termina
		queue_free()  # Elimina el láser
		var explosion_boss = explosion_enemigo.instantiate() # Instanciar la escena de explosión
		explosion_boss.position = position  # Colocar la explosión en la posición del enemigo
		get_parent().add_child(explosion_boss) # Agregar de hijo 
		explosion_boss.emitting = true  # Iniciar la emisión de partículas
		
	
	
func _on_area_2d_body_entered(body):
	# Destruir la roca y player con el que colisiona
	if body.is_in_group("player"):
		body._choco_player()  # Llama a la función que maneja la destrucción
		body.queue_free()  # Elimina el objeto player
		queue_free()  # Elimina la roca
	

# Función para disparar el láser enemigo
func _fire_laser():
	
	can_shoot = false
	var laser_instance = laser_scene.instantiate()  # Instanciar el láser
	laser_instance.position = position + Vector2(0, 0) # Colocar el láser en la posición del jugador un poco adelante
	get_parent().add_child(laser_instance)  # Añadir el láser a la escena
	# Temporizador para control de disparo
	await get_tree().create_timer(tiempo_entre_laser).timeout  # Esperar el tiempo de cooldown
	
	can_shoot = true
