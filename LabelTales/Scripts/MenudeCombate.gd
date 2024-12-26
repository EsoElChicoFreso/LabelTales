extends Control

# Referencias a los botones en MenudeCombate/Botones
onready var mazmorra = $Botones/Mazmorra
onready var inventario = $Botones/Inventario
onready var habilidades = $Botones/Habilidades
onready var talentos = $Botones/Talentos
onready var opciones = $Botones/Opciones
onready var salir = $Botones/Salir

# Referencias a las pantallas principales usando rutas absolutas
onready var mazmorra_menu = get_node("/root/Principal/MenudeCombate/MazmorraMenu2")
onready var inventario_menu = get_node("/root/Principal/MenudeCombate/InventarioMenu")
onready var habilidades_menu = get_node("/root/Principal/MenudeCombate/HabilidadesMenu")
onready var talentos_menu = get_node("/root/Principal/MenudeCombate/TalentosMenu")
onready var opciones_menu = get_node("/root/Principal/MenudeCombate/OpcionesMenu")
onready var vida_texto = get_node("/root/Principal/MenudeCombate/MazmorraMenu2/Barras/Vida/VidaTexto")
onready var vida_enemigo_texto = get_node("/root/Principal/MenudeCombate/MazmorraMenu2/Barras/VidaEnemigo/VidaEnemigoTexto")
onready var mana_texto = get_node("/root/Principal/MenudeCombate/MazmorraMenu2/Barras/ManaResis/ManaTexto")
onready var tween = get_node("/root/Principal/Tween")

func _ready():
	# Conectar señales de los botones
	mazmorra.connect("pressed", self, "_on_mazmorra_pressed")
	inventario.connect("pressed", self, "_on_inventario_pressed")
	habilidades.connect("pressed", self, "_on_habilidades_pressed")
	talentos.connect("pressed", self, "_on_talentos_pressed")
	opciones.connect("pressed", self, "_on_opciones_pressed")
	salir.connect("pressed", self, "_on_salir_pressed")
	randomize()

	
		# Asegurarse de que el menú de combate esté visible
	combate_menu.visible = true
	# Inicializar las barras de vida y maná
	barra_vida.max_value = vida_max
	barra_vida.value = vida_actual
	barra_mana.max_value = mana_max
	barra_mana.value = mana_actual
	barra_vida_enemigo.max_value = vida_enemigo_max
	barra_vida_enemigo.value = vida_enemigo
		# Inicializar habilidades
	_crear_habilidades()

	# Inicializar objetos
	_crear_objetos()



	# Ocultar todas las pantallas excepto Mazmorra al inicio
	_mostrar_pantalla("Mazmorra")

# Función para mostrar una pantalla específica
func _mostrar_pantalla(nombre):
	# Ocultar todas las pantallas
	mazmorra_menu.visible = false
	inventario_menu.visible = false
	habilidades_menu.visible = false
	talentos_menu.visible = false
	opciones_menu.visible = false

	# Mostrar la pantalla correspondiente
	match nombre:
		"Mazmorra":
			mazmorra_menu.visible = true
		"Inventario":
			inventario_menu.visible = true
		"Habilidades":
			habilidades_menu.visible = true
		"Talentos":
			talentos_menu.visible = true
		"Opciones":
			opciones_menu.visible = true

# Funciones conectadas a los botones
func _on_mazmorra_pressed():
	_mostrar_pantalla("Mazmorra")

func _on_inventario_pressed():
	_mostrar_pantalla("Inventario")

func _on_habilidades_pressed():
	_mostrar_pantalla("Habilidades")

func _on_talentos_pressed():
	_mostrar_pantalla("Talentos")

func _on_opciones_pressed():
	_mostrar_pantalla("Opciones")

func _on_salir_pressed():
	_cambiar_a_menu_principal()

# Función para cambiar a la escena principal
func _cambiar_a_menu_principal():
	get_tree().change_scene("res://Escenas/MainMenu.tscn")

