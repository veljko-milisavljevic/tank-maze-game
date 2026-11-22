extends Node

var bulletScene: PackedScene = load("res://scenes/bullet.tscn")
@onready var GM = %GameManager

func _on_player_shoot(pos, dir):
	var bullet = bulletScene.instantiate()
	bullet.connect("hit_player_1", _on_Bullet_hit_player_1)
	bullet.connect("hit_player_2", _on_Bullet_hit_player_2)
	bullet.position = pos
	bullet.rotation = dir
	add_child(bullet)

func _on_Bullet_hit_player_1():
	GM.score_2()

func _on_Bullet_hit_player_2():
	GM.score_1()
