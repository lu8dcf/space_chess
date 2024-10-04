extends CharacterBody2D


var move_step = 1  # Tamaño del paso en píxeles (similar a un "cuadro" de ajedrez)
var move_direction = Vector2(1, 1)  # Dirección de descenso

# Selector de velocidad por random

func move_down():
	position += move_direction * move_step