# Referencias a los nodos
onready var combate_menu = get_node("/root/Principal/MenudeCombate/MazmorraMenu2")
onready var enemigo_imagen = get_node("/root/Principal/MenudeCombate/MazmorraMenu2/Enemigo")
onready var barra_vida = get_node("/root/Principal/MenudeCombate/MazmorraMenu2/Barras/Vida")
onready var barra_mana = get_node("/root/Principal/MenudeCombate/MazmorraMenu2/Barras/ManaResis")
onready var barra_vida_enemigo = get_node("/root/Principal/MenudeCombate/MazmorraMenu2/Barras/VidaEnemigo")
onready var habilidades_container = get_node("/root/Principal/MenudeCombate/MazmorraMenu2/Habilidades")
onready var objetos_container = get_node("/root/Principal/MenudeCombate/MazmorraMenu2/Objetos")
onready var log_combate = get_node("/root/Principal/MenudeCombate/MazmorraMenu2/LogCombate")

# Variables del jugador y enemigo
var vida_actual = 100
var vida_max = 100
var mana_actual = 100
var mana_max = 100
var vida_enemigo = 150
var vida_enemigo_max = 150
var oro = 0
var damage = 0


func _actualizar_barras():
	barra_vida.value = vida_actual
	barra_mana.value = mana_actual
	barra_vida_enemigo.value = vida_enemigo
	_actualizar_textos()

# Actualizar los textos de las barras de vida
	_actualizar_textos()  # Actualiza los textos al inicio

func _actualizar_textos():
	vida_texto.text = "%d / %d" % [vida_actual, vida_max]
	vida_enemigo_texto.text = "%d / %d" % [vida_enemigo, vida_enemigo_max]
	mana_texto.text = "%d / %d" % [mana_actual, mana_max]
	
# Función para crear habilidades
func _crear_habilidades():
	var habilidad1 = Button.new()
	habilidad1.text = "Habilidad 1"
	habilidad1.connect("pressed", self, "_on_habilidad1_pressed")
	habilidades_container.add_child(habilidad1)

	var habilidad2 = Button.new()
	habilidad2.text = "Habilidad 2"
	habilidad2.connect("pressed", self, "_on_habilidad2_pressed")
	habilidades_container.add_child(habilidad2)

	var habilidad3 = Button.new()
	habilidad3.text = "Habilidad 3"
	habilidad3.connect("pressed", self, "_on_habilidad3_pressed")
	habilidades_container.add_child(habilidad3)

