extends Node2D

#tamaño de pantalla
var pantalla_ancho = Global.pantalla_ancho
var pantalla_alto = Global.pantalla_alto
var rand = RandomNumberGenerator.new() # semilla de random segun el tiempo

# Enemigos
var enemies = []  # Almacenará las instancias de enemigos
var enemies_boss = [] # Almacenara las instancias de los enemigos Boss
var movimiento_enemigo = GlobalSettings.intervalo_movimiento_enemigo  # Intervalo de tiempo para el movimiento enemigo
var timer_aparece_enemigo = GlobalSettings.tiempo_que_aparece_enemigo # 1seg Intervalo que aparecen los enemigos
var boss_activo=0 # Bandera para Agregar secuaces al BOSS

# Rocas
var rocas = [] # Almacena las instancias de las rocas
var timer_aparece_rocas = GlobalSettings.tiempo_que_aparece_rocas # 1 seg Intervalo que aparecen los enemigos

# Container
var containers =[] # Almacena los contenedores con premios
signal rocas_falta_container # cantidad de rocas para el container
var rocas_eliminadas_antes= 0 # Control de piedras eliminadas antes de obtener el container
var rocas_container= GlobalSettings.cant_rocas_para_obtener_contenedor # Cantidad de rocas eliminadas necesarias para obtener un container con una vida

# Fondo
var planetas = [] # planetas del fondo
var planeta = null
var planeta_x = 0.3 * pantalla_ancho # ubicacion inicial del planeta en ele eje x
@onready var musica_base = $musica_base  # musica base, para aumentar la emosion se cambia su velocidad
@onready var loss_ = $loss_  # Sonido de haber perdido

# Fondo perder y ganar
@onready var back_loss = $Node/bacground_win
@onready var back_win = $Node/background_loss


# Player
var player = null
var screen_live = Global.lives   # cantidad de vidas que se muestran en pantalla
signal live  # muestra las vidas activas

# Player2
var player2 = null
var multi_player = GlobalSettings.game_multiplayer
var multiplex = 1

# Puntos del juego
var score = 0 # Puntos totales
var screen_score = 0 # Puntos que se muestran
var score_stage = 0 # Puntos del stage
var stage_actual = 1
signal score_total
signal stage # Indicador de Stage actual
signal loss
var stage_anterior = 0 #Inicio de la partida




func _ready():	
	
	multiplayer_game()

	inicia_planeta(planeta_x) # Instanciar planeta del fondo con movimiento
		
	inicia_player() # Instanciar y añadir la nave del jugador en el punto central abajo
		
	inicia_player2() # Instancia la nave 2
		
	temporizador_agrega_enemigos() # Timer que marca los tiempos que se instancian los enemigos
		
	temporizador_agrega_rocas() #Timer que marca los tiempos que se intancian las rocas
	
	temporizador_mueve_enemigos() # Timer para controlar el movimiento de las naves enemigas
	
	musica_juego()	
	
func multiplayer_game():
	if multi_player: # si es multiplayer se duplican los valores para pasar de nivel
		Global.lives *=2  # duplica la cantidad de vidas
		multiplex = 2 # duplica los puentos para pasar de nivel
		
# Función para el callback de multijugador
func _on_check_multiplayer_toggled(toggle: bool):
	print("¡Se ha activado la función de multijugador! main")
	multi_player = toggle
	if multi_player and player2 == null:
		inicia_player2()  # Instanciar jugador 2 si no está ya presente
	elif not multi_player and player2 != null:
		player2.queue_free()  # Eliminar el jugador 2 si se desactiva el multijugador
		player2 = null
		
func inicia_planeta(ubicacion_x): # Instanciar planeta
	planeta = preload("res://background/planeta.tscn").instantiate()
	planeta.position = Vector2(planeta_x,0)  # Colocar al planeta en la parte superioir fuera a un cuato de X
	add_child(planeta)  # Agrega el nodo hijo
	
func inicia_player():  # Inicia al player 1
	player = preload("res://player/player.tscn").instantiate()
	player.position = Vector2(pantalla_ancho/2,0.9*pantalla_alto)  # Colocar al jugador en la parte inferior al centro
	add_child(player)  # Agrega el nodo hijo
	screen_lives() # Muestra la cantidad de vidas
	
