extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var bubble_timer: Timer = $BubbleTimer
@onready var thinking_timer: Timer = $ThinkingTimer
@onready var switch_timer: Timer = $SwitchTimer
@onready var thinking_bubble: ColorRect = $ThinkingBubble
@onready var label: Label = $ThinkingBubble/Label

@export var accel = 9

var target: Node2D
const SPEED = 125.0


func _ready():
	# initialize timer to random value
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var rand_wait: float = rng.randf_range(0.5, 2.5)
	timer.wait_time = rand_wait
	timer.start()


func _physics_process(delta):
	# get next waypoint
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	
	if target:
		var distance = self.global_position - target.global_position
		if distance.length() > 20:
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
	else:
		velocity = direction * SPEED
	# velocity = velocity.lerp(direction * SPEED, accel * delta)

	move_and_slide()


func make_path(t):
	nav_agent.target_position = t.global_position


func choose_target():
	# get all targets
	var targets = get_tree().get_nodes_in_group("targets")
	
	# chose random target
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var i: int = rng.randi_range(0, len(targets)-1)
	var chosen_target = targets[i]
	
	## check if already chosen by other baby
	#if chosen_target.is_chosen:
		#pass
	#else:
		#return chosen_target
	return chosen_target


func find_closest_target():
	var targets = get_tree().get_nodes_in_group("targets")
	# start with first target as closest
	var nearest_target = targets[0]
	
	# look through spawn nodes to see if any are closer
	for t in targets:
		if t.global_position.distance_to(self.global_position) < nearest_target.global_position.distance_to(self.global_position):
			nearest_target = t
	return nearest_target


func _on_timer_timeout():
	target = choose_target()
	thinking_timer.stop()
	label.text = target.text
	bubble_timer.start()
	#var target = find_closest_target()
	make_path(target)


func _on_bubble_timer_timeout():
	thinking_bubble.visible = false


func _on_thinking_timer_timeout():
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var targets = get_tree().get_nodes_in_group("targets")
	var i: int = rng.randi_range(0, len(targets)-1)
	label.text = str(i)


func _on_switch_timer_timeout():
	# random chance to switch targets
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var rand_i: int = rng.randi_range(0, 5)
	if rand_i == 1:
		var rand_wait: float = rng.randf_range(0.5, 2.5)
		timer.wait_time = rand_wait
		timer.start()
		thinking_timer.start()
		thinking_bubble.visible = true
