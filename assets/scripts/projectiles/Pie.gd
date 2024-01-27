extends RigidBody2D

@export var speed = 20.0
@export var damage = 1.0
@onready var pie_hit = $PieHit

var direction
var hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	
func Throw():
	direction = 1 if $AnimatedSprite2D.flip_h else -1
	apply_central_impulse(Vector2(speed * direction, -50))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hit:
		freeze = true
		$AnimatedSprite2D.modulate.a -= delta/3
		if $AnimatedSprite2D.modulate.a <= 0:
			queue_free()


func _on_area_2d_body_entered(body):
	linear_velocity = Vector2.ZERO
	hit = true
	$AnimatedSprite2D.play("splash")
	pie_hit.play()
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
	$AnimatedSprite2D.offset.x += 7*direction
	$Area2D.call_deferred("queue_free")
	
	if body.is_in_group("canHurt"):
		
		body.Damage(damage, direction)
		
	if body.is_in_group("door"):
		
		print_debug("porta")
		body.Open(direction)
		
	call_deferred("reparent", body)
