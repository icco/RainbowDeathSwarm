local gfx = love.graphics
local selected = 0

-- Levellllll
local levelllll = Gamestate.new()

-- Menu
local menu = Gamestate.new()

wereInActualGameNowLoLGlobalsBad = false

function menu:draw()
   gfx.setColor(224, 27, 99, 200)
   gfx.rectangle('fill', 50, 50, SCREEN_WIDTH-100, SCREEN_HEIGHT-100)
   
   drawMenuItemStuff()
end

function drawMenuItemStuff()
   local offset = 0
   for i, text in pairs({'New Game', 'Go Shpx Yourself', 'And A Third Item'}) do
      if i == selected then
         gfx.setColor(0, 255, 4)
      else
         gfx.setColor(133, 249, 255)
      end
      gfx.print(text, 150, 150+offset, 0, 3, 3)
      offset = offset + 100
   end
end

function menu:keyreleased(key)
   if key == 'up' then
      selected = selected - 1
      drawMenuItemStuff()
   elseif key == 'down' then
      selected = selected + 1
      drawMenuItemStuff()
   elseif key == 'return' then
      wereInActualGameNowLoLGlobalsBad = true
      load_time = love.timer.getTime()
      Gamestate.switch(levelllll)
   end
end

return menu, levelllll
