extends Area2D
class_name Tower
@export var TowerPart: PackedScene
@export var level := 1
@export var REGENERATION:=0.0
@export var INCOME_TIME:=2.0
@export var fundation:Array
@export var SPEED_UPGRADE:=0.0
@export var SAVEHEALTH:=0.0
const ENEMY_DAMAGE := 10
const FRIEND_DAMAGE := -100

#var Peoples :=1.0
var Peoples :=5.0
#var health := 20000.0
var health := 200.0
var maxhealth :=health
var number_in := 0.0
var MAIN: main

func _ready() -> void:
	MAIN=get_parent() as main
	$Timer.wait_time = 1.0
	$Timer.one_shot = true
	$Timer.autostart = true
	$Timer.start()
	$Timer.timeout.connect(_regenerate_timeout)
	level = 1
	update_level()
	
func _regenerate_timeout()->void:
	if health + REGENERATION>=maxhealth:
		health = maxhealth
	else:
		health += REGENERATION
	MAIN.health_label.text=str("Health:", round(health))
	$Timer.start()

var leng=2

func update_level():
	$"../AudioStreamPlayer".get_stream().set_sync_stream_volume(level,0.0)
	if Peoples == number_in:
		add_new_part()
		health+=100
		maxhealth+=100
		number_in=0
		Peoples+=1
		$AudioStreamPlayer.play()
		level+=1
		$"../GameManager/Inventory".add_to_roster(level)
		$"../GameManager/Spawner".add_to_pool(level)
		match level:
			3:
				$"../Weather"._weathers.append("Snow")
				$"../Weather"._weathers.append("Snow")
				leng+=1
			5:
				$"../Weather"._weathers.append("Rain")
				$"../Weather"._weathers.append("Rain")
			8:$"../Weather"._weathers.append("Smoke")
			#12:$"../Weather"._weathers.append("Moon")
			14:
				$"../Weather"._weathers.append("Dragon")
				$"../Weather"._weathers.append("Dragon")
				$"../Weather"._weathers.append("Dragon")
				$"../Weather"._weathers.append("Dragon")
			4:
				leng+=1
			7:
				leng+=1
			10:
				$"../Weather"._weathers.append("Meteor")
				$"../Weather"._weathers.append("Meteor")
				leng+=1
		
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
	if not (body is MobNPC or body is MeteorOnCurve2D):
		return
	if body.is_in_group("enemy"):
		body.queue_free()
		health -= body.TOWER_DAMAGE
		var percentage:float= health/maxhealth
		if percentage>=0.9:
			$StaticBody2D/Sprite2D.texture=fundation[0]
		elif percentage>=0.75:
			$StaticBody2D/Sprite2D.texture=fundation[1]
		elif percentage>=0.50:
			$StaticBody2D/Sprite2D.texture=fundation[2]
		elif percentage>=0.25:
			$StaticBody2D/Sprite2D.texture=fundation[3]
		elif percentage>=0.0:
			$StaticBody2D/Sprite2D.texture=fundation[4]
		update_level()
	
	if body.is_in_group("friend"):
		body.queue_free()
		number_in+=1
		update_level()


func _on_area_entered(area):
	if not (area is MobNPC or area is MeteorOnCurve2D):
		return
	print("Enemy reached the tower!")
	area.queue_free()
	health -= area.TOWER_DAMAGE
	var percentage:float= health/maxhealth
	if percentage>=0.9:
		$StaticBody2D/Sprite2D.texture=fundation[0]
	elif percentage>=0.75:
		$StaticBody2D/Sprite2D.texture=fundation[1]
	elif percentage>=0.50:
		$StaticBody2D/Sprite2D.texture=fundation[2]
	elif percentage>=0.25:
		$StaticBody2D/Sprite2D.texture=fundation[3]
	elif percentage>=0.0:
		$StaticBody2D/Sprite2D.texture=fundation[4]
	update_level()
	pass # Replace with function body.
