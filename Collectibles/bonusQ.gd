extends Area2D

@onready var collect_sound = $collectSound

var isActivate = false

func _on_body_entered(body):
	if body.name == "Player": 
		if isActivate == false:
			collect_sound.play()
			
			var coords = self.position
			Signals.emit_signal("playerCollectBonus", coords)
			
			isActivate = true
			
			var tween = get_tree().create_tween()
			var tween1 = get_tree().create_tween()
			tween.tween_property(self, "position", position - Vector2(0, 100), 0.2)
			tween1.tween_property(self, "modulate:a", 0, 0.2)
			
			await collect_sound.finished
			tween.tween_callback(queue_free)
			
			isActivate = false
			queue_free()
