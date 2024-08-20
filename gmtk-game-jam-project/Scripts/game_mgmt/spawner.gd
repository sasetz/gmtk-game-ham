extends Node2D

@export_category("Mobs")
@export var Friend: PackedScene = preload("res://Scenes/friend.tscn")
@export var EnemyScene: PackedScene = preload("res://Scenes/Enemies/enemy.tscn")
@export var FastEnemyScene: PackedScene = preload("res://Scenes/Enemies/enemyfast.tscn")
@export var BigEnemyScene: PackedScene = preload("res://Scenes/Enemies/bigenemy.tscn")
@export var FlightEnemyScene: PackedScene = preload("res://Scenes/Enemies/flightenemy.tscn")
@export var KillEnemyScene: PackedScene = preload("res://Scenes/Enemies/killerenemy.tscn")
@export var ArmoredEnemyScene: PackedScene= preload("res://Scenes/Enemies/armorenemy.tscn")

@export_category("Spawning rules")
@export var IntervalBetweenEntities: float = 0.25
@export var SpawnInterval: float = 3
@export var BatchSize: int = 4

@export_category("Spawners")
@export var TowerNode: Tower

@onready var _current_spawner : Marker2D = $LeftSpawner
@onready var _spawner1 : Marker2D = $LeftSpawner
@onready var _spawner2 : Marker2D = $RightSpawner

var _enemies=[
	EnemyScene,
	EnemyScene,
	EnemyScene,
	EnemyScene,
	EnemyScene,
	EnemyScene,
]
var _between_timer: Timer
var _spawn_timer: Timer
var _spawning_enemies := true
var _batch_left := BatchSize
var data = [
	[1.0, 2.0, 1.0, 3.0, 5.0, 3.0, 4.0],
	[1.0, 3.0, 1.0, 3.0, 4.0, 3.0, 4.0],
	[1.0, 3.0, 2.0, 3.0, 1.0, 1.0, 3.9],
	[2.0, 4.0, 2.0, 4.0, 4.0, 3.0, 3.9],
	[2.0, 4.0, 2.0, 5.0, 4.0, 3.0, 3.9],
	[2.0, 5.0, 3.0, 5.0, 1.0, 1.0, 3.8],
	[2.0, 6.0, 3.0,	6.0, 1.0, 1.0, 3.8],
	[2.0, 7.0, 4.0, 7.0, 4.0, 5.0, 3.7],
	[3.0, 7.0, 5.0, 7.0, 3.0, 4.0, 3.6],
	[3.0, 8.0, 5.0, 7.0, 3.0, 4.0, 3.5],
	[4.0, 8.0, 6.0, 7.0, 3.0, 4.0, 3.4],
	[4.0, 9.0, 6.0, 7.0, 3.0, 4.0, 3.3],
	[5.0, 9.0, 5.0, 8.0, 1.0, 2.0, 3.2],
	[5.0, 10.0, 5.0, 9.0, 1.0, 2.0, 3.1],
	[6.0, 10.0, 6.0, 9.0, 1.0, 2.0, 3.0],
	[5.0, 12.0, 7.0, 10.0, 2.0, 5.0, 3.0]
]

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

var bigcount:=0
func _on_spawn_interval_timeout() -> void:
	_batch_left -= 1
	var bonus:=0
	var entity: MobNPC
	var entity_scene:PackedScene
	if _spawning_enemies:
		entity_scene=_enemies.pick_random()
		if entity_scene==BigEnemyScene:
			bigcount+=1
			if bigcount>round(BatchSize/5.0):
				entity=EnemyScene.instantiate()
			else:
				entity=entity_scene.instantiate()
		elif entity_scene==FlightEnemyScene:
			bonus=250
			entity=entity_scene.instantiate()
		else:
			entity=entity_scene.instantiate()
	else:
		entity = Friend.instantiate()
	
	entity.position = Vector2(_current_spawner.position.x,_current_spawner.position.y-bonus)
	
	entity.LIFE_TIME=entity.LIFE_TIME*$"../..".LIFE_TIME_MODIFICATOR
	if _current_spawner == _spawner1:
		entity.DIRECTION = 1
		entity.scale.x = 1
	else:
		entity.DIRECTION = -1
		entity.scale.x = -1
	if _batch_left > 0:
		_between_timer.start()
	
	get_tree().current_scene.add_child(entity)
func _on_spawn_timeout() -> void:
	bigcount=0
	_spawn_timer.wait_time =data[TowerNode.level-1][6]
	var i:=0
	if (randi_range(1,int(data[TowerNode.level-1][4]+data[TowerNode.level-1][5])) <= data[TowerNode.level-1][4]) or i==5:
		_spawning_enemies = false
		_batch_left = randi_range(data[TowerNode.level-1][0],data[TowerNode.level-1][1])
		BatchSize=_batch_left
		i=0
	else:
		i+=1
		_spawning_enemies = true
		_batch_left = randi_range(data[TowerNode.level-1][2],data[TowerNode.level-1][3])
		BatchSize=_batch_left
	if randi_range(1,2) == 1:
		_current_spawner = _spawner1
	else:
		_current_spawner = _spawner2
	_between_timer.start()
	
func add_to_pool(level):
	if level==3:
		_enemies.append(FastEnemyScene)
		_enemies.append(FastEnemyScene)
		_enemies.append(FastEnemyScene)
	elif level==6:
		_enemies.append(BigEnemyScene)
		_enemies.append(BigEnemyScene)
	elif level==8:
		_enemies.append(ArmoredEnemyScene)
		_enemies.append(ArmoredEnemyScene)
	elif level==9:
		_enemies.append(FlightEnemyScene)
		_enemies.append(FlightEnemyScene)
		_enemies.append(FlightEnemyScene)
		_enemies.append(FlightEnemyScene)
	elif level==11:
		_enemies.append(KillEnemyScene)
		
