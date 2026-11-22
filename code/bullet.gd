extends RigidBody2D

signal hit_player_1
signal hit_player_2

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_constant_force(Vector2.from_angle(rotation).rotated(-PI/2)*250, Vector2())
	apply_impulse(Vector2.from_angle(rotation).rotated(-PI/2)*500, Vector2())

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if(body.is_in_group("Destroyable")):
		if(body.name == "Player"):
			hit_player_1.emit()
			get_tree().reload_current_scene()
		elif(body.name == "Player2"):
			hit_player_2.emit()
			get_tree().reload_current_scene()
		queue_free()
		#body.queue_free()



