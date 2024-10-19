extends CharacterBody2D

const velocidad = 200
const velocidad_Salto = 400
const gravity = 980
var esta_mirando_derecha = true

func _process(delta): 
	mover_x()
	girar()
	move_and_slide()
	saltar(delta)
	gravedad(delta)
	animaciones()

func animaciones():
	var animated_sprite = $AnimatedSprite2D
	#correr y estar quieto
	if (velocity.x != 0):
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")
	
	if(not is_on_floor()):
		if(velocity.y < 0):
			animated_sprite.play("Jump")
		else:
			animated_sprite.play("Fall")


func saltar(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= velocidad_Salto

func gravedad(delta):
	if(not is_on_floor()):
		velocity.y +=  gravity * delta

func girar():
	if (esta_mirando_derecha and velocity.x < 0) or (not esta_mirando_derecha and velocity.x > 0):
		scale.x *= -1
		esta_mirando_derecha = not esta_mirando_derecha

func mover_x():
	var movimiento = Input.get_axis("move_left","move_right")
	#get axis tiene un valor positivo y uno negativo, en este caso move_left da -1 y move_right da 1
	velocity.x = movimiento * velocidad
