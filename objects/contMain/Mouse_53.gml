if (contDraw.mouseOn_dice and global.player_active == global.human and can_dice())
	roll_dice(1+irandom(5), 1+irandom(5))

#region Moves
if (global.player_active == global.human or global.debugMode)
{
	
if (global.initialPhase and !global.debugMode) {
	if (is_holding(objSettlement)) {
		var nearestLocation = instance_nearest(mouse_x, mouse_y, objLocation)
		var isCreated = create(global.human, objSettlement, nearestLocation)
		
		if (isCreated) {
			leave_held()
			take(objRoad)
		}
	}
	else if (is_holding(objRoad)) {
		var nearestLocation
		nearestLocation[0] = instance_nearest(mouse_x, mouse_y, objLocation)
		nearestLocation[1] = instance_nth_nearest(mouse_x, mouse_y, objLocation, 2)

		var isCreated = create(global.human, objRoad, nearestLocation[0], nearestLocation[1])
		
		if (isCreated) {
			leave_held()
				
			turn_end()
		}
	}
}
else if (global.robberAddition_mode) {
	var nearestLand = instance_nearest(mouse_x, mouse_y, objLand)
	
	if (nearestLand.type != ltype_sea)
		move_robber(global.human, nearestLand)
}
else {
	if (is_holding(objSettlement)) {
		var nearestLocation = instance_nearest(mouse_x, mouse_y, objLocation)
		var isCreated = create(global.human, objSettlement, nearestLocation)
		
		if (isCreated) {
			leave_held()
		}
	}
	else if (is_holding(objRoad)) {
		var nearestLocation
		nearestLocation[0] = instance_nearest(mouse_x, mouse_y, objLocation)
		nearestLocation[1] = instance_nth_nearest(mouse_x, mouse_y, objLocation, 2)

		var isCreated = create(global.human, objRoad, nearestLocation[0], nearestLocation[1])
		
		if (isCreated) {
			leave_held()
		}
	}
	else if (is_holding(objCity)) {
		var nearestLocation = instance_nearest(mouse_x, mouse_y, objLocation)
		var isUpgraded = upgrade(global.human, nearestLocation)
		
		if (isUpgraded) {
			leave_held()
		}
	}
}
global.debugMode = false

}
#endregion