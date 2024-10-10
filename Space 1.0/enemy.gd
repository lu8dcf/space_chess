extends CharacterBody2D

# enenmigo1 Verde PEON
var pasos = 4  # Velocidad  del paso de referencia (similar a un "cuadro" de ajedrez)
var move_direction = Vector2(0, 1)  # Dirección de descenso sollo en eje y
var rand = RandomNumberGenerator.new() # semilla de random segun el tiempo
@export var explosion: PackedScene  # Exporta la escena de explosión

func _ready():
	add_to_group("enemy") # Agrega al grupo enemigo para poder ser destruido por el laser player
	
	cambio_velocidad() # Selector de velocidades de las distintas instancias por random
			
	
	# Cada instancia tendra una velocidad diferente aleatoria
func cambio_velocidad():
	var random = rand.randi_range(0, 2)  # Genera un número entre 0  y 2 (inclusive)
	match random:
		0:
			pasos /= 2      # divide la velocidad
		1:
			pasos *= 2		# duplica la velicidad
		2:	
			pasos += 1 		# suma 1 cuadro mas veloz
		
# Mueve al enemigo un paso hacia abajo (simulando un peón)
func move_down():
	position += move_direction * pasos
	#set_vector(get_node("../Mara").global_position - global_position)

# LASER del PLAYER cuando el laser del player impacta en el enemigo y lo destruye, sonido y animaciom
func _pego_el_laser():
	# Instanciar la escena de explosión
	var explosion_instance = explosion.instantiate()
	explosion_instance.position = position  # Colocar la explosión en la posición del enemigo
	get_parent().add_child(explosion_instance)
	explosion_instance.emitting = true
	
# COLISION Destruir el enemigo y player con el que colisiona
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body._choco_player()  # Llama a la función que maneja la destrucción
		body.queue_free()  # Elimina el objeto player
		queue_free()  # Elimina el enemigo verde
	
