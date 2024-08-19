extends Node2D

@export_category("Mobs")
@export var Friend: PackedScene = preload("res://Scenes/friend.tscn")
@export var EnemyScene: PackedScene = preload("res://Scenes/Enemies/enemy.tscn")
@export var FastEnemyScene: PackedScene = preload("res://Scenes/Enemies/enemyfast.tscn")
@export var BigEnemyScene: PackedScene = preload("res://Scenes/Enemies/bigenemy.tscn")
@export var FlightEnemyScene: PackedScene = preload("res://Scenes/Enemies/flightenemy.tscn")

@export_category("Spawning rules")
@export var IntervalBetweenEntities: float = 0.5
@export var SpawnInterval: float = 5
@export var BatchSize: int = 4

@onready var _current_spawner : Marker2D = $LeftSpawner
@onready var _spawner1 : Marker2D = $LeftSpawner
@onready var _spawner2 : Marker2D = $RightSpawner

var _between_timer: Timer
var _spawn_timer: Timer
var _spawning_enemies := true
var _batch_left := BatchSize

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_between_timer = Timer.new()
	add_child(_between_timer)
	_between_timer.wait_time = IntervalBetweenEntities
	_between_timer.one_shot = true
	_between_timer.autostart = false
	_between_timer.timeout.connect(_on_spawn_interval_timeout)

	_spawn_timer = Timer.new()
	add_child(_spawn_timer)
	_spawn_timer.wait_time = SpawnInterval
	_spawn_timer.one_shot = false
	_spawn_timer.autostart = true
	_spawn_timer.timeout.connect(_on_spawn_timeout)
	_spawn_timer.start()


func _on_spawn_interval_timeout() -> void:
	_batch_left -= 1
	var bonus:=0
	var entity: MobNPC
	if _spawning_enemies:
		match randi_range(1,4):
			1:
				entity = FastEnemyScene.instantiate()
			2:
				entity = EnemyScene.instantiate()
			3:
				entity=FlightEnemyScene.instantiate()
				bonus=200
			4:
				entity = BigEnemyScene.instantiate()
	else:
		entity = Friend.instantiate()
	
	entity.position = Vector2(_current_spawner.position.x,_current_spawner.position.y-bonus)
	get_tree().current_scene.add_child(entity)
	entity.LIFE_TIME=entity.LIFE_TIME*$"../..".LIFE_TIME_MODIFICATOR
	entity.die_timer.wait_time=entity.LIFE_TIME
	if _current_spawner == _spawner1:
		entity.DIRECTION = 1
		entity.scale.x = 1
	else:
		entity.DIRECTION = -1
		entity.scale.x = -1
	if _batch_left > 0:
		_between_timer.start()

func _on_spawn_timeout() -> void:
	BatchSize = randi_range(1,5)
	_batch_left = BatchSize
	if randi_range(1,2) == 1:
		_spawning_enemies = not _spawning_enemies
	else:
		_spawning_enemies = _spawning_enemies
		
	if randi_range(1,2) == 1:
		_current_spawner = _spawner1
	else:
		_current_spawner = _spawner2
	_between_timer.start()
