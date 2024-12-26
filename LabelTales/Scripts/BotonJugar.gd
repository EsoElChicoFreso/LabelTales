extends Control

# Referencia a los botones
onready var jugar = $Jugar
onready var salir = $Salir  # Nuevo botón de Salir

func _ready():
	# Conectar la señal del botón Jugar
	jugar.connect("pressed", self, "_on_jugar_pressed")
	# Conectar la señal del botón Salir
	salir.connect("pressed", self, "_on_salir_pressed")

# Función para cambiar a la escena MenuCombate
func _on_jugar_pressed():
	get_tree().change_scene("res://Escenas/MenuCombate.tscn")

# Función para salir del juego
func _on_salir_pressed():
	get_tree().quit()
