ini_open("longest_roads.ini")
	for (var i = 0; i < PLAYER_COUNT; i++)
		global.longestRoad[i+1] = ini_read_real("LongestRoad", "Player["+string(i)+"]", 0)
ini_close()

for (var i = 0; i <= PLAYER_COUNT; i++) {
	var beforeI = i
	if (beforeI = 0)
		i = global.player_active
		
	if (global.longestRoad[i] > 4 and global.longestRoad[i] > global.longestRoad_value and (global.oldLongestRoad_owner == -1 or (i == global.oldLongestRoad_owner and global.longestRoad >= global.oldLongestRoad_value) or global.longestRoad[i] > global.longestRoad[global.oldLongestRoad_owner])) {
		global.longestRoad_owner = i
		global.longestRoad_value = global.longestRoad[i]
		
		global.oldLongestRoad_owner = i
		global.oldLongestRoad_value = global.longestRoad[i]
	}
			
	if (global.knights[i] > 2 and global.knights[i] > global.knights_value and (global.oldKnights_owner == -1 or (i == global.oldKnights_owner and global.knights[i] >= global.oldKnights_value) or global.knights[i] > global.knights[global.oldKnights_owner])) {
		global.knights_owner = i
		global.knights_value = global.knights[i]
		
		global.oldKnights_owner = i
		global.oldKnights_value = global.knights[i]
	}
	
	i = beforeI
}

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
		
		if (global.continueToggle and global.gameNo < 250)
			contMain.alarm[8] = 2*sec
		else
			game_end()
			
		break
	}
}