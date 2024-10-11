extends Area2D

# Aparece la nave como premio de 1 vida 

func _on_body_entered(body): #cuando el player toca el premio
	
	if body.is_in_group("player"): # que sea el player
		Global.lives +=1
		$win_prize.play()
		queue_free()  # Elimina el icono
	pass # Replace with function body.
