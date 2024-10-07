extends Camera2D
# Variables para controlar el temblor
var shake_intensity = 0.0  # Intensidad del temblor
var shake_time = 0.0       # Tiempo restante del temblor
var original_position = Vector2.ZERO  # Posición original de la cámara

# Función para iniciar el temblor de la pantalla
func start_shake(intensity: float, duration: float):
	shake_intensity = intensity
	shake_time = duration
	original_position = global_position  # Guardar posición original

# Función que se ejecuta cada frame
func _process(delta: float):
	if shake_time > 0:
		shake_time -= delta  # Disminuir el tiempo del temblor
		# Generar un desplazamiento aleatorio en X e Y usando la intensidad del temblor
		global_position = original_position + Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		# Restaurar la posición original cuando el temblor termina
		global_position = original_position

# Función para generar un número flotante aleatorio en un rango específico
func randf_range(min: float, max: float) -> float:
	return min + (max - min) * randf()