func inicia_player2():
	if multi_player: # si multi_player es true, se instancia la nave 2
		player2 = preload("res://player/player2.tscn").instantiate()
		player.position = Vector2(pantalla_ancho/2,0.3*pantalla_alto)  # Colocar al jugador2 en la parte //falta ajustar bien la posicion
		add_child(player2)  # Agrega el nodo hijo
	
func temporizador_agrega_enemigos():
	var enemy_aparece_timer = Timer.new()
	enemy_aparece_timer.wait_time = timer_aparece_enemigo
	enemy_aparece_timer.one_shot = false
	add_child(enemy_aparece_timer)
	enemy_aparece_timer.start()  # inicia el temporizador
	# Conectar el temporizador a una función que instancia a las naves enemigas
	enemy_aparece_timer.timeout.connect(_aparece_enemies)
	
func _aparece_enemies():
	var posicion_x = randf_range(100, pantalla_ancho-100) # Rando en X del aparicion del enemigo en el ancho d ela pantalla
	#boss_activo =0 inicia el Boss
	#boss_activo 1,2 o 3 , agrega diferentes enemigos con el boss
	
	# emite la señal cuando hubo un cambio de stage y lo envia a la pantalla
	emit_signal("stage_actual",stage)  
	# Nivel 1 - solo peones
	if stage_actual == 1 or boss_activo == 1:
		var enemy = preload("res://enemies/enemy.tscn").instantiate()
		enemy.position = Vector2(posicion_x, 0) # Ubica al enemigo en la X random e Y en el inicio
		add_child(enemy)  # Agrega como hijo del main al enemigo
		enemies.append(enemy)
	
	# nivel 2 - solo torres
	elif stage_actual == 2 or boss_activo == 2:
		var enemy = preload("res://enemies/enemy3.tscn").instantiate()
		enemy.position = Vector2(posicion_x, 0) # Ubica al enemigo en la X random e Y en el inicio
		add_child(enemy)  # Agrega como hijo del main al enemigo
		enemies.append(enemy)
		
	# Nivel 3 - Solo Alfiles
	elif stage_actual == 3 or boss_activo == 3:
		var enemy = preload("res://enemies/enemy2.tscn").instantiate()
		enemy.position = Vector2(posicion_x, 0) # Ubica al enemigo en la X random e Y en el inicio
		add_child(enemy)  # Agrega como hijo del main al enemigo
		enemies.append(enemy)
		
	# Nivel 4 - instancia al boos
	elif stage_actual == 4 and boss_activo == 0:  # solo una instancia sera posible, para que solo halla un BOSS
		var enemy_boss = preload("res://enemies/enemy4.tscn").instantiate()
		enemy_boss.position = Vector2(posicion_x, 80) # Ubica al enemigo en la X random e Y en el inicio
		add_child(enemy_boss)  # Agrega como hijo del main al enemigo
		enemies_boss.append(enemy_boss)
		boss_activo = 1  # Activa la aparicion del BOSS para que se generen aletorios los acompañantes
	
	# genera la opcion de enemigo que acompaña al boss  
	if stage_actual == 4 and boss_activo != 0:
		boss_activo = rand.randi_range(1, 3)  # Genera un número entre 1  y 3 (inclusive)
	
func temporizador_agrega_rocas():
	# Timer que marca los tiempos que se intancian las rocas
	var roca_aparece_timer = Timer.new()
	roca_aparece_timer.wait_time = timer_aparece_rocas
	roca_aparece_timer.one_shot = false
	add_child(roca_aparece_timer)
	roca_aparece_timer.start()
	roca_aparece_timer.timeout.connect(_aparece_roca)
	
func _aparece_roca():
	var roca = preload("res://enemies/roca.tscn").instantiate() #Instanciar
	# Posicionamiento en X aleatorio
	var posicion_x = randf_range(100, 0.95*pantalla_ancho) 
	roca.position = Vector2(posicion_x, 0)
	add_child(roca)  #Agrega nodo hijo
	rocas.append(roca) # Agrega a la lista de rocas
	
	# desaparecen las rocas que estan fuera de la pantalla
	for rocaD in rocas:
		
		#if : # Si existe el elemento
		if rocaD != null and rocaD.position.y > pantalla_alto:
			rocaD.queue_free() # Eliminarla del árbol de nodos
			rocas.erase(rocaD) # Eliminarla de la lista de rocas

