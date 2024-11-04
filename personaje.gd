extends CharacterBody2D
#Constantes de velocidad y gravedad
const velocidad_Movimiento = 150
const velocidad_Salto = 300
const velocidad_Slide = 200 # velocidad del slide 
const gravity = 980

#Variables para controlar
var esta_mirando_derecha = true
var esta_deslizando = false #Variable para controlar el deslizamiento 
var esta_atacando = false 
var vidas = 3
var enemigo = null
var rayCast
var ha_hecho_danio = false 

func _ready(): 
	enemigo = get_parent().get_node("Enemigo")
	rayCast = $RayCast2D 	 

func _process(delta): 
	movimiento()
	move_and_slide()
	fisicas(delta)
	animaciones()
	deslizar()
	actualizar_giro()
	atacar()
	hacer_danio_enemigo()
	if esta_atacando:
		ha_hecho_danio = false 

func animaciones():
	
	if vidas <= 0:
		$AnimatedSprite2D.play("die")
		await get_tree().create_timer(1).timeout
		queue_free()

	if esta_atacando:
		$AnimatedSprite2D.play("attack")
		#print("El personaje esta atacando")
		return 
		
	#Deslizarse
	if esta_deslizando:
		$AnimatedSprite2D.play("Slide")
		#print("El personaje esta deslizandose")
		return #Salir de la funcion para evitar que se reproduzcan otras animaciones
	
	#Saltar y Caer
	if(not is_on_floor()):
		if(velocity.y < 0):
			$AnimatedSprite2D.play("Jump")
			#print("El personaje esta saltando")
		else:
			$AnimatedSprite2D.play("Fall")
			#print("El personaje esta cayendo")
		return
	
	#Correr y Estar Quieto
	if (velocity.x != 0):
		$AnimatedSprite2D.play("Run")
		#print("El personaje esta corriendo")
	else:
		$AnimatedSprite2D.play("Idle")
		#print("El personaje esta quieto")


func atacar():
	if Input.is_action_just_pressed("attack") and is_on_floor():
		esta_atacando = true 
		velocity.x = 0
		print("El personaje esta atacando")
		if rayCast.is_colliding():
			rayCast.get_collision_normal()
			hacer_danio_enemigo()
		await get_tree().create_timer(1).timeout
		esta_atacando = false


func deslizar(): 
	if Input.is_action_just_pressed("slide") and is_on_floor(): 
		if esta_mirando_derecha: 
			velocity.x += velocidad_Slide
		else: 
			velocity.x -= velocidad_Slide
		#Duracion del slide 
		esta_deslizando = true 
		await get_tree().create_timer(0.3).timeout
		esta_deslizando = false
		velocity.x = 0


func fisicas(delta):
	#Gravedad
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= velocidad_Salto
	
	#Salto
	if(not is_on_floor()):
		velocity.y +=  gravity * delta


func movimiento():
	var movimiento = Input.get_axis("move_left","move_right")
	#get axis tiene un valor positivo y uno negativo, en este caso move_left da -1 y move_right da 1
	if not esta_deslizando and not esta_atacando:
		velocity.x = movimiento * velocidad_Movimiento  # Multiplica el movimiento por la velocidad
	
		# Si no hay movimiento (movimiento == 0), la velocidad en x será 0
		


func actualizar_giro():
	if (esta_mirando_derecha and velocity.x < 0) or (not esta_mirando_derecha and velocity.x > 0):
		scale.x *= -1
		esta_mirando_derecha = not esta_mirando_derecha


func recibir_danio():
	vidas -= 1
	print("La vida del personaje es:", vidas)

func hacer_danio_enemigo():
	var colision = rayCast.get_collider()
	if colision == enemigo and not ha_hecho_danio: 
		enemigo.recibir_danio()
		ha_hecho_danio = true
