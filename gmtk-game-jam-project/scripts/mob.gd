extends CharacterBody2D
class_name MobNPC


@export var SPEED = 100.0
@export var VERTICALSPEED = 100.0
@export var JUMP_VELOCITY = -400.0
@export var DIRECTION := 1.0
@export var DAMAGE_INTERVAL := 0.5
@export var DAMAGE := 1
@export var TOWER_DAMAGE := 10
@export var LIFE_TIME := 10.0
@export var SHOULD_DAMAGE_WHEN_ON_TOP := false
@export var HEALTH := 1

var die_timer: Timer
var damage_timer: Timer
var slide_timer: Timer
var death_collision_timer: Timer
var should_damage := true
var weath: Weather
var tower: Tower
@onready var health := HEALTH:
	set(value):
		health = value
		if value <= 0:
			value = 0
			die()
var frozen := false

func _ready() -> void:
	weath=$"../Weather" as Weather
	tower=$"../Tower" as Tower
	slide_timer=Timer.new()
	slide_timer.wait_time=100.0
	add_child(slide_timer)
	slide_timer.start()
	slide_timer.stop()
	
	die_timer = Timer.new()
	add_child(die_timer)
	die_timer.wait_time = LIFE_TIME
	die_timer.one_shot = true
	die_timer.autostart = true
	die_timer.start()
	die_timer.timeout.connect(_on_die_interval_timeout)
	
	damage_timer = Timer.new()
	add_child(damage_timer)
	damage_timer.wait_time = DAMAGE_INTERVAL
	damage_timer.one_shot = false
	damage_timer.autostart = true
	damage_timer.start()
	damage_timer.timeout.connect(_on_damage_interval_timeout)
	
	death_collision_timer = Timer.new()
	add_child(death_collision_timer)
	death_collision_timer.wait_time = 0.2
	death_collision_timer.one_shot = true
	death_collision_timer.autostart = false
	death_collision_timer.timeout.connect(func(): collision_layer = 0)

	$AnimatedSprite2D2.animation_finished.connect(queue_free)
	
func _on_die_interval_timeout() -> void:
	print("Mob died!")
	die()

func _on_damage_interval_timeout() -> void:
	should_damage = true

func _physics_process(delta: float) -> void:
	floor_check(delta)

	dir_check()
	

	wall_check()
		
	weather_check()
	if not frozen:
		move_and_slide()

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is BuildingStructure and \
		should_damage and \
		(SHOULD_DAMAGE_WHEN_ON_TOP or is_on_wall()):
			c.get_collider().current_health -= DAMAGE
			var perc:float=c.get_collider().current_health/c.get_collider().INITIAL_HEALTH
			if perc>=0.7:
				c.get_collider().sprite.texture=c.get_collider().Structure_vatiation[0]
			elif perc>=0.4:
				c.get_collider().sprite.texture=c.get_collider().Structure_vatiation[1]
			elif perc>0.0:
				c.get_collider().sprite.texture=c.get_collider().Structure_vatiation[2]
			should_damage = false

func weather_check():
	if (DIRECTION == 1 and weath.type == "Wind1") or (DIRECTION == -1 and weath.type == "Wind2"):
		velocity.x *= 2
	elif (DIRECTION == 1 and weath.type == "Wind2") or (DIRECTION == -1 and weath.type == "Wind1"):
		velocity.x *= 0.5
	elif weath.type=="Rain":
		if velocity.y<=0:
			velocity.y*=0.1
		if position.y>=-10:
			velocity.x*=0.8
	elif weath.type=="Snow":
		if not is_on_wall():
			if slide_timer.is_stopped():
				slide_timer.wait_time=100.0
				slide_timer.start()
			velocity.x=velocity.x*0.5+velocity.x*(100.0-slide_timer.time_left)*(100.0-slide_timer.time_left)*0.1
		else:
			slide_timer.stop()
			if velocity.y<=0:
				velocity.y*=0.7
	else:
		slide_timer.stop()
		
func wall_check():
	if is_on_wall():
		velocity.y = -VERTICALSPEED*0.5
		
func floor_check(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func dir_check():
	if DIRECTION:
		velocity.x = DIRECTION * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func die():
	death_collision_timer.start()
	frozen = true
	$AnimatedSprite2D.visible=false
	$AnimatedSprite2D2.visible=true
	$AnimatedSprite2D2.play("death")
