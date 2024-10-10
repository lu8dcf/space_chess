extends Area2D

var speed = 600.0  # Velocidad del láser
var tiempo_sonido = .2

func _ready():
	$laser.play() # Sonido del laser a disparar
	
	
func _physics_process(delta):
	position.y -= speed * delta # Mover el láser hacia arriba
	# Si el láser sale de la pantalla, se elimina
	if position.y < 0:
		queue_free()

	# Laser hace impacto en un cuerpo
func _on_body_entered(body):
	#Destruir el láser y sacar vida al boss hasta liquidarlo
	if body.is_in_group("boss"):
		body._pego_el_laser()  # Llama a la función que maneja la destrucción
		queue_free()  # Elimina el láser

	elif body.is_in_group("enemy"):
		body._pego_el_laser()  # Llama a la función que maneja la destrucción
		body.queue_free()  # Elimina el objeto enemigo
		queue_free()  # Elimina el láser
