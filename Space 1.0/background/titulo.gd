extends Panel
# member variables here, example:


func _on_main_score_total(score):
	get_node("score").set_text(str(score))
	


func _on_main_perdiste():
	#get_node("perdiste").set_text("PERDISTE"))
	pass
	


func _on_main_live(vidas) -> void:
	get_node("live").set_text(str(vidas))
	pass # Replace with function body.


func _on_main_loss() -> void:
	pass # Replace with function body.


func _on_main_rocas_falta_container(rocas_eliminadas_antes) -> void:
	get_node("rocas_container").set_text(str(rocas_eliminadas_antes))
	pass # Replace with function body.
