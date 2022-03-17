extends KinematicBody2D

var knockback = Vector2.ZERO

onready var stats = $Stats

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 5.0)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * 150.0
	stats.update_health(area.damage)


func _on_Stats_no_health():
	queue_free()
