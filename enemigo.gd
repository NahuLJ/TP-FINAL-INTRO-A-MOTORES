extends CharacterBody2D

var jugador = null
var rayCast

func _ready():
	rayCast = $RayCast2D
	#get parent lo que hace es buscar el nodo entre sus hermanos, es decir entre los nodos que son de su misma jerarquia
	jugador = get_parent().get_node("Personaje") 
	#si hay un jugador, es decir la var jugador es diferente de null, hace un print diciendo que hay un jugador
	if jugador:
		print("Hay un jugador")

func _process(delta):
	voltear()
	golpear()

func voltear():
	if jugador:
		if jugador.global_position.x < global_position.x:
			scale.x = -1  # Voltear hacia la izquierda
		else:
			scale.x = 1   # Voltear hacia la derecha

func golpear():
	var colision = rayCast.get_collider()
	if rayCast.is_colliding():
		print("El esqueleto esta colisionando con: ", colision)
		$AnimatedSprite2D.play("attack")
