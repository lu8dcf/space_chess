extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("boss"): # si lo que collisiona es el boss, ejecuta lo siguiente
		body.vida_boss -= 1 #le resta una vida al boss
		queue_free()#elimina el escudo
	else:
		body._pego_el_laser()  # Llama a la función que maneja la destrucción
		body.queue_free()  # Elimina el objeto enemigo
	pass
