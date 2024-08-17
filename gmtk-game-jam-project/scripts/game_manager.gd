extends Node2D


class InventoryItem:
	pass

# TODO: replace name replacement with custom sprites
class StructureInventoryItem extends InventoryItem:
	var scene_to_spawn: PackedScene
	var text: String

	func _init(scene: PackedScene, name: String) -> void:
		scene_to_spawn = scene
		text = name

class ActionInventoryItem extends InventoryItem:
	pass


@export_category("Mobs")
@export var Friend: PackedScene = preload("res://Scenes/friend.tscn")
@export var EnemyScene: PackedScene = preload("res://Scenes/enemy.tscn")

@export_category("Building structures")
@export var Ramp: PackedScene = preload("res://Scenes/ramp.tscn")
@export var Cube: PackedScene = preload("res://Scenes/cube.tscn")

@export_category("Spawning rules")
@export var SpawnInterval: float = 0.5
@export var BatchSize: int = 4

@export_category("Inventory")
@export var InventoryButtonScene: PackedScene = preload("res://Scenes/UI/inventory_button.tscn")
@export var InventorySize: int = 5

@onready var _current_spawner : Marker2D = $Spawner
@onready var _spawner1 : Marker2D = $Spawner
@onready var _spawner2 : Marker2D = $Spawner2
@onready var _inventory_container : HBoxContainer = $Inventory

# Inventory item definitions (singletons)

var _none_item = InventoryItem.new() # currently not holding anything
@onready var _ramp_item = StructureInventoryItem.new(Ramp, "Ramp")
@onready var _cube_item = StructureInventoryItem.new(Cube, "Cube")
@onready var _resize_item = ActionInventoryItem.new()
@onready var _rotate_item = ActionInventoryItem.new()
@onready var _delete_item = ActionInventoryItem.new()

var _spawn_timer: Timer
var _inventory_giver_timer: Timer
var _spawning_enemies := true
var _batch_left := BatchSize
var _current_item : InventoryItem = _none_item
var _held_item_object : Node2D = null

# first: inventory item
# second: UI button
var _inventory: Array = []
@onready var _item_roster := [
	_ramp_item,
	_ramp_item,
	_cube_item,
	_cube_item,
]
var _next_roster_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = str("Health:",$"../Tower".health)
	_spawn_timer = Timer.new()
	add_child(_spawn_timer)
	_spawn_timer.wait_time = SpawnInterval
	_spawn_timer.one_shot = true
	_spawn_timer.autostart = false
	_spawn_timer.timeout.connect(_on_spawn_interval_timeout)

	_inventory_giver_timer = Timer.new()
	add_child(_inventory_giver_timer)
	_inventory_giver_timer.wait_time = 3
	_inventory_giver_timer.one_shot = false
	_inventory_giver_timer.start()
	_inventory_giver_timer.timeout.connect(func():
		_add_item(_item_roster[_next_roster_index])
		_next_roster_index += 1
		_next_roster_index %= _item_roster.size() # restricts the index to only this array's size
	)

	# TODO: replace with none
	_add_item(_ramp_item)
	_add_item(_cube_item)

func _process(_delta: float) -> void:
	if _held_item_object != null:
		_held_item_object.position = get_global_mouse_position()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse1") and _held_item_object != null:
		_held_item_object.has_collision = true
		_held_item_object.position = get_global_mouse_position()
		_held_item_object = null # we don't delete the shape, we just clear this variable!


func _add_item(item: InventoryItem):
	if _inventory.size() >= InventorySize:
		return
	_inventory.append(
		[item, InventoryButtonScene.instantiate()]
	)
	# TODO: initialize button here
	_inventory_container.add_child(_inventory.back()[1])
	_inventory.back()[1].connect("custom_press", _test_signal_process)
	_inventory.back()[1].text = _inventory.back()[0].text

func _test_signal_process(button: InventoryButton):
	# find the button's entry
	var inventory_item = null
	var entry_index := -1
	for i in _inventory.size():
		var e = _inventory[i]
		if e[1] == button:
			inventory_item = e[0]
			entry_index = i
			break
	
	if inventory_item == null:
		print("Error! The button pressed was not in the inventory array!")
		return
	
	if inventory_item is StructureInventoryItem:
		_current_item = inventory_item
		_spawn_preview()
	elif inventory_item is ActionInventoryItem:
		match inventory_item:
			_:
				print("Action")
	_remove_item(entry_index)


func _remove_item(index: int):
	if index >= _inventory.size() or index < 0:
		return
	_inventory[index][1].queue_free()
	_inventory.remove_at(index)


func _spawn_object_at_mouse(shape: PackedScene):
	var obj : Node2D = shape.instantiate()

	obj.position = get_global_mouse_position()
	return obj

func _spawn_preview() -> void:
	if _held_item_object != null:
		_held_item_object.queue_free()
	if _current_item == _none_item:
		return
	if not (_current_item is StructureInventoryItem):
		return
	
	var object : BuildingStructure = _spawn_object_at_mouse(_current_item.scene_to_spawn)
	object.has_collision = false
	add_child(object)
	_held_item_object = object


func _on_tower_body_entered(_body):
	print("check")
	$RichTextLabel.text=str("Health:",$"../Tower".health)

func _on_spawn_interval_timeout() -> void:
	_batch_left -= 1
	var entity: MobNPC = EnemyScene.instantiate() if _spawning_enemies else Friend.instantiate()
	entity.position = _current_spawner.position
	get_tree().current_scene.add_child(entity)
	if _current_spawner == _spawner1:
		entity.DIRECTION = 1
		entity.scale.x=1
	else:
		entity.DIRECTION = -1
		entity.scale.x=-1
	if _batch_left > 0:
		_spawn_timer.start()

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
	_spawn_timer.start()
