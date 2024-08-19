extends Node2D
class_name Tower_Part
var choosing: bool
@export var allvariants: Array
@export var arrow: PackedScene = preload("res://Scenes/Projectiles/arrow.tscn")
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
			$Timer.wait_time = 3.8
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
	var maxdis:=100000.0
	var a:Vector2
	var marked:Enemy
	var b:float
	for enem in get_tree().current_scene.get_children():
		if enem is Enemy:
			a=enem.position-$AnimatedSprite2D.get_global_position()
			b=sqrt(pow(a.x, 2) + pow(a.y, 2))
			if b<maxdis and enem.position.x>0:
				maxdis=sqrt(pow(a.x, 2) + pow(a.y, 2))
				marked=enem
	if marked!=null:
		get_tree().current_scene.add_child(projectile)
		projectile.launch($AnimatedSprite2D.get_global_position(),
		marked.position,18.0,3)
		
	projectile= arrow.instantiate()	
	maxdis=100000.0	
	marked=null
	for enem in get_tree().current_scene.get_children():
		if enem is Enemy:
			a=enem.position-$AnimatedSprite2D2.get_global_position()
			b=sqrt(pow(a.x, 2) + pow(a.y, 2))
			if b<maxdis and enem.position.x<0:
				maxdis=sqrt(pow(a.x, 2) + pow(a.y, 2))
				marked=enem
	if marked!=null:
		get_tree().current_scene.add_child(projectile)
		projectile.launch($AnimatedSprite2D2.get_global_position(),
		marked.position,18.0,3)
	$Timer.wait_time = 5
	$Timer.start()