func temporizador_mueve_enemigos(): #  temporizador para controlar el movimiento de las naves enemigas
	var enemy_timer = Timer.new()
	enemy_timer.wait_time = movimiento_enemigo
	enemy_timer.one_shot = false
	add_child(enemy_timer)
	enemy_timer.start()
	# Conectar el temporizador a una función que mueva a las naves enemigas
	enemy_timer.timeout.connect(_move_enemies)
	
func _move_enemies(): # Mueve todas las naves enemigas hacia abajo cada vez que se activa el temporizador
		
	calculo_score() # Calcula la cant enemigos eliminados por el player para obtener el Score
	
	calculo_rocas() # Calcula la cant  rocas eliminada para proveer un container premio
	
	calculo_container() # Verifica que el container se eleje de la pantalla y lo elimin
	
	planeta.move_down() # Mueve al planeta (solo es un efecto secundario efecto de fondo)
	
func calculo_score():
	
	var enemigos_eliminados = 0    # Actualiza el valor de la pantalla anterior
	# SCORE - Se basa en la cantidad de enemigos eliminados 10 puntos por cada uno
	for enemy in enemies:  # Repasa las instancias activas de los enemigos
		if enemy != null: # Si existe el elemento
			enemy.move_down()  # realiza el movimiento de la intancia segun su logica propia
			# Verificar si la nave ha salido de la pantalla (por la parte inferior)
			if enemy.position.y > 1.1*pantalla_alto: #110% 
				enemy.queue_free() # Eliminarla del árbol de nodos
				enemies.erase(enemy)# Eliminarla de la lista de enemigos
		else: # si fue eliminda por un laser del player
			enemigos_eliminados +=10  # suma 10 por cada enemigo eliminado
	enemigos_eliminados += score_stage
	
	for enemy_boss in enemies_boss:  # Repasa las instancias activas de los enemigos
		if enemy_boss != null: # Si existe el elemento
			enemy_boss.move_down()  # realiza el movimiento de la intancia segun su logica propia
			# Verificar si la nave ha salido de la pantalla (por la parte inferior)
			
		else: # si fue eliminda por un laser del player
			enemigos_eliminados += 200
			win_game(enemigos_eliminados)  # muere el boss se gana la partida
	
	
			
	if enemigos_eliminados != score:   # verifica el puntaje sea diferente al anterior
		score = enemigos_eliminados	  # guarda el valor del score actual
		emit_signal("score_total",score)  # emite la señal cuando hubo un cambio de score y lo envia a la pantalla
		Global.score = score 				
func calculo_rocas():
	# en cada nivel aumentara la cantidad de rocas para un contenedor, dependiendo de lo obtenido en el antrioir
	var rocas_eliminadas = 0    # Actualiza el valor de la pantalla anterior
	# SCORE - Se basa en la cantidad de enemigos eliminados 10 puntos por cada uno
	for rocasD in rocas:  # Repasa las instancias activas de los enemigos
		if rocasD == null: # Si existe el elemento
			rocas_eliminadas +=1  # cuenta la cantidad de rocas eliminadas por el player
			pass
	
	# Eliminar una cantidad de rocas obtiene un contenedor con premio
	if rocas_eliminadas == rocas_container:   # verifica el puntaje sea diferente al anterior
		_aparece_container()   # Instancia un container
		rocas_container = rocas_eliminadas + 5 # suma al doble la dificultad de obtener otro contenedor
		#emit_signal("score_total",score)  # emite la señal cuando hubo un cambio de score y lo envia a la pantalla
	pass
	
	if rocas_eliminadas_antes != (rocas_container - rocas_eliminadas):
		rocas_eliminadas_antes = rocas_container - rocas_eliminadas
		emit_signal("rocas_falta_container",rocas_eliminadas_antes)  # Cantidad de rocas que faltan y se indica en pantalla
	
