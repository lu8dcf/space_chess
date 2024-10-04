extends Area2D

# Definir las rutas de las texturas
var move_step = 0.35  # Tamaño del paso en píxeles 
var move_direction = Vector2(0, 1)  # Dirección de descenso

func move_down():
	position += move_direction * move_step   # Movimiento d ela imagen
