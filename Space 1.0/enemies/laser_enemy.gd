extends Area2D

var speed = 600.0  # Velocidad del láser
var pantalla_ancho = Global.pantalla_ancho
var pantalla_alto = Global.pantalla_alto

func _physics_process(delta):
	position.y += speed * delta # Mover el láser hacia arriba
	# Si el láser sale de la pantalla, se elimina
	if position.y > pantalla_alto:
		queue_free()

	# Laser hace impacto en un cuerpo
func _on_body_entered(body):
	# Destruir el láser y el cuerpo con el que colisiona
	if body.is_in_group("player"):
		body._choco_player()  # Llama a la función que maneja la destrucción
		body.queue_free()  # Elimina el objeto enemigo
		queue_free()  # Elimina el láser




	
