extends Node

export var max_health = 1 
onready var health = max_health setget update_health

signal no_health

func update_health(_health):
	health -= _health
	if health <= 0:
		emit_signal("no_health")
