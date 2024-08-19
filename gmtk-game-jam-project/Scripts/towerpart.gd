extends Node2D
class_name Tower_Part
var choosing: bool
@export var allvariants: Array
@export var arrow: PackedScene = preload("res://Scenes/arrow.tscn")
var i := 0
var reload := false
var tower: Tower 
# Called when the node enters the scene tree for the first time.
func _ready():
	tower = get_parent() as Tower
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if choosing==true:
		if Input.is_action_just_released("MWU"):
			i=i+1
			if i>len(allvariants)-1:
				i=0
			$Sprite2D.texture=allvariants[i]
		if Input.is_action_just_released("MWD"):
			i=i-1
			if i<0:
				i=len(allvariants)-1
			$Sprite2D.texture=allvariants[i]
		if Input.is_action_just_pressed("mouse1"):
			_end()
			

func _on_button_pressed():
	if choosing==false:
		choosing=true
	else:
		_end()
		
func _end():
	match i:
		0:
			tower.SPEED_UPGRADE+=25
		1:
			tower.get_parent().inventory.InventorySize+=1
			tower.get_parent().inventory._add_next_item_from_roster()
		2:
			$AnimatedSprite2D.visible=true
			$AnimatedSprite2D.play("default")
			$AnimatedSprite2D2.visible=true
			$AnimatedSprite2D2.play("default")
			$Timer.wait_time = 1.8
			$Timer.one_shot = true
			$Timer.autostart = true
			$Timer.start()
			$Timer.timeout.connect(fire_timeout)
		3:
			tower.INCOME_TIME-=0.2
			print(tower.INCOME_TIME)
		4:
			tower.REGENERATION+=0.5
		5:
			tower.SAVEHEALTH+=1
			tower.MAIN.health_label.text = str("Health:", round(tower.health),"
			Saves:",tower.SAVEHEALTH)
	choosing=false
	$Button.disabled=true
	$Button.visible=false
	
func fire_timeout():
	var projectile:= arrow.instantiate()
	add_child(projectile)
	print($AnimatedSprite2D.get_global_position()," ",get_global_mouse_position())
	projectile.launch($AnimatedSprite2D.get_global_position(),
	get_global_mouse_position(),9.0,1)
	$Timer.wait_time = 12.5
	$Timer.start()