func _aparece_container():
	var container = preload("res://awards/container.tscn").instantiate() #Instanciar
	# Posicionamiento en X aleatorio
	var posicion_x = randf_range(100, 0.9*pantalla_ancho) 
	container.position = Vector2(posicion_x, 0)
	add_child(container)  #Agrega nodo hijo
	containers.append(container) # Agrega a la lista de rocas
	pass
	
	
	
	# Niveles

func calculo_container():
	# desaparecen los containers que estan fuera de la pantalla
	for containerD in containers:
		 # Si existe el elemento
		if containerD != null and containerD.position.y > 0.97*pantalla_alto:
			containerD.queue_free() # Eliminar del árbol de nodos
			containers.erase(containerD) # Eliminar de la lista de containers
			
func _process(delta):
	
	control_score()  # Cambia de stage basado en el score
	
	cambio_stage()   # Limpia la pantalla si cambia el stage
	
	estado_lives()  # Verifica la cantidad de vidas
	
		
func control_score():
	if score != screen_score:	 # Si hay un cambio en los valores
		if score == 100 * multiplex: #multiplex es un multiplicador para multijugador
			stage_actual=2   # Cambio al nvel 2
			score_stage=score
		elif score == 200 * multiplex:
			stage_actual=3   # Cambio al nivel 3
			score_stage=score
		elif score == 300 * multiplex:
			stage_actual=4   # Cambio al nivel 4
			score_stage=score
		screen_score=score
	pass		

func cambio_stage():
	if stage_actual!=stage_anterior: # cambio de nivel
		emit_signal("stage",stage_actual) # Señal que cambia el finde de la pantalla
		musica_base.pitch_scale += 0.1   # aumenta la velocidad de la musica base de la partida
		
		# al Cambiar de nivel elimina todas las instancias de enemigos para limpiar la pantalla
		
		for i in range(rocas.size() - 1, -1, -1):  # Iterar en orden inverso
			var rocaD = rocas[i]
			if is_instance_valid(rocaD):  # Verifica si el enemigo aún es válido
				rocaD.queue_free()  # Elimina del árbol de nodos
				rocas.erase(rocaD)  # Elimina de la lista de enemigos
		rocas=[]
		for i in range(enemies.size() - 1, -1, -1):  # Iterar en orden inverso
			var enemy = enemies[i]
			if is_instance_valid(enemy):  # Verifica si el enemigo aún es válido
				enemy.queue_free()  # Elimina del árbol de nodos
				enemies.erase(enemy)  # Elimina de la lista de enemigos
		enemies=[]
		
		# Bandera de guarda stage 
		stage_anterior=stage_actual
	pass

func estado_lives():
	if player == null and Global.lives>0: # Si existe el elemento y tiene vidas
		Global.lives -=1 # le saca una vida
		screen_lives()
		inicia_player() # se vuelve a spanear
	elif player == null and Global.lives==0:  # Si existe y no tiene vida
		loss_game()
	
		
	# vidas del player2
	if multi_player:
		if player2 == null and Global.lives>0: # Si existe el elemento
			Global.lives -=1
			inicia_player2()
		elif player2 == null and  Global.lives == 0:
			loss_game()
		
	
	# verifica si cambio la cantidad de vidas a mostrar
	if Global.lives != screen_live:
		screen_lives()	#muestra y actualiza

func win_game(enemigos_eliminados):
	get_tree().change_scene_to_file("res://menu/loss_win/win.tscn")
	emit_signal("win")
	pass
	
func loss_game(): # al hacer click en el boton de JUGAR empieza el juego en el nivel 1
	get_tree().change_scene_to_file("res://menu/loss_win/loss.tscn")
	emit_signal("loss")
	
	
	pass
			
func musica_juego():
	$musica_base.play()

func screen_lives():
	emit_signal("live",Global.lives) # Muestra la cantidad de vidas
	screen_live=Global.lives  # actualiza lo que esta mostrando en pantalla
	pass

##### REINICIO del juego desde el menu principal
	
func reset_game():
	get_tree().reload_current_scene() #resetea la escena principal y sus hijos
	GlobalSettings.respawn = false
	Global.lives = 3
	pass

# se toca el boton restart
func _on_button_restart_pressed() -> void:
	get_tree().paused = false
	reset_game()
