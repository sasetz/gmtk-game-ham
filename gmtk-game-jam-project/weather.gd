extends AnimatedSprite2D
class_name Weather
@export var type:String
@export var background2:CompressedTexture2D=preload("res://Visual/Screens/Задник дождь или снег.png")
@export var background1:CompressedTexture2D=preload("res://Visual/Backgrounds/Задник.png")
@export var background3:CompressedTexture2D=preload("res://Visual/Screens/Задник красная луна.png")
@export var met:PackedScene=preload("res://Scenes/Projectiles/meteor.tscn")
@export var dragon:PackedScene=preload("res://Scenes/Projectiles/Dragon.tscn")
# Called when the node enters the scene tree for the first time.

var _weathers=[
	"Wind",
	"Wind",
	"None",
	"None",
	"None",
]


func _ready():

	visible=false
	type="None"
	$Weather_timer.wait_time=1.0
	#$Weather_timer.wait_time=15.0
	$Weather_timer.timeout.connect(_new_weather_timeout)
	$Weather_timer.start()
	$Meteor_timer.timeout.connect(_new_meteor)
	
	pass # Replace with function body.

func _new_weather_timeout():
	var weather_picked=_weathers.pick_random()
	$Meteor_timer.stop()
	match weather_picked:
		"Wind":
			if not(type=="Wind2" or type=="Wind1"):
				match randi_range(1,2):
					1:
						flip_h=true
						type="Wind2"
					2:
						type="Wind1"
						flip_h=false
			visible=true
			play("Ветер")
			$"../UI/Background".texture=background1
			$Weather_timer.wait_time=10.0
			$Weather_timer.start()
		"None":
			play("Nothing")
			type="None"
			visible=false
			$"../UI/Background".texture=background1
			$Weather_timer.wait_time=10.0
			$Weather_timer.start()
		"Rain":
			type="Rain"
			visible=true
			play("Дождь")
			$"../UI/Background".texture=background2
			$Weather_timer.wait_time=15.0
			$Weather_timer.start()
		"Snow":
			type="Snow"
			visible=true
			play("Снег")
			$"../UI/Background".texture=background2
			$Weather_timer.wait_time=15.0
			$Weather_timer.start()
		"Smoke":
			type="Smoke"
			visible=true
			
			play("Туман")
			$"../UI/Background".texture=background1
			$Weather_timer.wait_time=10.0
			$Weather_timer.start()
		"Moon":
			type="Moon"
			visible=true
			play("Nothing")
			$"../UI/Background".texture=background3
			$Weather_timer.wait_time=20.0
			$Weather_timer.start()
		"Meteor":
			type="Meteor"
			play("Nothing")
			visible=false
			$"../UI/Background".texture=background2
			$Meteor_timer.start()
			$Weather_timer.wait_time=5.0
			$Weather_timer.start()
		"Dragon":
			type="Dragon"
			play("Nothing")
			visible=false
			var drag:Dragon
			drag=dragon.instantiate()
			get_tree().current_scene.add_child(drag)
			drag.position=Vector2(randi_range(-640,640),-421)
			drag.breath()
			$"../UI/Background".texture=background1
			$Weather_timer.wait_time=2.0
			$Weather_timer.start()
	print(type)
	
	
func _new_meteor():
	var meteor:MeteorOnCurve2D
	meteor=met.instantiate()
	get_tree().current_scene.add_child(meteor)
	meteor.position=Vector2(randi_range(-935,935),-1029)
	meteor.launch(meteor.position,Vector2(randi_range(-935,935),-0),9,1)
	$Meteor_timer.start()
