extends Node2D


enum PlaceMode {
	None,
	Ramp,
	Cube,
}

@export var Friend: PackedScene
@export var Enemy: PackedScene
@export var Ramp: PackedScene
@export var Cube: PackedScene
@export var SpawnInterval: float = 1.5
@export var BatchSize: int = 4

@onready var spawner : Marker2D = $Spawner
var spawnTimer: Timer
var spawningEnemies := true
var batchLeft := BatchSize
var currentItem := PlaceMode.None

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnTimer = Timer.new()
	add_child(spawnTimer)
	spawnTimer.wait_time = SpawnInterval
	spawnTimer.one_shot = true
	spawnTimer.autostart = false
	spawnTimer.timeout.connect(_on_spawn_interval_timeout)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse1"):
		match currentItem:
			PlaceMode.Ramp:
				spawn_object_at_mouse(Ramp)
				currentItem = PlaceMode.None
			PlaceMode.Cube:
				spawn_object_at_mouse(Cube)
				currentItem = PlaceMode.None




func _on_spawn_interval_timeout() -> void:
	batchLeft -= 1
	var entity: Node2D = Enemy.instantiate() if spawningEnemies else Friend.instantiate()
	entity.position = spawner.position
	get_tree().current_scene.add_child(entity)

	if batchLeft > 0:
		spawnTimer.start()

func _on_spawn_timeout() -> void:
	batchLeft = BatchSize
	spawningEnemies = not spawningEnemies
	spawnTimer.start()


func spawn_object_at_mouse(shape: PackedScene):
	var obj : Node2D = shape.instantiate()

	obj.position = get_global_mouse_position()
	add_child(obj)


func _on_ramp_button_pressed() -> void:
	currentItem = PlaceMode.Ramp


func _on_cube_button_pressed() -> void:
	currentItem = PlaceMode.Cube


func _on_none_button_pressed() -> void:
	currentItem = PlaceMode.None
