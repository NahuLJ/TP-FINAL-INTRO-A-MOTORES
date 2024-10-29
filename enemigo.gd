extends CharacterBody2D
#variables para guardar los nodos
var jugador = null
var rayCast
var recorrido

#variables para movimiento
var velocidad_movimiento = 70
var direccion = 1
const gravity = 980

#posicion inicial, para que no se cambie al iniciar la escena y comenzar a patrullar
var posicion_inicial 

#variables de control
var esta_caminando_a_derecha = true
var esta_atacando = false


var vidas = 3

func _ready():
	rayCast = $RayCast2D
	recorrido = get_node("Camino/Patrullaje")
	jugador = get_parent().get_node("Personaje") 
	posicion_inicial = position
	if jugador:
		print("Hay un jugador")

func _process(delta):
	animaciones()
	patrullar(delta)
	voltear()
	golpear()
	recibir_danio()


func voltear():
	if esta_caminando_a_derecha:
		scale.x = 1  # Voltear hacia la izquierda
	else:
		scale.x = -1   # Voltear hacia la derecha


func animaciones():
	if esta_atacando:
		$AnimatedSprite2D.play("attack")
	else:
		$AnimatedSprite2D.play("walk")


func golpear():
	var colision = rayCast.get_collider()
	if rayCast.is_colliding() and not esta_atacando:
		print("El esqueleto esta colisionando con: ", colision)
		esta_atacando = true 
		velocity.x = 0
		await get_tree().create_timer(1).timeout
		esta_atacando = false


func patrullar(delta):
	if not rayCast.is_colliding():
		recorrido.progress += delta * velocidad_movimiento * direccion
		if recorrido.progress_ratio == 0 or recorrido.progress_ratio == 1:
			direccion *= -1
			esta_caminando_a_derecha = not esta_caminando_a_derecha
		position = posicion_inicial + recorrido.position

func recibir_danio():
	vidas -= 1
	
	if vidas <= 0:
		await get_tree().create_timer(3).timeout
		queue_free()
