extends CharacterBody2D
class_name Mob


@export var SPEED = 100.0
@export var JUMP_VELOCITY = -400.0
@export var DIRECTION := 1.0
@export var DAMAGE_INTERVAL := 0.5
@export var DAMAGE := 1
@export var SHOULD_DAMAGE_WHEN_ON_TOP := false

var die_timer: Timer
var damage_timer: Timer
var should_damage := true

func _ready() -> void:
	die_timer = Timer.new()
	add_child(die_timer)
	die_timer.wait_time = 10.0
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
	
func _on_die_interval_timeout() -> void:
	print("Mob died!")
	get_tree().current_scene.remove_child(self)

func _on_damage_interval_timeout() -> void:
	should_damage = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if DIRECTION:
		velocity.x = DIRECTION * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_wall():
		velocity.y = -SPEED*0.5
	
	move_and_slide()

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is BuildingShape and \
		should_damage and \
		(SHOULD_DAMAGE_WHEN_ON_TOP or is_on_wall()):
			print("Damaging the shape! Its health: %d" % c.get_collider().current_health)
			c.get_collider().current_health -= DAMAGE
			should_damage = false
