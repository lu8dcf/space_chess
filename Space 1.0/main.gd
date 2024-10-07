extends Node2D

#tamaño de pantalla
var pantalla_ancho = 1280
var pantalla_alto = 720
var rand = RandomNumberGenerator.new() # semilla de random segun el tiempo

# Enemigos
var enemies = []  # Almacenará las instancias de enemigos
var movimiento_enemigo = 0.05  # Intervalo de tiempo para el movimiento enemigo
var timer_aparece_enemigo = .5 # 1seg Intervalo que aparecen los enemigos
var boss_activo=0 # Bandera para Agregar secuaces al BOSS

# Rocas
var rocas = [] # Almacena las instancias de las rocas
var timer_aparece_rocas = .5 # 1 seg Intervalo que aparecen los enemigos

# Fondo
var planetas = [] # planetas del fondo
var planeta = null
var planeta_x = 0.3 * pantalla_ancho # ubicacion inicial del planeta en ele eje x

# Player
var player = null
var vidas = 8   # cantidad de vidas

# Player2
var player2 = null
var vidas2 = 8 # cantidad de vidas
var multi_player = GlobalSettings.game_multiplayer

# Puntos del juego
var score = 0 # Puntos de referencia 
var stage_actual = 1
signal score_total
signal stage # Indicador de Stage actual
signal perdiste
var stage_anterior = 0 #Inicio de la partida

func _ready():	
		
	inicia_planeta(planeta_x) # Instanciar planeta del fondo con movimiento
		
	inicia_player() # # Instanciar y añadir la nave del jugador en el punto central abajo
	
	if multi_player: # si multi_player es true, se instancia la nave 2
		inicia_player2()
		pass
	
	temporizador_agrega_enemigos() # Timer que marca los tiempos que se instancian los enemigos
		
	temporizador_agrega_rocas() #Timer que marca los tiempos que se intancian las rocas
	
	temporizador_mueve_enemigos() # Timer para controlar el movimiento de las naves enemigas
	
	musica_juego()	


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
	planeta = preload("res://planeta.tscn").instantiate()
	planeta.position = Vector2(planeta_x,0)  # Colocar al planeta en la parte superioir fuera a un cuato de X
	add_child(planeta)  # Agrega el nodo hijo
	
func inicia_player():
	player = preload("res://player.tscn").instantiate()
	player.position = Vector2(pantalla_ancho/2,0.9*pantalla_alto)  # Colocar al jugador en la parte inferior al centro
	add_child(player)  # Agrega el nodo hijo
	
func inicia_player2():
	player2 = preload("res://player2.tscn").instantiate()
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
		var enemy = preload("res://enemy.tscn").instantiate()
		enemy.position = Vector2(posicion_x, 0) # Ubica al enemigo en la X random e Y en el inicio
		add_child(enemy)  # Agrega como hijo del main al enemigo
		enemies.append(enemy)
	
	# nivel 2 - solo torres
	elif stage_actual == 2 or boss_activo == 2:
		var enemy = preload("res://enemy2.tscn").instantiate()
		enemy.position = Vector2(posicion_x, 0) # Ubica al enemigo en la X random e Y en el inicio
		add_child(enemy)  # Agrega como hijo del main al enemigo
		enemies.append(enemy)
		
	# Nivel 3 - Solo Alfiles
	elif stage_actual == 3 or boss_activo == 3:
		var enemy = preload("res://enemy3.tscn").instantiate()
		enemy.position = Vector2(posicion_x, 0) # Ubica al enemigo en la X random e Y en el inicio
		add_child(enemy)  # Agrega como hijo del main al enemigo
		enemies.append(enemy)
		
	# Nivel 4 - instancia al boos
	elif stage_actual == 4 and boss_activo == 0:  # solo una instancia sera posible, para que solo halla un BOSS
		var enemy = preload("res://enemy4.tscn").instantiate()
		enemy.position = Vector2(posicion_x, 80) # Ubica al enemigo en la X random e Y en el inicio
		add_child(enemy)  # Agrega como hijo del main al enemigo
		enemies.append(enemy)
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
	var roca = preload("res://roca.tscn").instantiate() #Instanciar
	# Posicionamiento en X aleatorio
	var posicion_x = randf_range(0, pantalla_ancho) 
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
	var enemigos_eliminados = 0    # Actualiza el valor de la pantalla anterior
	for enemy in enemies:
		if enemy != null: # Si existe el elemento
		
			enemy.move_down()
			# Verificar si la nave ha salido de la pantalla (por la parte inferior)
			if enemy.position.y > 1.1*pantalla_alto: #110% 
				# Eliminarla del árbol de nodos
				enemy.queue_free()
				# Eliminarla de la lista de enemigos
				enemies.erase(enemy)
		else:
			enemigos_eliminados +=10  # suma 10 por cada enmigo eliminado
			
	if enemigos_eliminados != score:   # verifica el puntaje sea diferente al anterior
		score = enemigos_eliminados	
		
		# emite la señal cuando hubo un cambio de score y lo envia a la pantalla
		emit_signal("score_total",score)  
				
	# efecto de fondo, determinara el tiempo de la pantalla
	planeta.move_down() # Mueve al planeta
		
	
	# Niveles
func _process(delta):
	if multi_player:
		if score == 200:
			stage_actual=2   # Cambio al nvel 2
		elif score == 400:
			stage_actual=3   # Cambio al nivel 3
		elif score == 600:
			stage_actual=4   # Cambio al nivel 4		
	else:
		if score == 100:
			stage_actual=2   # Cambio al nvel 2
		elif score == 200:
			stage_actual=3   # Cambio al nivel 3
		elif score == 300:
			stage_actual=4   # Cambio al nivel 4
			
	# cambio de nivel
	if stage_actual!=stage_anterior:
		emit_signal("stage",stage_actual) # Señal que cambia el finde de la pantalla
		
		# al Cambiar de nivel elimina todas las instancias de enemigos
		
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
			
		stage_anterior=stage_actual
	
	if player == null and vidas>0: # Si existe el elemento
		vidas -=1
		inicia_player()
	elif player == null and vidas==0:
		perdiste_juego()
	else:
		pass
		
	# vidas del player2
	if multi_player:
		if player2 == null and vidas2>0: # Si existe el elemento
			vidas2 -=1
			inicia_player2()
		elif player2 == null and vidas2==0 and vidas == 0:
			perdiste_juego()
		else:
			pass
			
		
func perdiste_juego():
	emit_signal("perdiste")
	pass
			
func musica_juego():
	$musica_base.play()
