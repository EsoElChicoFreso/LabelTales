extends Node2D

# Declaración de variables para nodos
var mazmorra
var inventario
var estadisticas
var salir

var panel_mazmorra
var panel_inventario
var panel_estadisticas

var sprite_enemigo
var patada
var corte
var embestida
var vida_jugador
var energia_jugador
var vida_enemigo
var log_combate

# Nuevas variables de texto para mostrar la vida y energía
var vida_jugador_texto
var energia_jugador_texto
var vida_enemigo_texto

# Valores iniciales
var vida_jugador_valor = 100
var energia_jugador_valor = 100
var vida_enemigo_valor = 150
var enemigo_danio_min = 20
var enemigo_danio_max = 30

func _ready():
	# Asignación de nodos para botones
	mazmorra = get_node("Botones/VBoxContainer/ButtonMazmorra")
	inventario = get_node("Botones/VBoxContainer/ButtonInventario")
	estadisticas = get_node("Botones/VBoxContainer/ButtonEstadisticas")
	salir = get_node("Botones/VBoxContainer/ButtonSalir")

	# Asignación de nodos para paneles
	panel_mazmorra = get_node("MenudeCombate/PanelMazmorra")
	panel_inventario = get_node("MenudeCombate/PanelInventario")
	panel_estadisticas = get_node("MenudeCombate/PanelEstadisticas")

	# Asignación de nodos de estadísticas
	vida_jugador = get_node("MenudeCombate/PanelMazmorra/Jugador/VidaJugador")
	energia_jugador = get_node("MenudeCombate/PanelMazmorra/Jugador/EnergiaJugador")
	vida_enemigo = get_node("MenudeCombate/PanelMazmorra/Enemigo/VidaEnemigo")
	log_combate = get_node("LogCombate")

	# Asignación de textos de estadísticas
	vida_jugador_texto = get_node("MenudeCombate/PanelMazmorra/Jugador/VidaJugadorTexto")
	energia_jugador_texto = get_node("MenudeCombate/PanelMazmorra/Jugador/EnergiaJugadorTexto")
	vida_enemigo_texto = get_node("MenudeCombate/PanelMazmorra/Enemigo/VidaEnemigoTexto")

	# Asignación de habilidades
	patada = get_node("MenudeCombate/PanelMazmorra/Jugador/BotonesHabilidades/Patada")
	corte = get_node("MenudeCombate/PanelMazmorra/Jugador/BotonesHabilidades/Corte")
	embestida = get_node("MenudeCombate/PanelMazmorra/Jugador/BotonesHabilidades/Embestida")

	# Conectar las señales de los botones
	mazmorra.pressed.connect(_on_mazmorra_pressed)
	inventario.pressed.connect(_on_inventario_pressed)
	estadisticas.pressed.connect(_on_estadisticas_pressed)
	salir.pressed.connect(_on_salir_pressed)

	patada.pressed.connect(_on_patada_pressed)
	corte.pressed.connect(_on_corte_pressed)
	embestida.pressed.connect(_on_embestida_pressed)

	# Configuración inicial
	configurar_barras()
	log_combate.text = "¡Comienza la batalla!"

func configurar_barras():
	# Configurar valores de las barras
	vida_jugador.max_value = vida_jugador_valor
	energia_jugador.max_value = energia_jugador_valor
	vida_enemigo.max_value = vida_enemigo_valor

	actualizar_textos()

func actualizar_textos():
	# Actualizar valores de las barras
	vida_jugador.value = vida_jugador_valor
	energia_jugador.value = energia_jugador_valor
	vida_enemigo.value = vida_enemigo_valor

	# Actualizar textos de estadísticas
	vida_jugador_texto.text = "Vida: %d/%d" % [vida_jugador_valor, vida_jugador.max_value]
	energia_jugador_texto.text = "Energía: %d/%d" % [energia_jugador_valor, energia_jugador.max_value]
	vida_enemigo_texto.text = "Vida: %d/%d" % [vida_enemigo_valor, vida_enemigo.max_value]

func _on_mazmorra_pressed():
	_mostrar_panel("Mazmorra")

func _on_inventario_pressed():
	_mostrar_panel("Inventario")

func _on_estadisticas_pressed():
	_mostrar_panel("Estadisticas")

func _on_salir_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _mostrar_panel(nombre_panel):
	panel_mazmorra.visible = false
	panel_inventario.visible = false
	panel_estadisticas.visible = false

	match nombre_panel:
		"Mazmorra":
			panel_mazmorra.visible = true
		"Inventario":
			panel_inventario.visible = true
		"Estadisticas":
			panel_estadisticas.visible = true

func _on_patada_pressed():
	usar_habilidad("Patada", 10, 20)

func _on_corte_pressed():
	usar_habilidad("Corte", 20, 30)

func _on_embestida_pressed():
	usar_habilidad("Embestida", 30, 40)

func usar_habilidad(nombre: String, costo_energia: int, danio: int):
	if energia_jugador_valor >= costo_energia:
		energia_jugador_valor -= costo_energia
		vida_enemigo_valor = max(0, vida_enemigo_valor - danio)
		_actualizar_log("Usaste %s y causaste %d de daño al enemigo." % [nombre, danio])
		actualizar_textos()

		if vida_enemigo_valor <= 0:
			_actualizar_log("¡El enemigo ha sido derrotado!")
			_desactivar_habilidades()
		else:
			_atacar_jugador()
	else:
		_actualizar_log("No tienes suficiente energía para usar %s." % nombre)

func _atacar_jugador():
	var danio_enemigo = randi_range(enemigo_danio_min, enemigo_danio_max)
	vida_jugador_valor = max(0, vida_jugador_valor - danio_enemigo)
	_actualizar_log("El enemigo te atacó e hizo %d de daño." % danio_enemigo)
	actualizar_textos()

	if vida_jugador_valor <= 0:
		_actualizar_log("¡Has sido derrotado!")
		_desactivar_habilidades()

func _actualizar_log(texto):
	var lineas = log_combate.text.split("\n")
	lineas.append(texto)
	if lineas.size() > 5:
		lineas = lineas.slice(lineas.size() - 5, lineas.size())
	log_combate.text = "\n".join(lineas)

func _desactivar_habilidades():
	patada.disabled = true
	corte.disabled = true
	embestida.disabled = true
