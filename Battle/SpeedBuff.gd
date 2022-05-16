extends Area2D

func _on_SpeedBuff_area_entered(area):
	if not owner is Tower: return

func _on_SpeedBuff_area_exited(area):
	if not owner is Tower: return
