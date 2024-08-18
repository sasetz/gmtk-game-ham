extends Area2D
class_name Tower
@export var TowerPart: PackedScene
@export var level := 1
@export var REGENERATION:=0.0
@export var INCOME_TIME:=2.0
const ENEMY_DAMAGE := 10
const FRIEND_DAMAGE := -100
const Peoples :=1.0
var health := 200.0
var maxhealth :=200.0
var number_in := 1.0
var MAIN: main

func _ready() -> void:
	MAIN=get_parent() as main
	$Timer.wait_time = 1.0
	$Timer.one_shot = true
	$Timer.autostart = true
	$Timer.start()
	$Timer.timeout.connect(_regenerate_timeout)
	level = clamp(number_in / Peoples, 1, 15)
	update_level()
	
func _regenerate_timeout()->void:
	if health + REGENERATION>=maxhealth:
		health = maxhealth
	else:
		health += REGENERATION
	MAIN.health_label.text=str("Health:", round(health))
	$Timer.start()

func update_level():
	if level + 1 == clamp(number_in / Peoples, 1, 15):
		add_new_part()
		health+=100
		maxhealth+=100
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
	add_child(obj)
	obj.position.y=-64*level-32

func _on_body_entered(body: Node) -> void:
	if not (body is MobNPC):
		return
	if body.is_in_group("enemy"):
		print("Enemy reached the tower!")
		body.queue_free()
		health -= body.TOWER_DAMAGE
		update_level()
	
	if body.is_in_group("friend"):
		print("Friend reached the tower!")
		body.queue_free()
		number_in+=1
		update_level()
	print("Current health: %d" % health)
