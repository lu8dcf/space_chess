extends CharacterBody2D
# enemigo2 Naranja - TORRE
var pasos = 6  # Tamaño del paso en píxeles (similar a un "cuadro" de ajedrez)
var move_direction = Vector2(0, 1)  # Dirección de descenso
var cantidad_pasos = 0  # pasos para la logica de movimiento lateral
var rand = RandomNumberGenerator.new() #semilla de aleatoriedad

# Laser enemigo
var can_shoot = true # habilita el disparo del laser ( ya que hay un tiempo entre disparos)
var laser_scene = preload("res://laser_enemy.tscn")  # Cargar la escena del láser enemigo
var tiempo_entre_laser =  1  # Cada un segundo es el tiempo

# Selector de velocidad por random
func _ready():
	add_to_group("enemy")   # Agrega la instancia al grupo enemigo
	
	velocidad_aleatoria()
	

# Mueve al enemigo un paso hacia abajo (simulando una Torre)
func move_down():
	# cada 8 pasos cambia de direccion
	if cantidad_pasos==8:
		var nueva_direccion_x = rand.randi_range(-1, 1)  # Genera un número entre 0  y 2 (inclusive)
		move_direction = Vector2(nueva_direccion_x, 0)  # cambia derecha o izquierda
		if nueva_direccion_x==0:   # si es 0 solo baja y dispara laser
			move_direction = Vector2(0, 1)
			cantidad_pasos=-8
			if can_shoot==true:  #  dispara si esta habilitado por tiempo
				_fire_laser()
		else:
			cantidad_pasos=0
	cantidad_pasos +=1		
	position += move_direction * pasos # movimiento de la intacion enemiga

@export var explosion: PackedScene  # Exporta la escena de explosión
func _pego_el_laser():
	var explosion_instance = explosion.instantiate() # Instanciar la escena de explosión
	explosion_instance.position = position  # Colocar la explosión en la posición del enemigo
	get_parent().add_child(explosion_instance) # Agregar de hijo 
	explosion_instance.emitting = true  # Iniciar la emisión de partículas
	
	# Destruir la roca y player cuando colisionan
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body._choco_player()  # Llama a la función que maneja la destrucción
		body.queue_free()  # Elimina el objeto player
		queue_free()  # Elimina la roca
	
func _fire_laser():
	var laser_instance = laser_scene.instantiate()  # Instanciar el láser
	laser_instance.position = position + Vector2(0, 0) # Colocar el láser en la posición del jugador un poco adelante
	get_parent().add_child(laser_instance)  # Añadir el láser a la escena
	
	# Temporizador para control de disparo, en un tiempo
	can_shoot = false
	await get_tree().create_timer(tiempo_entre_laser).timeout  # Esperar el tiempo 
	can_shoot = true
	
	# Cada instancia tendra diferentes velocidades de desplazammiento
func velocidad_aleatoria():  
	var random_integer = rand.randi_range(0, 2)  # Genera un número entre 0  y 2 (inclusive)
	if random_integer==1:  # diferentes velocidades con valores random
		pasos *= 2
	elif  random_integer==2:
		pasos /= 2
