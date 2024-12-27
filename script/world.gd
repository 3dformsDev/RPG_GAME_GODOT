extends Node2D

@onready var player: Player = $Player
@onready var timer_spawn_enemy: Timer = $TimerSpawnEnemy 
const ENEMY = preload("res://escenes/enemy.tscn")	
var time_second_spawn_enemy := 3

func _ready() -> void:
	timer_spawn_enemy.timeout.connect(spawn_enemy)
	timer_spawn_enemy.wait_time = time_second_spawn_enemy
	timer_spawn_enemy.start()

func spawn_enemy():
	var enemy = ENEMY.instantiate()
	
	# Generar un Angulo aleatorio en radianes (0 a 2 * PI)
	var random_angle: float = randf() * PI * 2
	# Generar una dustancia aleatoria dentro de un rango para la aparicon del enemigo.
	var spawn_distance: float = randf_range(270, 300)
	# Convertir el angulo a coordenadas cartesianas y aplicar la distancia para obtener el desplazamiento.
	var spawn_offeset: Vector2 = Vector2(cos(random_angle), sin(random_angle)) * spawn_distance
	# Establecer la psocion del enemigo basada en la posicion del jugador y el desplazamiento calculado.
	enemy.position = spawn_offeset + player.position
	
	add_child(enemy)
