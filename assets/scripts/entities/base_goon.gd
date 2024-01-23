extends CharacterBody2D

@export var MAX_SPEED: int = 50
@export var FRICTION: int = 10

var direction = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = direction * MAX_SPEED
	$AnimatedSprite2D.flip_h = direction==1

	move_and_slide()
	

func Damage(value):
	pass

func _on_ledge(body):
	direction = -direction


func _on_wall(body):
	direction = -direction
