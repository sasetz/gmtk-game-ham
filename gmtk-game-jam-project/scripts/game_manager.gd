extends Node2D


enum PlaceMode {
	None,
	Ramp,
	Cube,
}

@export var Friend: PackedScene
@export var Enemy: PackedScene
@export var FastEnemy: PackedScene
@export var Ramp: PackedScene
@export var Cube: PackedScene
@export var SpawnInterval: float = 0.5
@export var BatchSize: int = 4

@onready var current_spawner : Marker2D = $Spawner
@onready var spawner1 : Marker2D = $Spawner
@onready var spawner2 : Marker2D = $Spawner2

var spawnTimer: Timer
var spawningEnemies := true
var batchLeft := BatchSize
var currentItem := PlaceMode.None
var heldItemObject : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text=str("Health:",$"../Tower".health)
	spawnTimer = Timer.new()
	add_child(spawnTimer)
	spawnTimer.wait_time = SpawnInterval
	spawnTimer.one_shot = true
	spawnTimer.autostart = false
	spawnTimer.timeout.connect(_on_spawn_interval_timeout)


func _process(delta: float) -> void:
	if heldItemObject != null:
		heldItemObject.position = get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse1") and heldItemObject != null:
		heldItemObject.has_collision = true
		heldItemObject.position = get_global_mouse_position()
		heldItemObject = null # we don't delete the shape, we just clear this variable!


func _on_spawn_interval_timeout() -> void:
	batchLeft -= 1
	var entity: MobNPC = Enemy.instantiate() if spawningEnemies else Friend.instantiate()
	if spawningEnemies:
		if randi_range(1,3)==1:
			entity = FastEnemy.instantiate()
		else:
			entity = Enemy.instantiate()
	else:
		entity = Friend.instantiate()
	entity.position = current_spawner.position
	get_tree().current_scene.add_child(entity)
	if current_spawner == spawner1:
		entity.DIRECTION = 1
		entity.scale.x=1
	else:
		entity.DIRECTION = -1
		entity.scale.x=-1
	if batchLeft > 0:
		spawnTimer.start()

func _on_spawn_timeout() -> void:
	BatchSize = randi_range(1,5)
	batchLeft = BatchSize
	if randi_range(1,2) == 1:
		spawningEnemies = not spawningEnemies
	else:
		spawningEnemies = spawningEnemies
		
	if randi_range(1,2) == 1:
		current_spawner = spawner1
	else:
		current_spawner = spawner2
	spawnTimer.start()


func spawn_object_at_mouse(shape: PackedScene):
	var obj : Node2D = shape.instantiate()

	obj.position = get_global_mouse_position()
	return obj


func _on_ramp_button_pressed() -> void:
	currentItem = PlaceMode.Ramp
	spawn_preview()


func _on_cube_button_pressed() -> void:
	currentItem = PlaceMode.Cube
	spawn_preview()
	

func _on_none_button_pressed() -> void:
	currentItem = PlaceMode.None
	spawn_preview()

func spawn_preview() -> void:
	if heldItemObject != null:
		heldItemObject.queue_free()
	if currentItem == PlaceMode.None:
		return

	var object : Node2D
	match currentItem:
		PlaceMode.Ramp:
			object = spawn_object_at_mouse(Ramp)
		PlaceMode.Cube:
			object = spawn_object_at_mouse(Cube)
		_:
			object = spawn_object_at_mouse(Cube)
	object.has_collision = false
	add_child(object)
	heldItemObject = object
	
	

func _on_tower_body_entered(body):
	print("check")
	$RichTextLabel.text=str("Health:",$"../Tower".health)
