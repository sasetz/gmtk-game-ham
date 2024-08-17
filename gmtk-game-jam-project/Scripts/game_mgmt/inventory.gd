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
	var scene_to_spawn: PackedScene
	var text: String

	func _init(scene: PackedScene, name: String) -> void:
		scene_to_spawn = scene
		text = name


@export_category("Building structures")
@export var Ramp: PackedScene = preload("res://Scenes/ramp.tscn")
@export var Cube: PackedScene = preload("res://Scenes/cube.tscn")
@export var Circle: PackedScene = preload("res://Scenes/circle.tscn")
@export var Square: PackedScene = preload("res://Scenes/square.tscn")
@export var Delete: PackedScene = preload("res://Scenes/delete.tscn")

@export_category("Inventory")
@export var InventoryButtonScene: PackedScene = preload("res://Scenes/UI/inventory_button.tscn")
@export var InventorySize: int = 5
@export var InventoryUIContainer: HBoxContainer

@export_category("Actions settings")
@export var ScaleMax: int = 20
@export var ScaleMin: int = -7
@export var ScaleFraction: float = 0.1
@export var RotationFraction: int = 64

# Inventory item definitions (singletons)

var NONE_ITEM = InventoryItem.new() # currently not holding anything
@onready var RAMP_ITEM = StructureInventoryItem.new(Ramp, "Ramp")
@onready var CUBE_ITEM = StructureInventoryItem.new(Cube, "Cube")
@onready var CIRCLE_ITEM = StructureInventoryItem.new(Circle, "Circle")
@onready var SQUARE_ITEM = StructureInventoryItem.new(Square, "Square")
#@onready var RESIZE_ITEM = ActionInventoryItem.new()
#@onready var ROTATE_ITEM = ActionInventoryItem.new()
@onready var DELETE_ITEM = ActionInventoryItem.new(Delete, "Delete")

const Pi:=3.14

var _current_item: InventoryItem = NONE_ITEM
var _scale_iterations: int = 0
var _held_item_object: Node2D = null

# first: inventory item
# second: UI button
var _inventory: Array = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _held_item_object != null:
		_held_item_object.position = get_global_mouse_position()

func scale_up():
	if _held_item_object == null or _scale_iterations >= ScaleMax:
		return
	_scale_iterations += 1
	for child in _held_item_object.get_children():
		child.scale += Vector2(ScaleFraction, ScaleFraction)

func scale_down():
	if _held_item_object == null or _scale_iterations <= ScaleMin:
		return
	_scale_iterations -= 1
	for child in _held_item_object.get_children():
		child.scale -= Vector2(ScaleFraction, ScaleFraction)

func rotate_clockwise():
	if _held_item_object == null:
		return
	_held_item_object.rotation += Pi / RotationFraction

func rotate_counter():
	if _held_item_object == null:
		return
	_held_item_object.rotation -= Pi / RotationFraction

func release_item():
	if _held_item_object == null:
		return
	_held_item_object.has_collision = true
	_held_item_object.position = get_global_mouse_position()
	_held_item_object = null # we don't delete the shape, we just clear this variable!
	_scale_iterations = 0

func add_item(item: InventoryItem):
	if _inventory.size() >= InventorySize:
		return
	_inventory.append(
		[item, InventoryButtonScene.instantiate()]
	)
	# TODO: initialize button here
	InventoryUIContainer.add_child(_inventory.back()[1])
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
	
	if _current_item != NONE_ITEM:
		add_item(_current_item)
	
	if inventory_item is StructureInventoryItem:
		_current_item = inventory_item
		_spawn_preview()
	elif inventory_item is ActionInventoryItem:
		match inventory_item:
			DELETE_ITEM:
				_spawn_action_preview()
				print("Action")
	remove_item(entry_index)


func remove_item(index: int):
	if index >= _inventory.size() or index < 0:
		return
	_inventory[index][1].queue_free()
	_inventory.remove_at(index)


func _spawn_object_at_mouse(shape: PackedScene):
	var obj : Node2D = shape.instantiate()

	obj.position = get_global_mouse_position()
	return obj

func _spawn_action_preview() -> void:
	if _held_item_object != null:
		_held_item_object.queue_free()
	if _current_item == NONE_ITEM:
		return
	
	var object : BuildingStructure = _spawn_object_at_mouse(_current_item.scene_to_spawn)
	object.has_collision = false
	add_child(object)
	_held_item_object = object

func _spawn_preview() -> void:
	if _held_item_object != null:
		_held_item_object.queue_free()
	if _current_item == NONE_ITEM:
		return
	if not (_current_item is StructureInventoryItem):
		return
	
	var object : BuildingStructure = _spawn_object_at_mouse(_current_item.scene_to_spawn)
	object.has_collision = false
	add_child(object)
	_held_item_object = object
