@icon("res://addons/behaviour_toolkit/icons/BTDecoratorNot.svg")
class_name BTInverter extends BTDecorator
## The result of the leaf is inverted.


func tick(actor: Node, blackboard: Blackboard):
    var response = leaf.tick(actor, blackboard)

    if response == BTStatus.SUCCESS:
        return BTStatus.FAILURE
    
    if response == BTStatus.FAILURE:
        return BTStatus.SUCCESS

    return BTStatus.RUNNING
