extends Button
class_name InventoryButton


signal custom_press(params: InventoryButton)

func _ready() -> void:
	pass

func _pressed() -> void:
	custom_press.emit(self)
