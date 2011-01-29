local gfx = love.graphics
local selected = 1

-- newGameState
newGameState = Gamestate.new()

-- menuGameState
menuGameState = Gamestate.new()

-- gameOverState
gameOverState = Gamestate.new()

wereInActualGameNowLoLGlobalsBad = false

--menuGameState functions

function menuGameState:draw()
   gfx.setColor(224, 27, 99, 200)
   gfx.rectangle('fill', 50, 50, SCREEN_WIDTH-100, SCREEN_HEIGHT-100)
   
   drawMenuItemStuff()
end

function menuGameState:keyreleased(key)
   if key == 'up' then
      if selected ~= 1 then
         selected = selected - 1
         drawMenuItemStuff()
      end
   elseif key == 'down' then
      if selected ~= #menuText then
         selected = selected + 1
         drawMenuItemStuff()
      end
   elseif key == 'return' then
      if selected == 1 then
         newGame()
      end
      if selected == 2 then
         newGame()
      end
      if selected == 3 then
         newGame()
      end
      if selected == 4 then
         love.event.push('q')
      end
   end
end

--gameOverState functions

function gameOverState:draw()
   gfx.setColor(224, 27, 99, 200)
   gfx.rectangle('fill', 50, 50, SCREEN_WIDTH-100, SCREEN_HEIGHT-100)

   local gameOverString = string.format("Game Over! Score was %f", score)
   love.graphics.setFont(seconds_font)
   gfx.setColor(5, 255, 5)
   love.graphics.print(gameOverString, SCREEN_HEIGHT/2 - gameOverString:len()*4, SCREEN_HEIGHT/2)
   wereInActualGameNowLoLGlobalsBad = false
end

--Helper functions

function drawMenuItemStuff()
   local offset = 0
   menuText = {'New Game', 'Go Shpx Yourself', 'And A Third Item', 'Quit'}
   for i, text in pairs(menuText) do
      if i == selected then
         gfx.setColor(0, 255, 4)
      else
         gfx.setColor(133, 249, 255)
      end
      gfx.print(text, 150, 150+offset, 0, 3, 3)
      offset = offset + 100
   end
end

function newGame()
   wereInActualGameNowLoLGlobalsBad = true
   load_time = love.timer.getTime()
   Gamestate.switch(newGameState)
end


return menuGameState, newGameState, gameOverState


