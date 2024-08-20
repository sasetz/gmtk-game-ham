extends Enemy

var mod_dir:=0.0
func _ready():
	super._ready()
	fly=true
	TOWER_DAMAGE=20
	VERTICALSPEED=100
	SPEED=100
	$Timer.timeout.connect(_dir_change)
	$Timer.start()

func floor_check(_delta: float) -> void:
	if not is_on_floor():
		velocity.y=VERTICALSPEED*mod_dir
		velocity.x=SPEED

func wall_check():
	if is_on_wall():
		_dir_change()
func _dir_change():
	mod_dir=randf_range(-1,1)
	$Timer.start()
	
