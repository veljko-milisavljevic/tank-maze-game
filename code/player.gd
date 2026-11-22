extends CharacterBody2D

#Za bodovanje
@onready var GM = %GameManager

#Za kretanje
@export var maxSpeed = 200.0
@export var speed = 0.0
@export var rSpeed = 2.0
var direction

#Za pucanje
var bulletScene: PackedScene = load("res://scenes/bullet.tscn")
@onready var offset = $Offset
var ammo = 3
var maxAmmo = 3

signal shoot(pos, dir)

@onready var inv_timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	#Centrira player-a na pocetku
	position = Vector2(get_viewport().size.x/2,get_viewport().size.y/2)
	inv_timer.timeout.connect(_on_timer_timeout)
	inv_timer.wait_time = 3.0
	inv_timer.start()
	
	
func _on_timer_timeout():
	print("time ran out!")
	add_to_group("Destroyable")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Vector2.from_angle(rotation - PI/2) #Racuna pravac tenka
	if(Input.is_action_pressed("left1")):
		rotate(-1*delta*rSpeed)
	if(Input.is_action_pressed("right1")):
		rotate(1*delta*rSpeed)
		
	if(Input.is_action_pressed("forward1")):
		speed = move_toward(speed, maxSpeed, 360*delta)
	if(Input.is_action_pressed("backward1")):
		speed = move_toward(speed, -(maxSpeed-40), 300*delta) #Kretanje unazad je sporije

	if(Input.is_action_just_pressed("shoot1")):
		if(ammo > 0):
			ammo -= 1
			shoot.emit(offset.global_position, rotation)
			speed -= 80 #Recoil
	
	speed = move_toward(speed, 0, 200*delta)
	velocity = direction * speed
	move_and_slide()
	

func _on_reload_timer_timeout():
	if(ammo < maxAmmo):
		ammo += 1

func _on_body_entered(body):
	if(body.is_in_group("Destroyable")): #Change to deadly
		GM.score2()
		queue_free()
