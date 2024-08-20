extends Node2D
class_name Inventory


class InventoryItem:
	
	var price := 1
	var text: String
	var icon: CompressedTexture2D
	func _init(name: String, img: CompressedTexture2D, new_price:int) -> void:
		text = name
		icon = img
		price = new_price

class StructureInventoryItem extends InventoryItem:
	var scene_to_spawn: PackedScene

	func _init(scene: PackedScene, name: String, img: CompressedTexture2D, new_price:int) -> void:
		scene_to_spawn = scene
		text = name
		icon = img
		price = new_price

class ActionInventoryItem extends InventoryItem:
	pass
	

static var Ramp: PackedScene = preload("res://Scenes/ramp.tscn")
static var Eg: PackedScene = preload("res://Scenes/eg.tscn")
static var Penta: PackedScene = preload("res://Scenes/penta.tscn")
static var Cube: PackedScene = preload("res://Scenes/cube.tscn")
static var Circle: PackedScene = preload("res://Scenes/circle.tscn")
static var Square: PackedScene = preload("res://Scenes/square.tscn")
static var Delete: PackedScene = preload("res://Scenes/delete.tscn")
static var ActionPreviewScene: PackedScene = preload("res://Scenes/UI/action_preview.tscn")

@export_category("Inventory")
@export var InventoryButtonScene: PackedScene = preload("res://Scenes/UI/inventory_button.tscn")
@export var InventoryPreviewScene: PackedScene = preload("res://Scenes/UI/inventory_button.tscn")
@export var InventorySize: int = 3
@export var InventoryUIContainer: HBoxContainer

@export_category("Actions settings")
@export var ScaleMax: int = 20
@export var ScaleMin: int = -7
@export var ScaleFraction: float = 0.1
@export var RotationFraction: int = 64

# Inventory item definitions (singletons)

static var NONE_ITEM = InventoryItem.new("none", null,1) # currently not holding anything
static var RAMP_ITEM = StructureInventoryItem.new(Ramp, "Ramp", preload("res://Visual/Backgrounds/Треугольник.png"),2)
static var CUBE_ITEM = StructureInventoryItem.new(Cube, "Cube", preload("res://Visual/Backgrounds/Квадрат.png"),2)
static var CIRCLE_ITEM = StructureInventoryItem.new(Circle, "Circle", preload("res://Visual/Backgrounds/Круг.png"),4)
static var SQUARE_ITEM = StructureInventoryItem.new(Square, "Square", preload("res://Visual/Backgrounds/Прямоугольник.png"),3)
static var PENTA_ITEM = StructureInventoryItem.new(Penta, "Penta", preload("res://Visual/Backgrounds/Пятиугольник.png"),1)
static var EG_ITEM = StructureInventoryItem.new(Eg, "Eg", preload("res://Visual/Backgrounds/Деревянный еж.png"),4)
static var RESIZE_ITEM = ActionInventoryItem.new("Resize", preload("res://Visual/UI/Размер.png"),2)
static var ROTATE_ITEM = ActionInventoryItem.new("Rotate", preload("res://Visual/UI/Форма.png"),2)
static var DELETE_ITEM = ActionInventoryItem.new("Delete", preload("res://Visual/UI/Удалить.png"),1)

const Pi := 3.14

var _current_item: InventoryItem = NONE_ITEM
var _scale_iterations: int = 0
var _held_item_object: Node2D = null

var _is_rotating := false
var _is_scaling := false
var _should_hold_structure := true
var _can_switch_items := true

# first: inventory item
# second: UI button
var _inventory: Array = []

@onready var _item_roster := [
	PENTA_ITEM,
	CUBE_ITEM,
	DELETE_ITEM
]
func add_to_roster(level):
	match level:
		3:_item_roster.append(SQUARE_ITEM)
		4:_item_roster.append(RESIZE_ITEM)
		5:_item_roster.append(RAMP_ITEM)
		6:
			_item_roster.append(CIRCLE_ITEM)
			_item_roster.append(ROTATE_ITEM)
		8:_item_roster.append(EG_ITEM)
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
	if _held_item_object != null and _should_hold_structure:
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
	#_held_item_object.rotation += Pi / RotationFraction
	_held_item_object.rotate_physically(Pi / RotationFraction)

func rotate_counter():
	if _held_item_object == null or not _is_rotating:
		return
	#_held_item_object.rotation -= Pi / RotationFraction
	_held_item_object.rotate_physically(-Pi / RotationFraction)

# i want to kill this function with fire
func release_item():
	if _held_item_object == null:
		return
	if _current_item is StructureInventoryItem:
		_release_and_reset()
	elif _current_item is ActionInventoryItem:
		if _held_item_object is BuildingStructure or not is_instance_valid(_held_item_object):
			_release_and_reset()
			return
		var structures = _held_item_object.get_overlapping_bodies()
		var hit_something := false
		for structure in structures:
			if not (structure is BuildingStructure):
				continue
			hit_something = true
			match _current_item:
				DELETE_ITEM:
					structure.queue_free()
					# don't break, we're removing each building!
				ROTATE_ITEM:
					if _held_item_object != null:
						_held_item_object.queue_free()
					_held_item_object = structure
					_held_item_object.has_collision = false
					_is_rotating = true
					_is_scaling = false
					_should_hold_structure = false
					_can_switch_items = false
					return
				RESIZE_ITEM:
					if _held_item_object != null:
						_held_item_object.queue_free()
					_held_item_object = structure
					_is_rotating = false
					_is_scaling = true
					_should_hold_structure = false
					_can_switch_items = false
					return
		# clean up the decal after action is done
		_release_and_reset(true)

func _release_and_reset(remove_object: bool = false):
	if _held_item_object is BuildingStructure:
		_held_item_object.has_collision = true
		$"../..".resource-=_current_item.price
		$"../../UI/ResourceLabel/RichTextLabel".text = str($"../..".resource)
	if remove_object and _held_item_object != null:
		$"../..".resource-=_current_item.price
		$"../../UI/ResourceLabel/RichTextLabel".text = str($"../..".resource)
		_held_item_object.queue_free()
	_held_item_object = null # we don't delete the shape, we just clear this variable!
	_scale_iterations = 0
	_is_rotating = false
	_is_scaling = false
	_can_switch_items = true
	_current_item = NONE_ITEM


func add_item(item: InventoryItem, index: int = -1):
	if _inventory.size() >= InventorySize:
		return
	if index < 0:
		index += _inventory.size() if _inventory.size() != 0 else 1
	if _inventory.insert(
		index,
		[item, InventoryButtonScene.instantiate()]
	) != OK:
		print("Error inserting item!!! (Bug)")
		return
	var new_item = _inventory[index]
	InventoryUIContainer.add_child(new_item[1])
	InventoryUIContainer.move_child(new_item[1], index)
	new_item[1].connect("custom_press", _inventory_button_pressed)
	new_item[1].icon = new_item[0].icon
	# update the preview's position
	if _preview_item != null:
		InventoryUIContainer.move_child(_preview_item, -1)
		_preview_item.icon = _get_next_roster_item().icon

func select_item(index: int):
	if index < 0 or index >= _inventory.size():
		return
	_inventory_button_pressed(_inventory[index][1])

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
	
	# switching here
	if _current_item != NONE_ITEM and is_instance_valid(_held_item_object):
		if not _can_switch_items:
			return # do nothing if we can't switch items
		remove_item(entry_index)
		var saved_item = _current_item
		_release_and_reset(true)
		add_item(saved_item, entry_index)
	else:
		remove_item(entry_index)
		_add_next_item_from_roster()

	_current_item = inventory_item
	if inventory_item is StructureInventoryItem:
		_spawn_preview()
	elif inventory_item is ActionInventoryItem:
		_spawn_action_preview()


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
	_is_scaling = false
	_is_rotating = false
	_should_hold_structure = true
	if _held_item_object != null:
		_held_item_object.queue_free()
	if _current_item == NONE_ITEM or not (_current_item is ActionInventoryItem):
		return
	
	var object = _spawn_object_at_mouse(ActionPreviewScene)
	add_child(object)
	_held_item_object = object

func _spawn_preview() -> void:
	if _held_item_object != null:
		_held_item_object.queue_free()
	if _current_item == NONE_ITEM:
		return
	if not (_current_item is StructureInventoryItem):
		return
	_is_scaling = true
	_is_rotating = true
	_should_hold_structure = true
	var object : BuildingStructure = _spawn_object_at_mouse(_current_item.scene_to_spawn)
	object.has_collision = false
	add_child(object)
	_held_item_object = object
