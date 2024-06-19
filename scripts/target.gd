extends Node2D

@onready var label: Label = $Label
@export var text = "1"

func _ready():
	label.text = text
