extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jump_max = 0
var jump_count = 0

func _physics_process(delta):
	#animations
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else: 
		sprite_2d.animation = "default"
			
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jumping"
	# Handle Jump.
	if Input.is_action_just_pressed("P2 Jump") and jump_count<=jump_max:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		
	#resting jump count
	if is_on_floor() and jump_count!=0:
		jump_count = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("P2 Left", "P2 Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 30) 

	move_and_slide()

	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft

