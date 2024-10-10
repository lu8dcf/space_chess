extends CPUParticles2D

# Referencias a los nodos
@onready var explosion = $sonido_explosion_player

func _ready():
	# Iniciar las partículas y reproducir el sonido
	activate_particles()

func activate_particles():
	explosion.play()  # Reproduce el sonido
