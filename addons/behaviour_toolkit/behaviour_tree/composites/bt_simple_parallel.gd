@icon("res://addons/behaviour_toolkit/icons/BTSimpleParallel.svg")
class_name BTSimpleParallel extends BTComposite


enum ParallelPolicy {
	SUCCESS_ON_ALL,		## Returns SUCCESS if all children return SUCCESS.
	SUCCESS_ON_ONE		## Returns SUCCESS if any child returns SUCCESS.
}


## Select when to return SUCCESS.
@export var policy: ParallelPolicy = ParallelPolicy.SUCCESS_ON_ALL
## If true, children that have already returned SUCCESS will not be ticked again, until one of the children returns FAILURE or the composite is reset.
@export var synchronize: bool = false


@onready var responses: Array = _init_array()


func tick(actor: Node, blackboard: Blackboard):
	var leave_counter = 0
	for leave in leaves:
		if synchronize and responses[leave_counter] == Status.SUCCESS:
			leave_counter += 1
			continue

		var response = leave.tick(actor, blackboard)
		responses[leave_counter] = response
		leave_counter += 1

		if response == Status.FAILURE:
			response = _init_array()
			return Status.FAILURE

	match policy:
		ParallelPolicy.SUCCESS_ON_ALL:
			for response in responses:
				if response == Status.FAILURE:
					responses = _init_array()
					return Status.FAILURE
			
			responses = _init_array()
			return Status.SUCCESS
		ParallelPolicy.SUCCESS_ON_ONE:
			for response in responses:
				if response == Status.SUCCESS:
					responses = _init_array()
					return Status.SUCCESS
			
			responses = _init_array()
			return Status.FAILURE


func _init_array():
	var array = []
	for leave in leaves:
		array.append(null)

	return array
