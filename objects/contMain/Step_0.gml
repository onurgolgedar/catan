x = room_width/2-(room_width/2-mouse_x)/3
y = room_height/2-(room_height/2-mouse_y)/3

if (periodUp) {
	if (period < 9.9)
		period += 0.1
	else {
		period = 10
		periodUp = false
	}
}
else {
	if (period > 0.1)
		period -= 0.1
	else {
		period = 0
		periodUp = true
	}
}

if (global.continueToggle) {
	global.time += 1
	global.gameStep_time += (global.gameStep_ready == global.gameStep)
	global.sync_time += (global.gameStep_ready != global.gameStep)
}

global.totalTime = global.gameStep_time+global.sync_time
	
if (!global.stopGame and (global.gameStep > 1 and global.totalTime > 10*sec or global.totalTime > 30*sec)) {
	show_message_async("Time out!")
	
	ini_open("games.ini")
		var experimentName = "Game "+string(global.gameNo)
		ini_write_string(experimentName, "Winner", -1)
		ini_write_string(experimentName, "Winner.StrategyAgent", "null")
		ini_write_string(experimentName, "Winner.NegotiationAgent", "null")
		ini_write_string(experimentName, "Winner.Name", "null")
		ini_write_string(experimentName, "Time(s)", global.time/60)
		ini_write_string(experimentName, "Turn", global.turn)
			
		for (var i = 1; i <= PLAYER_COUNT; i++) {
			ini_write_string(experimentName, "P"+string(i)+".NegotiationAgreements", global.negotiationAgreements[i])
			ini_write_string(experimentName, "P"+string(i)+".VictoryPoint(s)", global.playerScore[i])
			ini_write_string(experimentName, "P"+string(i)+".TradeWithBank(s)", global.tradeBanks[i])
		}
	ini_close()
		
	game_restart()
}