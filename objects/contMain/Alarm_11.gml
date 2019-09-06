/// @desc AI Loop

var moveDone = false
alarm[11] = 1

ini_open("communication.ini")
	if (global.player_active != global.human and is_turn_ready() and (keyboard_check(ord("C")) or global.continueToggle)) {
		moveDone = ini_read_string("General", "turnMode["+string(global.player_active-1)+"]", "normal") == "done"
		and file_exists("actions_agentPlatform_"+string(global.player_active-1)+".txt")
	}
ini_close()

if (moveDone) {
	#region TAKE ACTIONS
	var actionList_file = file_text_open_read("actions_agentPlatform_"+string(global.player_active-1)+".txt")
		
	var line = file_text_readln(actionList_file)

	while (string_length(line) > 3) {
		var actionParams = ds_list_create()
		var playerIndex = real(string_char_at(line, 2))
        var actionType = string_copy(line, 5, 2)

        var value = 8
        while (value < string_length(line)-3) {
            ds_list_add(actionParams, real(string_copy(line, value, 2)))
				
            value += 3
        }

        var objectType = string_char_at(line, string_length(line)-2)
			
        switch (actionType) {
            case "CR":
                if (objectType == "S") {
					var isCreated = create(playerIndex, objSettlement, ds_list_find_value(global.locations, ds_list_find_value(actionParams, 0)))
					and (ds_grid_get(global.resources, playerIndex, resource_brick) >= 1
					and ds_grid_get(global.resources, playerIndex, resource_lumber) >= 1
					and ds_grid_get(global.resources, playerIndex, resource_grain) >= 1
					and ds_grid_get(global.resources, playerIndex, resource_wool) >= 1
					or global.initialPhase)
						
					if (isCreated and !global.initialPhase) {
						change_resource(playerIndex, resource_brick, -1)
						change_resource(playerIndex, resource_lumber, -1)
						change_resource(playerIndex, resource_grain, -1)
						change_resource(playerIndex, resource_wool, -1)
					}
					else if (!isCreated)
						show_message(objectType + " could not be created.")
                } else if (objectType == "R") {
                    var isCreated = create(playerIndex, objRoad, ds_list_find_value(global.locations, ds_list_find_value(actionParams, 0)), ds_list_find_value(global.locations, ds_list_find_value(actionParams, 1)))
                    and (ds_grid_get(global.resources, playerIndex, resource_brick) >= 1
					and ds_grid_get(global.resources, playerIndex, resource_lumber) >= 1
					or global.initialPhase)
					
					if (isCreated and !global.initialPhase) {
						change_resource(playerIndex, resource_brick, -1)
						change_resource(playerIndex, resource_lumber, -1)
					}
					else if (!isCreated)
						show_message(objectType + " could not be created.")
				}
                break
            case "UP":
                if (objectType == "S") {
                    var isUpgraded = upgrade(playerIndex, ds_list_find_value(global.locations, ds_list_find_value(actionParams, 0)))
					and (ds_grid_get(global.resources, playerIndex, resource_ore) >= 3
					and ds_grid_get(global.resources, playerIndex, resource_grain) >= 2
					or global.initialPhase)
						
					if (isUpgraded and !global.initialPhase) {
						change_resource(playerIndex, resource_ore, -3)
						change_resource(playerIndex, resource_grain, -2)
					}
					else if (!isUpgraded)
						show_message(objectType + " could not be upgraded.")
                }
                break
            case "MO":
                if (objectType == "T") {
                    move_robber(playerIndex, ds_list_find_value(global.lands, ds_list_find_value(actionParams, 0)), ds_list_find_value(actionParams, 1))
                }
                break
            case "TR":
                if (objectType == "B")  {
		            trade_bank(playerIndex, ds_list_find_value(actionParams, 0), ds_list_find_value(actionParams, 1), ds_list_find_value(actionParams, 2), ds_list_find_value(actionParams, 3)
					, ds_list_find_value(actionParams, 4), ds_list_find_value(actionParams, 5), ds_list_find_value(actionParams, 6), ds_list_find_value(actionParams, 7), ds_list_find_value(actionParams, 8)
					, ds_list_find_value(actionParams, 9))
		        } else {
		            trade_player(playerIndex, ds_list_find_value(actionParams, 0), ds_list_find_value(actionParams, 1), ds_list_find_value(actionParams, 2), ds_list_find_value(actionParams, 3)
					, ds_list_find_value(actionParams, 4), ds_list_find_value(actionParams, 5), ds_list_find_value(actionParams, 6), ds_list_find_value(actionParams, 7), ds_list_find_value(actionParams, 8)
					, ds_list_find_value(actionParams, 9), real(objectType))
		        }
				break
            case "RD":
                roll_dice(playerIndex, ds_list_find_value(actionParams, 0), ds_list_find_value(actionParams, 1))
				break
			case "DR":
				draw_development_card(objectType)
				change_resource(playerIndex, resource_wool, -1)
				change_resource(playerIndex, resource_grain, -1)
				change_resource(playerIndex, resource_ore, -1)
				break
		}
		ds_list_destroy(actionParams)
			
		line = file_text_readln(actionList_file)
	}
		
	file_text_close(actionList_file)
	#endregion
		
	ini_open("communication.ini")
		file_delete("actions_agentPlatform_"+string(global.player_active-1)+".txt")
		ini_write_string("General", "turnMode["+string(global.player_active-1)+"]", "normal")
	ini_close()
		
	recalculate_scores()
		
	if (!global.stopGame)
		turn_end()
	else {
		ini_open("communication.ini")
			ini_write_string("General", "isSynchronized", "false")
		ini_close()
		
		ini_open("games.ini")
			var experimentName = "Game "+string(global.gameNo)
			ini_write_string(experimentName, "Winner", global.winnerPlayer)
			ini_write_string(experimentName, "Winner.StrategyAgent", global.strategyAI_name[global.winnerPlayer])
			ini_write_string(experimentName, "Winner.NegotiationAgent", global.negotiationAI_name[global.winnerPlayer])
			ini_write_string(experimentName, "Winner.Name", global.player_name[global.winnerPlayer])
			ini_write_string(experimentName, "Time(s)", global.time/60)
			ini_write_string(experimentName, "Turn", global.turn)
			
			for (var i = 1; i <= PLAYER_COUNT; i++) {
				ini_write_string(experimentName, "P"+string(i)+".NegotiationAgreements", global.negotiationAgreements[i])
				ini_write_string(experimentName, "P"+string(i)+".VictoryPoint(s)", global.playerScore[i])
				ini_write_string(experimentName, "P"+string(i)+".TradeWithBank(s)", global.tradeBanks[i])
			}
		ini_close()
	}
	
	global.gameStep_time = 0
}