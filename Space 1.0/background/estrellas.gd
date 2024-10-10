extends RigidBody2D


# Estrellas, son una imagen que da la sensacion de avance de la nave porque las estrellas se desplazan

func _physics_process(delta):
	gravity_scale = 0.005
	mass = 0.003
