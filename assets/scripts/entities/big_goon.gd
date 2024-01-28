extends CharacterBody2D

@export var MAX_SPEED: int = 30
@export var FRICTION: int = 10
@export var MAX_HEALTH = 5
@export var GRAVITY = 980
@export var CHARGE_COOLDOWN = 5
@export var CHARGE_MAX_SPEED = 200
@export var CHARGE_ACCELERATION = 1

@onready var sightRight = $"Sight Right"
@onready var sightLeft = $"Sight Left"

var direction = -1
var speed
var stunned = false
var canCharge = true
var isCharging = false
var health

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	health = MAX_HEALTH
	speed = MAX_SPEED

func _physics_process(delta):
	
	if canCharge:
		
		if sightRight.is_colliding() and sightRight.get_collider().is_in_group("player"):
			direction = 1
			Attack()
			
		elif sightLeft.is_colliding() and sightLeft.get_collider().is_in_group("player"):
			direction = -1
			Attack()
	elif speed <= CHARGE_MAX_SPEED and isCharging:
		speed += CHARGE_ACCELERATION
		$AnimatedSprite2D.speed_scale+= 0.005
	
	move_and_slide()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if not isCharging: velocity.x = lerpf(velocity.x, velocity.normalized().x * MAX_SPEED, 0.1)
		
	if stunned: return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = direction * speed
	$AnimatedSprite2D.flip_h = direction==1

	

func Damage(value, knockDirection):
	
	if isCharging: return
	
	health -= value
	stunned = true
	if health < 0 :
		Kill()
		return
	$AnimatedSprite2D.play("Dano")
	velocity = Vector2(100*knockDirection, -50)
	set_collision_layer_value(1, false)
	await get_tree().create_timer(1).timeout
	stunned = false
	if not isCharging: $AnimatedSprite2D.play("Andando")
	set_collision_layer_value(1, true)
	

func Kill():
	
	$AnimatedSprite2D.play("Morte")
	velocity = Vector2(0, -20)
	GRAVITY = 20
	await get_tree().create_timer(0.5).timeout
	queue_free()

func Attack():
	
	set_collision_layer_value(1, false)
	$Step.play()
	isCharging = true
	canCharge = false
	speed = 0
	$AnimatedSprite2D.play("Charge")
	$AnimatedSprite2D.speed_scale = 0.5
	$ChargeHitbox.monitoring = true
	
func Stun():
	
	$Step.stop()
	$Hit.play()
	set_collision_layer_value(1, true)
	$ChargeHitbox.monitoring = false
	isCharging = false
	speed = 0
	stunned = true
	$AnimatedSprite2D.play("Paralizado")
	$AnimatedSprite2D.speed_scale = 0.5
	velocity = Vector2(-100*direction, -50)
	await get_tree().create_timer(2).timeout
	stunned = false
	$AnimatedSprite2D.play("Parado")
	await get_tree().create_timer(CHARGE_COOLDOWN).timeout
	$AnimatedSprite2D.speed_scale = 1
	speed = MAX_SPEED
	$AnimatedSprite2D.play("Andando")
	canCharge = true

func _on_ledge_left(_body):
	if not isCharging: direction = 1
	
func _on_ledge_right(_body):
	if not isCharging: direction = -1


func _on_wall_left(_body):
	if isCharging and direction == -1: 
		Stun()
		return
	direction = 1

func _on_wall_right(_body):
	if isCharging and direction == 1:
		Stun()
		return
	direction = -1


func _on_charge_hitbox_body_entered(body):
	if body.is_in_group("player"): body.Damage(1, direction)
