extends Panel
# member variables here, example:

# var b="textvar"
func _on_button_pressed():
	get_node("Label").set_text("hola")
	


func _on_main_score_total(score):
	get_node("score").set_text(str(score))
	


func _on_main_perdiste():
	#get_node("perdiste").set_text("PERDISTE"))
	pass
	
