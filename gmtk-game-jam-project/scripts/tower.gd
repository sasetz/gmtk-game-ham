extends Area2D
@export var TowerPart: PackedScene
@export var level := 1
const ENEMY_DAMAGE := 10
const FRIEND_DAMAGE := -100
const Peoples:=1.0
var health := 200
var number_in := 1.0

func _ready() -> void:
	level=clamp(number_in / Peoples, 1, 15)
	update_level()

func update_level():
	if level+1==clamp(number_in / Peoples, 1, 15):
		add_new_part()
		health+=100
		level=clamp(number_in / Peoples, 1, 15)
	$Collision.scale.y = level
	$StaticBody2D/CollisionShape2D.scale.y = level
	$StaticBody2D/Sprite2D2.position.y=-64*level-32
	
func add_new_part()->void:
	var obj : Node2D = TowerPart.instantiate()
	#if randi_range(1,2)==1:
		#sprite.texture = load("res://Visual/Backgrounds/Башня основа.png")
	#else:
		#sprite.texture = load("res://Visual/Backgrounds/Башня окно.png")
	$StaticBody2D.add_child(obj)
	obj.position.y=-64*level-32

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("Enemy reached the tower!")
		body.queue_free()
		health -= ENEMY_DAMAGE
		update_level()
	
	if body.is_in_group("friend"):
		print("Friend reached the tower!")
		body.queue_free()
		number_in+=1
		update_level()
	print("Current health: %d" % health)
