extends Node2D
class_name Inventory


class InventoryItem:
	var text: String
	var icon: CompressedTexture2D
	func _init(name: String, img: CompressedTexture2D) -> void:
		text = name
		icon = img

class StructureInventoryItem extends InventoryItem:
	var scene_to_spawn: PackedScene

	func _init(scene: PackedScene, name: String, img: CompressedTexture2D) -> void:
		scene_to_spawn = scene
		text = name
		icon = img

class ActionInventoryItem extends InventoryItem:
	pass
	

@export_category("Building structures")
@export var Ramp: PackedScene = preload("res://Scenes/ramp.tscn")
@export var Cube: PackedScene = preload("res://Scenes/cube.tscn")
@export var Circle: PackedScene = preload("res://Scenes/circle.tscn")
@export var Square: PackedScene = preload("res://Scenes/square.tscn")
@export var Delete: PackedScene = preload("res://Scenes/delete.tscn")

@export_category("Inventory")
@export var InventoryButtonScene: PackedScene = preload("res://Scenes/UI/inventory_button.tscn")
@export var InventoryPreviewScene: PackedScene = preload("res://Scenes/UI/inventory_button.tscn")
@export var InventorySize: int = 5
@export var InventoryUIContainer: HBoxContainer

@export_category("Actions settings")
@export var ScaleMax: int = 20
@export var ScaleMin: int = -7
@export var ScaleFraction: float = 0.1
@export var RotationFraction: int = 64

# Inventory item definitions (singletons)

var NONE_ITEM = InventoryItem.new("none", null) # currently not holding anything
@onready var RAMP_ITEM = StructureInventoryItem.new(Ramp, "Ramp", preload("res://Visual/Backgrounds/Треугольник.png"))
@onready var CUBE_ITEM = StructureInventoryItem.new(Cube, "Cube", preload("res://Visual/Backgrounds/Квадрат.png"))
@onready var CIRCLE_ITEM = StructureInventoryItem.new(Circle, "Circle", preload("res://Visual/Backgrounds/Круг.png"))
@onready var SQUARE_ITEM = StructureInventoryItem.new(Square, "Square", preload("res://Visual/Backgrounds/Прямоугольник.png"))
@onready var RESIZE_ITEM = ActionInventoryItem.new("Resize", preload("res://Visual/UI/Размер.png"))
@onready var ROTATE_ITEM = ActionInventoryItem.new("Rotate", preload("res://Visual/UI/Форма.png"))
@onready var DELETE_ITEM = ActionInventoryItem.new("Delete", preload("res://Visual/UI/Удалить.png"))

const Pi := 3.14

var _current_item: InventoryItem = NONE_ITEM
var _scale_iterations: int = 0
var _held_item_object: Node2D = null

var _is_rotating := false
var _is_scaling := false

# first: inventory item
# second: UI button
var _inventory: Array = []

@onready var _item_roster := [
	CUBE_ITEM,
	RAMP_ITEM,
	CIRCLE_ITEM,
	ROTATE_ITEM,
	SQUARE_ITEM,
	RESIZE_ITEM,
	DELETE_ITEM,
]
var _next_roster_index := 0
var _preview_item: BaseButton 

func _ready() -> void:
	for i in _item_roster.size():
		_add_next_item_from_roster()
	_preview_item = InventoryPreviewScene.instantiate()
	_preview_item.icon = _get_next_roster_item().icon
	_preview_item.disabled = true
	InventoryUIContainer.add_child(_preview_item)

func _process(_delta: float) -> void:
	if _held_item_object != null:
		_held_item_object.position = get_global_mouse_position()

func scale_up():
	if _held_item_object == null or _scale_iterations >= ScaleMax or not _is_scaling:
		return
	_scale_iterations += 1
	for child in _held_item_object.get_children():
		child.scale += Vector2(ScaleFraction, ScaleFraction)
		_held_item_object.mass = pow(child.scale.x, 3)

func scale_down():
	if _held_item_object == null or _scale_iterations <= ScaleMin or not _is_scaling:
		return
	_scale_iterations -= 1
	for child in _held_item_object.get_children():
		child.scale -= Vector2(ScaleFraction, ScaleFraction)

func rotate_clockwise():
	if _held_item_object == null or not _is_rotating:
		return
	_held_item_object.rotation += Pi / RotationFraction

func rotate_counter():
	if _held_item_object == null or not _is_rotating:
		return
	_held_item_object.rotation -= Pi / RotationFraction

func release_item():
	if _held_item_object == null:
		return
	_held_item_object.has_collision = true
	_held_item_object.position = get_global_mouse_position()
	_held_item_object = null # we don't delete the shape, we just clear this variable!
	_scale_iterations = 0
	_is_rotating = false
	_is_scaling = false
	_current_item = NONE_ITEM

func add_item(item: InventoryItem):
	if _inventory.size() >= InventorySize:
		return
	_inventory.append(
		[item, InventoryButtonScene.instantiate()]
	)
	# TODO: initialize button here
	InventoryUIContainer.add_child(_inventory.back()[1])
	_inventory.back()[1].connect("custom_press", _inventory_button_pressed)
	_inventory.back()[1].icon = _inventory.back()[0].icon
	# update the preview's position
	if _preview_item != null:
		InventoryUIContainer.move_child(_preview_item, -1)
		_preview_item.icon = _get_next_roster_item().icon

func _inventory_button_pressed(button: InventoryButton):
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
	
	_current_item = inventory_item
	if inventory_item is StructureInventoryItem:
		_spawn_preview()
	elif inventory_item is ActionInventoryItem:
		_spawn_action_preview()

	remove_item(entry_index)

	_add_next_item_from_roster()


func remove_item(index: int):
	if index >= _inventory.size() or index < 0:
		return
	_inventory[index][1].queue_free()
	_inventory.remove_at(index)


func _add_next_item_from_roster():
	# NOTE: we need to store the item beforehand, since add_item() uses the _next_roster_index
	# and it needs it to point to the *next* item, not the one that we just added
	var item = _item_roster[_next_roster_index]
	_next_roster_index += 1
	_next_roster_index %= _item_roster.size() # restricts the index to only this array's size
	add_item(item)

func _get_next_roster_item() -> Inventory.InventoryItem:
	return _item_roster[_next_roster_index]


func _spawn_object_at_mouse(shape: PackedScene):
	var obj : Node2D = shape.instantiate()

	obj.position = get_global_mouse_position()
	return obj

func _spawn_action_preview() -> void:
	if _held_item_object != null:
		_held_item_object.queue_free()
	if _current_item == NONE_ITEM or not (_current_item is ActionInventoryItem):
		return
	print("spawning action prev")
	
	var object : BuildingStructure = _spawn_object_at_mouse(Cube) # TODO: change this to pick cubes from the ground
	object.has_collision = false
	add_child(object)
	_held_item_object = object
	match _current_item:
		DELETE_ITEM:
			# TODO: remove the block here
			print("Deleting the block that was picked up!")
			object.queue_free()
			_held_item_object = null
		RESIZE_ITEM:
			_is_scaling = true
		ROTATE_ITEM:
			_is_rotating = true
		_:
			print("Unknown action item!")

func _spawn_preview() -> void:
	if _held_item_object != null:
		_held_item_object.queue_free()
	if _current_item == NONE_ITEM:
		return
	if not (_current_item is StructureInventoryItem):
		return
	_is_scaling = true
	_is_rotating = true
	var object : BuildingStructure = _spawn_object_at_mouse(_current_item.scene_to_spawn)
	object.has_collision = false
	add_child(object)
	_held_item_object = object
