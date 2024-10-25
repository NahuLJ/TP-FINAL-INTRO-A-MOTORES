extends CharacterBody2D
#Constantes de velocidad y gravedad
const velocidad_Movimiento = 150
const velocidad_Salto = 400
const velocidad_Slide = 200 # velocidad del slide 
const gravity = 980


#Variables para controlar
var esta_mirando_derecha = true
var esta_deslizando = false #Variable para controlar el deslizamiento 
var esta_atacando = false 

func _process(delta): 
	movimiento(delta)
	move_and_slide()
	fisicas(delta)
	animaciones()
	deslizar()
	actualizar_giro()
	atacar()

func animaciones():
	var animated_sprite = $AnimatedSprite2D
	
	if esta_atacando:
		animated_sprite.play("attack")
		return 
		
	#Deslizarse
	if esta_deslizando:
		animated_sprite.play("Slide")
		return #Salir de la funcion para evitar que se reproduzcan otras animaciones
	
	#Saltar y Caer
	if(not is_on_floor()):
		if(velocity.y < 0):
			animated_sprite.play("Jump")
		else:
			animated_sprite.play("Fall")
		return
	
	#Correr y Estar Quieto
	if (velocity.x != 0):
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")
	
	#Atacar
	
	
func atacar():
	if Input.is_action_just_pressed("attack") and is_on_floor():
		esta_atacando = true 
		velocity.x = 0
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


func movimiento(delta):
	var movimiento = Input.get_axis("move_left","move_right")
	#get axis tiene un valor positivo y uno negativo, en este caso move_left da -1 y move_right da 1
	if not esta_deslizando and not esta_atacando:
		velocity.x = movimiento * velocidad_Movimiento  # Multiplica el movimiento por la velocidad
	
		# Si no hay movimiento (movimiento == 0), la velocidad en x será 0
		if movimiento == 0:
			velocity.x = 0

func actualizar_giro():
	if (esta_mirando_derecha and velocity.x < 0) or (not esta_mirando_derecha and velocity.x > 0):
		scale.x *= -1
		esta_mirando_derecha = not esta_mirando_derecha
