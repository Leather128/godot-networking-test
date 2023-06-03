extends Camera2D

@onready var target: Node2D = null

func _physics_process(delta: float) -> void:
	if target == null:
		return
	position = lerp(position, target.position - Vector2(0.0, 64.0), delta * 4.0)
