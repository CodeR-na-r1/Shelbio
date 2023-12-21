extends CharacterBody2D

@onready var death_sound = $deathSound

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false

const SPEED = 550.0

@onready var anim = $AnimatedSprite2D
var alive = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var player = $"../../Player/Player"
	
	var direction = (player.position - self.position).normalized()
	if alive == true:
		if chase == true:
			velocity.x = direction.x * SPEED
			anim.play("Go")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play("Idle")
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	move_and_slide()


func _on_detector_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_detector_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_die_body_entered(body):
	if body.name == "Player":
		if alive == true:
			body.velocity.y -= 575
		death()
		
func _on_die_2_body_entered(body):
	if body.name == "Player":
		if alive == true:
			Signals.emit_signal("playerHealthDamaged")
		death()
		
func death():
	if alive == true:
		alive = false 
		anim.play("Death")
		death_sound.play()
		await anim.animation_finished
		await death_sound.finished
		queue_free()
