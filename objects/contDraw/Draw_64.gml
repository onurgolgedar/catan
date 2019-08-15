var dw = view_get_wport(0)
var dh = view_get_hport(0)

diceX = dw/10
diceY = dh*9/10

if (global.player_active == global.human and can_dice() and is_turn_ready()) {
	var size = 1+contMain.period/50+0.1*mouseOn_dice
	
	draw_sprite_ext(sprDice, -1, diceX, diceY, size, size, 0, mouseOn_dice ? c_aqua : c_white, 0.9+mouseOn_dice*0.1)
}
else if (global.isDiceRolled) {
	draw_set_alpha(0.6)
		draw_roundrect(diceX-60, diceY-30, diceX+60, diceY+30, 0)
	draw_set_alpha(1)
	
	var isRobberDice = global.diceTotal == 7
	
	draw_sprite_ext(sprDiceSides, global.dice[0]-1, diceX-30, diceY, 1.1+isRobberDice*0.1, 1.1+isRobberDice*0.1, 0, c_black, 0.7)
	draw_sprite_ext(sprDiceSides, global.dice[0]-1, diceX-30, diceY, 1, 1, 0, isRobberDice ? c_yellow : c_white, 1)
	
	draw_sprite_ext(sprDiceSides, global.dice[1]-1, diceX+30, diceY, 1.1+isRobberDice*0.1, 1.1+isRobberDice*0.1, 0, c_black, 0.7)
	draw_sprite_ext(sprDiceSides, global.dice[1]-1, diceX+30, diceY, 1, 1, 0, isRobberDice ? c_yellow : c_white, 1)
	
	if (isRobberDice) {
		draw_set_color(c_yellow) draw_set_font(fontMain_bold)
			draw_text(diceX-43, diceY-62, "Robbery!")
		draw_set_color(c_default) draw_set_font(fontMain)
	}
}

if (global.continueToggle) {
	draw_set_valign(fa_center) draw_set_halign(fa_center) draw_set_font(fontMain_large) draw_set_alpha(0.8)
		draw_roundrect(dw/1.2-100, 120-17, dw/1.2+100, 120+17, 0)
	draw_set_color(c_lime) draw_set_alpha(1)
		draw_text(dw/1.2, 122, "Automatic Mode")
	draw_set_valign(fa_top) draw_set_halign(fa_left) draw_set_font(fontMain) draw_set_color(c_black)
}

if (global.stopGame or global.turn_ready != global.turn) {
	var text

	if (global.stopGame)
		text = "The winner is "+global.player_name[global.winnerPlayer]
	else
		text = global.player_name[global.player_active]+" is thinking."
	
	if (global.stopGame) {
		draw_set_alpha(0.15) draw_set_color(get_player_color(global.winnerPlayer))
			draw_roundrect(0, 0, dw, dh, 0)
		draw_set_alpha(1) draw_set_color(c_default)
	}

	draw_set_valign(fa_center) draw_set_halign(fa_center) draw_set_font(fontMain_large) draw_set_alpha(0.8)
		draw_roundrect(dw/2-190, 120-17, dw/2+190, 120+17, 0)
	draw_set_color(c_white) draw_set_alpha(1)
		draw_text(dw/2, 122, text)
	draw_set_valign(fa_top) draw_set_halign(fa_left) draw_set_font(fontMain)
}

//draw_set_halign(fa_right) 
	draw_set_alpha(0.5) draw_set_color(c_black)
		draw_roundrect(0, 0, dw, 100, 0)
	draw_set_alpha(1) draw_set_color(c_default)
	
	for (var i = 1; i <= PLAYER_COUNT; i++) {
		var offset_x = 1/2*dw/PLAYER_COUNT+(i-1)*dw/PLAYER_COUNT
		var xx = dw/PLAYER_COUNT*(i-1)
		var xx2 = dw/PLAYER_COUNT*i
		
		if (global.player_active == i) {
			draw_set_color(c_green) draw_set_alpha(0.2+contMain.period/20)
				draw_rectangle(xx, 0, xx2, 100, 0)
			draw_set_color(c_default) draw_set_alpha(1)
		}
		
		/*draw_set_valign(fa_center) draw_set_halign(fa_center) */draw_set_color(i == global.player_active ? c_aqua : c_white)
		draw_set_font(fontMain_large) draw_set_color(get_player_color(i))
			draw_rectangle(xx, 0, xx2, 5, 0)
			draw_text(offset_x-130, 8, global.player_name[i])
			draw_text(offset_x-130+215, 8, string(global.playerScore[i])+"/"+string(MAX_SCORE))
		draw_set_color(c_white) draw_set_font(fontMain)
			draw_text(offset_x-130, 34, "Longest Road: "+string(global.longestRoad[i])+string(global.longestRoad_owner == i ? " ●" : ""))
			draw_text(offset_x-130+215, 34, "█ "+string(global.totalCards[i]))
			draw_text(offset_x-130, 54, "Knights: "+string(global.knights[i])+string(global.knights_owner == i ? " ●" : ""))
			draw_text(offset_x-130, 74, "Victory Cards: "+string(global.victoryCards[i]))
		/*draw_set_valign(fa_top) draw_set_halign(fa_left) */draw_set_color(c_default)

		draw_rectangle(xx-2, 0, xx+2, 100, 0)
		draw_rectangle(xx2-2, 0, xx2+2, 100, 0)
	}
	
	draw_rectangle(0, 98, dw, 100, 0)
//draw_set_halign(fa_left) draw_set_color(c_black)