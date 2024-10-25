extends CharacterBody2D

var jugador = null

func _ready():
	var jugador = get_tree().get_nodes_in_group("Personaje")
	
	if jugador.size() > 0:
		jugador = jugador[0]
		print("Jugador encontrado:", jugador.name)
	else:
		print("No se encontró ningún jugador en el grupo.")
