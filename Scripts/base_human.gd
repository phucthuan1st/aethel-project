extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Play a default animation when the character spawns
	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("idle"):
		animated_sprite.play("idle")
	else:
		# Fallback if 'idle' animation isn't found (useful during setup)
		animated_sprite.play("default")
		print("Warning: 'idle' animation not found for ", name)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if velocity.length() > 0:
		if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("walk"):
			animated_sprite.play("walk")
			
			if direction > 0: animated_sprite.flip_h = true
			if direction < 0: animated_sprite.flip_h = false
		else:
			print("Warning: 'walk' animation not found for ", name)
	else:
		if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("idle"):
			animated_sprite.play("idle")
