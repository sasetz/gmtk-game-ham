extends CharacterBody2D
class_name Mobe

@export var SPEED = 100.0
@export var JUMP_VELOCITY = -400.0
@export var DIRECTION := 1.0
@export var TIMER = Timer

func _ready() -> void:
	var dieTimer = Timer.new()
	add_child(dieTimer)
	dieTimer.wait_time = 10.0
	dieTimer.one_shot = true
	dieTimer.autostart = true
	dieTimer.start()
	print(dieTimer.time_left)
	dieTimer.timeout.connect(_on_die_interval_timeout)
	
func _on_die_interval_timeout()->void:
	print("Mobe die!")
	get_tree().current_scene.remove_child(self)

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
