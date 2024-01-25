extends CharacterBody2D
@export var JUMP_FORCE: int = -130
@export var JUMP_RELEASE_FORCE: int = -70
@export var MAX_SPEED: int = 50
@export var ACCELERATION: int = 10
@export var FRICTION: int = 10
@export var GRAVITY: int = 4
@export var ADDITIONAL_FALL_GRAVITY: int = 4
@export var MAX_HEALTH = 3

@onready var animatedSprite = $AnimatedSprite2D
@onready var pieProjectile = preload("res://assets/prefabs/projectiles/Pie.tscn")
@onready var jump_sound = $JumpSound

var jumpInput = false
var attack = false
var stunned = false
var unstoppableAnimation = false
var health

func _ready():
	health = MAX_HEALTH
	
func _physics_process(delta):
	apply_gravity()
	
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		
	if attack or stunned:
		input = Vector2.ZERO
	
	if not stunned:
		if input.x == 0:	
			apply_friction()
			queueAnimation("Parado", false)
		else:
			apply_acceleration(input.x)
			queueAnimation("Andando", false)
			if input.x > 0:
				animatedSprite.flip_h = true
			elif input.x < 0:
				animatedSprite.flip_h = false
					
	
	if Input.is_action_just_pressed("Pie") and not (attack or stunned):
		queueAnimation("Torta", true)
		attack = true
		attackAnimation()
	
	if is_on_floor():
		jumpInput = false
		if Input.is_action_just_pressed("Pulo") and not stunned:
			velocity.y = JUMP_FORCE
			jump_sound.play()
			jumpInput = true
	elif not stunned:
		queueAnimation("Pulo", false)
		if Input.is_action_just_released("Pulo") and jumpInput and velocity.y <= JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
			jumpInput = false

		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
	var was_in_air = is_on_floor()
	move_and_slide()
	var just_landed = is_on_floor() and not was_in_air
	if just_landed and not stunned:
		queueAnimation("Andando", false)
		
func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 300)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)

func attackAnimation():
	
	await get_tree().create_timer(0.2).timeout
	var pie = pieProjectile.instantiate()
	get_tree().root.add_child(pie)
	pie.global_position = global_position + Vector2(0, -5)
	pie.get_child(0).flip_h = $AnimatedSprite2D.flip_h
	pie.Throw()
	await get_tree().create_timer(0.3).timeout
	attack = false

func queueAnimation(name, isUnstoppable):
	if unstoppableAnimation:
		await $AnimatedSprite2D.animation_finished
	unstoppableAnimation = isUnstoppable
	$AnimatedSprite2D.play(name)

func Damage(value, knockDirection):
	
	health -= value
	stunned = true
	if health < 0 :
		Kill()
		return
	queueAnimation("Dano", false)
	velocity = Vector2(30*knockDirection, -50)
	set_collision_layer_value(5, false)
	await get_tree().create_timer(0.7).timeout
	stunned = false
	set_collision_layer_value(5, true)
	
func Kill():
	pass
	

