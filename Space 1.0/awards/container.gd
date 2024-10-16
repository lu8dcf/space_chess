extends RigidBody2D


func _ready():
	add_to_group("enemy")
	$container_flip.play()

func _physics_process(delta):
	gravity_scale = 0.05

@export var explosion_enemy: PackedScene  # Exporta la escena de explosión
func _pego_el_laser():
	# Instanciar la escena de explosión
	var explosion_instance = explosion_enemy.instantiate()
	explosion_instance.position = position  # Colocar la explosión en la posición del enemigo
	get_parent().add_child(explosion_instance)
	explosion_instance.emitting = true
	
	# Instanciar el  (premio) una vida
	var premio_instance = preload("res://awards/award.tscn").instantiate()  # Asegúrate de cambiar la ruta a tu escena
	premio_instance.position = position  # Colocar el premio en la misma posición
	get_parent().add_child(premio_instance)  # Agregar el premio al padre del enemigo

# Choque de la piedra con el Player
func _on_area_2d_body_entered(body):
	# Destruir la roca y player con el que colisiona
	if body.is_in_group("player"):
		body._choco_player()  # Llama a la función que maneja la destrucción
		body.queue_free()  # Elimina el objeto player
		queue_free()  # Elimina la roca
	pass # Replace with function body.
