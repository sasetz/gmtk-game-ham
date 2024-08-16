extends Area2D

@export var level := 1

const ENEMY_DAMAGE := 50
const FRIEND_DAMAGE := -100
var health := 200

func _ready() -> void:
	update_level()

func update_level():
	level = clamp(health / 200.0, 1, 5)
	scale.y = level


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("Enemy reached the tower!")
		body.queue_free()
		health -= ENEMY_DAMAGE
		update_level()
	
	if body.is_in_group("friend"):
		print("Friend reached the tower!")
		body.queue_free()
		health -= FRIEND_DAMAGE
		update_level()
	print("Current health: %d" % health)
