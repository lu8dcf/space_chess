extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:

	body._pego_el_laser()  # Llama a la función que maneja la destrucción
	body.queue_free()  # Elimina el objeto enemigo
	#if body != $"roca":
		#get_node("res://game/main.tscn").score -= 10	
	pass # Replace with function body.
