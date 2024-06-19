extends Node2D

@onready var label: Label = $Label
@export var text = "1"

var occupancy: int

func _ready():
	label.text = text
	occupancy = 0
