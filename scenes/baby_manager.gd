extends Node

@onready var targets = get_tree().get_nodes_in_group("targets")


func get_target(curr_target):
	# get available targets
	if curr_target:
		curr_target.occupancy -= 1
	var available_targets = []
	for target in targets:
		if target.occupancy < 2:
			available_targets.append(target)
	# chose random target
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var i: int = rng.randi_range(0, len(available_targets)-1)
	available_targets[i].occupancy += 1
	return available_targets[i]
