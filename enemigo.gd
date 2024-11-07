extends CharacterBody2D
signal golpe_realizado
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
var animPlayer
var vidas = 3
var ha_hecho_danio = false

func _ready():
	rayCast = $RayCast2D
	recorrido = get_node("Camino/Patrullaje")
	jugador = get_parent().get_node("Personaje") 
	posicion_inicial = position
	if jugador:
		print("Hay un jugador")
	animPlayer = $AnimatedSprite2D
	
	# Conectamos la señal 'frame_changed' del AnimatedSprite2D
	if animPlayer:
		animPlayer.connect("frame_changed", self, "_on_frame_changed")
	
	

func _process(delta):
	animaciones()
	patrullar(delta)
	golpear()
	#recibir_danio()
	
	if animPlayer.get_animation() != "attack":
		ha_hecho_danio = false 
		
	
	

# Definir una señal personalizada para el golpe
func _on_frame_changed():
	if animPlayer.animation == "attack":
		var current_frame = animPlayer.frame

# Verificamos si el frame está en el rango donde el esqueleto hace daño
		if current_frame >= 5 and current_frame <= 10 and not ha_hecho_danio:
			ha_hecho_danio = true
			emitir_golpe()  # Emitimos nuestra señal personalizada en el frame adecuado

		# Restablecer la variable después de la animación
		if current_frame == animPlayer.frames.get_frame_count("attack") - 1:
			ha_hecho_danio = false
			# Emitir la señal personalizada
func emitir_golpe():
	emit_signal("golpe_realizado")  # Emite la señal personalizada 'golpe_realizado'


func voltear():
	scale.x *= -1


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
			voltear()
			esta_caminando_a_derecha = not esta_caminando_a_derecha
		position = posicion_inicial + recorrido.position

func recibir_danio():
	vidas -= 1
	print("La vida del enemgio es de: ", vidas)
	if vidas <= 0:
		await get_tree().create_timer(3).timeout
		queue_free()



 
