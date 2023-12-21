extends Area2D

@onready var collect_sound = $collectSound

func _on_body_entered(body):
	if body.name == "Player": 
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 100), 0.2)
		tween1.tween_property(self, "modulate:a", 0, 0.2)
		tween.tween_callback(queue_free)
		body.whiskey += 1
		collect_sound.play()
		await collect_sound.finished
