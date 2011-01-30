--background draw fuctions

function backgroundLoad()
--already done in assets?
  back1pos = { }
  back2pos = {}
  back3pos = {}

 --first layer
 back1pos1x = SCREEN_WIDTH/2
 back1pos2x = SCREEN_WIDTH/2 + 1200
 back1pos3x = SCREEN_WIDTH/2 + 2400
 back1pos1y = SCREEN_HEIGHT/2
 back1pos2y = SCREEN_HEIGHT/2
 back1pos3y = SCREEN_HEIGHT/2

 back2pos1x = SCREEN_WIDTH/2
 back2pos2x = SCREEN_WIDTH/2 + 1200
 back2pos3x = SCREEN_WIDTH/2 + 2400
 back2pos1y = SCREEN_HEIGHT/2
 back2pos2y = SCREEN_HEIGHT/2
 back2pos3y = SCREEN_HEIGHT/2

 --background is stuck to background
 back3posx = SCREEN_WIDTH/2
 back3posy = SCREEN_HEIGHT/2 
end

function backgroundUpdate()
 -- check for backgrounds leaving 
	if back1pos1x <= -SCREEN_WIDTH - SCREEN_WIDTH/2 then
		back1pos1x = back1pos1x + 2400
	end
 	if back1pos2x <= -SCREEN_WIDTH - SCREEN_WIDTH/2 then
		back1pos2x = back1pos2x + 2400
	end
	if back1pos3x <= -SCREEN_WIDTH - SCREEN_WIDTH/2 then
		back1pos3x = back1pos3x + 2400
	end
	
	if back2pos1x <= -SCREEN_WIDTH - SCREEN_WIDTH/2 then
		back2pos1x = back2pos1x + 2400
        end
	if back2pos2x <= -SCREEN_WIDTH - SCREEN_WIDTH/2 then
		back2pos2x = back2pos2x + 2400
        end
	if back2pos3x <= -SCREEN_WIDTH - SCREEN_WIDTH/2 then
		back2pos3x = back2pos3x + 2400
        end  

--now decrement positions
	back1pos1x = back1pos1x - 100
	back1pos2x = back1pos2x - 100
	back1pos3x = back1pos3x - 100
	back2pos1x = back2pos1x - 30 
	back2pos2x = back2pos2x - 30 
	back2pos3x = back2pos3x - 30 
end

function backgroundDraw()
	local gfx = love.graphics
	gfx.setColor(255,255,255)
	b3 = gfx.newQuad(back3posx-SCREEN_WIDTH/2, back3posy-SCREEN_HEIGHT/2, 1600, 1200, 0, 0)
	
	b21 = gfx.newQuad(back2pos1x-SCREEN_WIDTH/2, back2pos1y-SCREEN_HEIGHT/2, 1600, 1200,0,0)
	b22 = gfx.newQuad(back2pos2x-SCREEN_WIDTH/2, back2pos2y-SCREEN_HEIGHT/2, 1600, 1200,0,0)
	b23 = gfx.newQuad(back2pos3x-SCREEN_WIDTH/2, back2pos3y-SCREEN_HEIGHT/2, 1600, 1200,0,0)

	b11 = gfx.newQuad(back1pos1x-SCREEN_WIDTH/2, back1pos1y-SCREEN_HEIGHT/2, 1600, 1200,0,0)
	b12 = gfx.newQuad(back1pos2x-SCREEN_WIDTH/2, back1pos2y-SCREEN_HEIGHT/2, 1600, 1200,0,0)
	b13 = gfx.newQuad(back1pos3x-SCREEN_WIDTH/2, back1pos3y-SCREEN_HEIGHT/2, 1600, 1200,0,0)
	
	gfx.drawq(ASSETS.background3, b3, back3posx-SCREEN_WIDTH/2, back3posy-SCREEN_HEIGHT/2,0,0.4,0.4,0,0)
	
	--gfx.drawq(ASSETS.background2, b2, back2pos1x-SCREEN_WIDTH/2, back2pos1y-SCREEN_HEIGHT/2,0,0.4,0.4,0,0)
	--gfx.drawq(ASSETS.background2, b2, back2pos2x-SCREEN_WIDTH/2, back2pos2y-SCREEN_HEIGHT/2,0,0.4,0.4,0,0)
	--gfx.drawq(ASSETS.background2, b2, back2pos3x-SCREEN_WIDTH/2, back2pos3y-SCREEN_HEIGHT/2,0,0.4,0.4,0,0)
	
	--gfx.drawq(ASSETS.background1, b1, back1pos1x-SCREEN_WIDTH/2, back1pos1y-SCREEN_HEIGHT/2,0,0.4,0.4,0,0)
	--gfx.drawq(ASSETS.background1, b1, back1pos2x-SCREEN_WIDTH/2, back1pos2y-SCREEN_HEIGHT/2,0,0.4,0.4,0,0)
	--gfx.drawq(ASSETS.background1, b1, back1pos3x-SCREEN_WIDTH/2, back1pos3y-SCREEN_HEIGHT/2,0,0.4,0.4,0,0)
end
