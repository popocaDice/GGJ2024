extends CharacterBody2D

@export var MAX_SPEED: int = 50
@export var FRICTION: int = 10
@export var MAX_HEALTH = 3
@export var GRAVITY = 980
@onready var damage_taken = $DamageTaken

var direction = -1
var stunned = false
var health

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	health = MAX_HEALTH

func _physics_process(delta):
	
	move_and_slide()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	velocity.x = lerpf(velocity.x, velocity.normalized().x * MAX_SPEED, 0.1)
		
	if stunned: return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = direction * MAX_SPEED
	$AnimatedSprite2D.flip_h = direction==1

	

func Damage(value, knockDirection):
	
	health -= value
	stunned = true
	damage_taken.play()
	if health < 0 :
		Kill()
		return
	$AnimatedSprite2D.play("Dano")
	velocity = Vector2(100*knockDirection, -50)
	set_collision_layer_value(1, false)
	await get_tree().create_timer(1).timeout
	stunned = false
	$AnimatedSprite2D.play("Andando")
	set_collision_layer_value(1, true)
	

func Kill():
	$AnimatedSprite2D.play("Morte")
	velocity = Vector2(0, -20)
	GRAVITY = 20
	await get_tree().create_timer(0.5).timeout
	queue_free()

func Attack():
	stunned = true
	$AnimatedSprite2D.play("Ataque")
	await get_tree().create_timer(0.2).timeout
	if $AnimatedSprite2D.flip_h:
		for body in $"AttackAreaRight".get_overlapping_bodies():
			if body.is_in_group("player"): body.Damage(1, 1 if $AnimatedSprite2D.flip_h else -1)
	else:
		for body in $"AttackAreaLeft".get_overlapping_bodies():
			if body.is_in_group("player"): body.Damage(1, 1 if $AnimatedSprite2D.flip_h else -1)
	await get_tree().create_timer(1).timeout
	stunned = false
	$AnimatedSprite2D.play("Andando")

func _on_ledge_left(_body):
	direction = 1
	
func _on_ledge_right(_body):
	direction = -1


func _on_wall_left(_body):
	direction = 1

func _on_wall_right(_body):
	direction = -1


func _on_attack_area_left(body):
	if body.is_in_group("player") and not stunned:
		velocity.x = 0
		$AnimatedSprite2D.flip_h = false
		Attack()
		
func _on_attack_area_right(body):
	if body.is_in_group("player") and not stunned:
		velocity.x = 0
		$AnimatedSprite2D.flip_h = true
		Attack()
