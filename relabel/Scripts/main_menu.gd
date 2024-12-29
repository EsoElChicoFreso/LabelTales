extends Node2D

# Variable para el botón Jugar
var button_jugar

func _ready():
	# Asignación de nodos
	button_jugar = get_node("ButtonJugar")
	
	# Conectar la señal 'pressed' del botón Jugar a la función _on_button_jugar_pressed
	button_jugar.pressed.connect(self._on_button_jugar_pressed)

# Función que se ejecuta cuando se presiona el botón Jugar
func _on_button_jugar_pressed():
	# Cambiar a la escena principal usando el nuevo método
	get_tree().change_scene_to_file("res://Scenes/MainScene.tscn")
