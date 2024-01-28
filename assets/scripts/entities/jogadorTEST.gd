extends CharacterBody2D
#variáveis
@export var JUMP_FORCE: int = -220
@export var JUMP_RELEASE_FORCE: int = -50
@export var MAX_SPEED: int = 120
@export var ACCELERATION: int = 30
@export var FRICTION: int = 20
@export var GRAVITY: int = 5
@export var ADDITIONAL_FALL_GRAVITY: int = 8
@export var MAX_HEALTH = 3
@export var BALLOON_FALL_SPEED = 70
#Instâncias
@onready var animatedSprite = $AnimatedSprite2D
@onready var pieProjectile = preload("res://assets/prefabs/projectiles/Pie.tscn")
@onready var jump_sound = $JumpSound
@onready var yikes = $Yikes

#booleanas:
var jumpInput = false
var stunned = false
var parry = false
var unstoppableAnimation = false
var health

@export var hasBaloon = false

func _ready():
	health = MAX_HEALTH
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _physics_process(delta):
	apply_gravity()
	
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		
	if unstoppableAnimation or stunned:
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
				$ParryArea.scale.x = 1
			elif input.x < 0:
				animatedSprite.flip_h = false
				$ParryArea.scale.x = -1
					
	
	if Input.is_action_just_pressed("Pie") and not (unstoppableAnimation or stunned):
		queueAnimation("Torta", true)
		attackAnimation()
		
	if hasBaloon and Input.is_action_just_pressed("Parry") and not (unstoppableAnimation or stunned):
		queueAnimation("Parry", true)
		parryAnimation()
	
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
		
		if hasBaloon and Input.is_action_pressed("Pulo"):
			velocity.y = min(velocity.y, BALLOON_FALL_SPEED)
			if velocity.y >= 0: queueAnimation("Balao", false)
			
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
	
func parryAnimation():
	
	await $AnimatedSprite2D.frame_changed
	parry = true
	print_debug("parry")
	await $AnimatedSprite2D.frame_changed
	await $AnimatedSprite2D.frame_changed
	parry = false
	print_debug("acabou")

func queueAnimation(name, isUnstoppable):
	if unstoppableAnimation:
		await $AnimatedSprite2D.animation_finished
	unstoppableAnimation = isUnstoppable
	$AnimatedSprite2D.play(name)

func Damage(value, knockDirection):
	
	if parry:
		for body in $ParryArea.get_overlapping_bodies():
			if body.is_in_group("canHurt"):
				body.Damage(1, 1 if $AnimatedSprite2D.flip_h else -1)
		return
	yikes.play()
	health -= value
	stunned = true
	if health < 0 :
		Kill()
		return
	$Camera2D/UI/HealthBar.Damage(value)
	queueAnimation("Dano", false)
	velocity = Vector2(30*knockDirection, -50)
	set_collision_layer_value(5, false)
	await get_tree().create_timer(0.7).timeout
	stunned = false
	set_collision_layer_value(5, true)
	
func Kill():
	$Camera2D/UI/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	

