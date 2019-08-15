var card = argument[0]

if (card == actionObject_victory)
	global.victoryCards[global.player_active] += 1
else if (card == actionObject_knight)
	global.knights[global.player_active] += 1

if (global.actionWriting_mode)
	action_write(global.player_active, action_draw, "99", card)