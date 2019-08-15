ini_open("environment.ini")
	for (var i = !global.fourBot_mode; i < PLAYER_COUNT; i++) {
		ini_write_string("StrategyAgents", i, global.strategyAI[i+1])
		ini_write_string("NegotiationAgents", i, global.negotiationAI[i+1])
	}
ini_close()

room_goto(roomMain)