extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -800.0

var runSpeed = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# vars for animation
@onready var anim = $AnimatedSprite2D
@onready var damageSound = $damageSound

var maxHealth = 5
var health: int
var whiskey = 0

func _ready():
	health = maxHealth
	Signals.connect("playerHealthDamaged", Callable(self, "_onPlayerHealthDamaged"))
	Signals.connect("playerHealthIncrement", Callable(self, "_playerHealthIncremented"))

func _onPlayerHealthDamaged():
	health -= 1
	Signals.emit_signal("playerHealthChanged", health)
	damageSound.play()
	await damageSound.finished
	
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://Game/menu.tscn")
		
func _playerHealthIncremented():
	if health < maxHealth:
		health += 1
		Signals.emit_signal("playerHealthChanged", health)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("run"):
		runSpeed = 2
	else:
		runSpeed = 1

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * runSpeed
		if velocity.y == 0:
			anim.play("Go")	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")

	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false
		
	if velocity.y > 0:
		anim.play("Fall")
		
	move_and_slide()