# Funciones para usar las habilidades
# Función para usar Habilidad 1
func _on_habilidad1_pressed():
	if mana_actual >= 10 and vida_actual > 0 and vida_enemigo > 0:
		var nuevo_valor_vida = max(vida_enemigo - 20, 0)
		mana_actual -= 10
	

		# Animar la barra de vida del enemigo
		tween.interpolate_property(
			barra_vida_enemigo, "value",
			barra_vida_enemigo.value, nuevo_valor_vida,
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()

		# Animar el texto de vida del enemigo
		tween.interpolate_method(
			self, "_actualizar_texto_vida_enemigo",
			vida_enemigo, nuevo_valor_vida,
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()

		vida_enemigo = nuevo_valor_vida  # Actualizar el valor lógico
		log_combate.append_bbcode("[color=blue]Usaste Habilidad 1 e hiciste 20 de daño al enemigo.[/color]\n")
		_verificar_vida_enemigo()
		_actualizar_mana_con_animacion(mana_actual - 10)  # Resta 10 de maná
		_actualizar_barras()
		if vida_enemigo > 0:
			_enemigo_ataca()  # El enemigo ataca después de la habilidad
	else:
		if mana_actual < 10:
			log_combate.append_bbcode("[color=red]No tienes suficiente maná para usar Habilidad 1.[/color]\n")
		elif vida_actual <= 0:
			log_combate.append_bbcode("[color=red]No puedes atacar porque estás muerto.[/color]\n")
		elif vida_enemigo <= 0:
			log_combate.append_bbcode("[color=red]El enemigo ya está derrotado.[/color]\n")


func _on_habilidad2_pressed():
	if mana_actual >= 15 and vida_actual > 0 and vida_enemigo > 0:
		var nuevo_valor_vida = max(vida_enemigo - 30, 0)
		mana_actual -= 15

		# Animar la barra de vida del enemigo
		tween.interpolate_property(
			barra_vida_enemigo, "value",
			barra_vida_enemigo.value, nuevo_valor_vida,
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()

		# Animar el texto de vida del enemigo
		tween.interpolate_method(
			self, "_actualizar_texto_vida_enemigo",
			vida_enemigo, nuevo_valor_vida,
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()

		vida_enemigo = nuevo_valor_vida  # Actualizar el valor lógico
		log_combate.append_bbcode("[color=blue]Usaste Habilidad 2 e hiciste 30 de daño al enemigo.[/color]\n")
		_verificar_vida_enemigo()
		_actualizar_mana_con_animacion(mana_actual - 15)  # Resta 10 de maná
		_actualizar_barras()
		if vida_enemigo > 0:
			_enemigo_ataca()  # El enemigo ataca después de la habilidad
	else:
		if mana_actual < 15:
			log_combate.append_bbcode("[color=red]No tienes suficiente maná para usar Habilidad 2.[/color]\n")
		elif vida_actual <= 0:
			log_combate.append_bbcode("[color=red]No puedes atacar porque estás muerto.[/color]\n")
		elif vida_enemigo <= 0:
			log_combate.append_bbcode("[color=red]El enemigo ya está derrotado.[/color]\n")

		
func _on_habilidad3_pressed():
	if mana_actual >= 20 and vida_actual > 0 and vida_enemigo > 0:
		var nuevo_valor_vida = max(vida_enemigo - 30, 0)
		mana_actual -= 20

		# Animar la barra de vida del enemigo
		tween.interpolate_property(
			barra_vida_enemigo, "value",
			barra_vida_enemigo.value, nuevo_valor_vida,
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()

		# Animar el texto de vida del enemigo
		tween.interpolate_method(
			self, "_actualizar_texto_vida_enemigo",
			vida_enemigo, nuevo_valor_vida,
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()

		vida_enemigo = nuevo_valor_vida  # Actualizar el valor lógico
		log_combate.append_bbcode("[color=blue]Usaste Habilidad 3 e hiciste 30 de daño al enemigo.[/color]\n")
		_verificar_vida_enemigo()
		_actualizar_mana_con_animacion(mana_actual - 20)  # Resta 10 de maná
		_actualizar_barras()
		if vida_enemigo > 0:
			_enemigo_ataca()  # El enemigo ataca después de la habilidad
	else:
		if mana_actual < 15:
			log_combate.append_bbcode("[color=red]No tienes suficiente maná para usar Habilidad 3.[/color]\n")
		elif vida_actual <= 0:
			log_combate.append_bbcode("[color=red]No puedes atacar porque estás muerto.[/color]\n")
		elif vida_enemigo <= 0:
			log_combate.append_bbcode("[color=red]El enemigo ya está derrotado.[/color]\n")

		
		
# Función para crear objetos
func _crear_objetos():
	var objeto1 = Button.new()
	objeto1.text = "Poción de Vida"
	objeto1.connect("pressed", self, "_on_objeto1_pressed")
	objetos_container.add_child(objeto1)

	var objeto2 = Button.new()
	objeto2.text = "Poción de Maná"
	objeto2.connect("pressed", self, "_on_objeto2_pressed")
	objetos_container.add_child(objeto2)

# Funciones para usar los objetos
func _on_objeto1_pressed():
	if vida_actual > 0:
		vida_actual = min(vida_actual + 30, vida_max)
		log_combate.append_bbcode("[color=green]Usaste una Poción de Vida y recuperaste 30 puntos de vida.[/color]\n")
		_actualizar_barras()
	else:
		log_combate.append_bbcode("[color=red]No puedes usar pociones estando muerto.[/color]\n")
	if vida_actual <= 0:
		log_combate.append_bbcode("[color=red]No puedes usar objetos, estás muerto.[/color]\n")
		return
		
func _on_objeto2_pressed():
	if vida_actual > 0:
		mana_actual = min(mana_actual + 20, mana_max)
		log_combate.append_bbcode("[color=green]Usaste una Poción de Maná y recuperaste 20 puntos de maná.[/color]\n")
		_actualizar_barras()
	else:
		log_combate.append_bbcode("[color=red]No puedes usar pociones estando muerto.[/color]\n")
	if vida_actual <= 0:
		log_combate.append_bbcode("[color=red]No puedes usar objetos, estás muerto.[/color]\n")
		return

# Verificar la vida del enemigo y manejar su muerte
func _verificar_vida_enemigo():
	if vida_enemigo <= 0:
		vida_enemigo = 0
		log_combate.append_bbcode("[color=green]¡Has derrotado al enemigo![/color]\n")
		_recompensa_tras_victoria()
		enemigo_imagen.visible = false  # Ocultar la imagen del enemigo al morir


# Función para que el enemigo ataque
func _enemigo_ataca():
	var damage = randi() % 20 + 15  # Genera un número aleatorio entre 15 y 35
	var nueva_vida = max(vida_actual - damage, 0)

	# Animar la barra de vida del jugador
	tween.interpolate_property(
		barra_vida, "value",
		barra_vida.value, nueva_vida,
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()

	# Animar el texto de vida del jugador
	tween.interpolate_method(
		self, "_actualizar_texto_vida",
		vida_actual, nueva_vida,
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()

	vida_actual = nueva_vida  # Actualizar el valor lógico
	log_combate.append_bbcode("[color=red]El enemigo te atacó e hizo %d de daño.[/color]\n" % damage)

	# Verificar si el jugador ha sido derrotado
	_verificar_vida_jugador()
	
func _actualizar_mana_con_animacion(nuevo_mana):
	# Asegurarse de que `nuevo_mana` esté dentro de los límites correctos
	nuevo_mana = clamp(nuevo_mana, 0, mana_max)

	# Animar la barra de maná
	tween.stop_all()  # Detener cualquier animación previa en el tween
	tween.interpolate_property(
		barra_mana, "value",
		barra_mana.value, nuevo_mana,
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()

	# Animar el texto de maná
	tween.interpolate_method(
		self, "_actualizar_texto_mana",
		mana_actual, nuevo_mana,
		0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()

	# Actualizar el valor lógico del maná después de la animación
	mana_actual = nuevo_mana

	
# Verificar si el jugador ha sido derrotado
func _verificar_vida_jugador():
	if vida_actual <= 0:
		vida_actual = 0
		log_combate.append_bbcode("[color=red]¡Has sido derrotado![/color]\n")

	# Función para recompensas tras victoria
func _recompensa_tras_victoria():
	var recompensa_oro = randi() % 41 + 10  # Genera un número aleatorio entre 10 y 50
	oro += recompensa_oro
	log_combate.append_bbcode("[color=yellow]¡Has ganado %d de oro![/color]\n" % recompensa_oro)
	
	#Funciones para animaciones de barras y números
func _actualizar_texto_vida_enemigo(valor):
	vida_enemigo_texto.text = "%d / %d" % [round(valor), vida_enemigo_max]

func _actualizar_texto_mana(valor_actual):
	mana_texto.text = "%d / %d" % [valor_actual, mana_max]

func _actualizar_texto_vida(valor_actual):
	vida_texto.text = "%d / %d" % [valor_actual, vida_max]
	
