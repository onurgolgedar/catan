ini_open("longest_roads.ini")
	for (var i = 0; i < PLAYER_COUNT; i++)
		global.longestRoad[i+1] = ini_read_real("LongestRoad", "Player["+string(i)+"]", 0)
ini_close()

longestRoad_value = -1
longestRoad_owner = -1
knights_value = -1
knights_owner = -1

for (var i = 0; i <= PLAYER_COUNT; i++) {
	var beforeI = i
	if (beforeI == 0)
		i = global.player_active
		
	if (global.longestRoad[i] > 4 and global.longestRoad[i] > longestRoad_value and (global.oldLongestRoad_owner == -1 or (i == global.oldLongestRoad_owner and global.longestRoad[i] >= global.longestRoad[global.oldLongestRoad_owner]) or global.longestRoad[i] > global.longestRoad[global.oldLongestRoad_owner])) {
		longestRoad_value = global.longestRoad[i]
		
		longestRoad_owner = i		
		global.oldLongestRoad_owner = i
	}
			
	if (global.knights[i] > 2 and global.knights[i] > knights_value and (global.oldKnights_owner == -1 or (i == global.oldKnights_owner and global.knights[i] >= global.knights[global.oldKnights_owner]) or global.knights[i] > global.knights[global.oldKnights_owner])) {
		knights_value = global.knights[i]
		
		knights_owner = i
		global.oldKnights_owner = i
	}
	
	i = beforeI
}

global.longestRoad_owner = longestRoad_owner
global.knights_owner = knights_owner

for (var i = 1; i <= PLAYER_COUNT; i++) {
	global.playerScore[i] = structure_count(i, objSettlement)
	global.playerScore[i] += structure_count(i, objCity)*2
		
	if (global.longestRoad_owner == i)
		global.playerScore[i] += 2
			
	if (global.knights_owner == i)
		global.playerScore[i] += 2
			
	global.playerScore[i] += global.victoryCards[i]
}
	
for (var i = 1; i <= PLAYER_COUNT; i++) {
	if (global.playerScore[i] >= MAX_SCORE) {
		global.stopGame = true
		global.winnerPlayer = i
		
		if (global.continueToggle and global.gameNo < 500)
			contMain.alarm[8] = 2*sec
		else
			game_end()
			
		break
	}
}