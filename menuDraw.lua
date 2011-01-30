local gfx = love.graphics
local selected = 1

-- newGameState
newGameState = Gamestate.new()

-- menuGameState
menuGameState = Gamestate.new()

-- gameOverState
gameOverState = Gamestate.new()

-- highScoreState
highScoreState = Gamestate.new()

-- misleadingState
helpStoryState = Gamestate.new()

wereInActualGameNowLoLGlobalsBad = false

--menuGameState functions

function menuGameState:draw()
   gfx.setColor(224, 27, 99, 200)
   gfx.rectangle('fill', 50, 50, SCREEN_WIDTH-100, SCREEN_HEIGHT-100)

   gfx.setColor(255, 255, 255)
   gfx.print("Rainbow Death Swarm", 100, 100, 0, 1, 1)

   drawMenuItemStuff()
end

function menuGameState:keyreleased(key)
   if key == 'up' or key == 'k' or key == 'w' then
      if selected ~= 1 then
         selected = selected - 1
         drawMenuItemStuff()
      end
   elseif key == 'down' or key == 'j' or key == 's' then
      if selected ~= #menuText then
         selected = selected + 1
         drawMenuItemStuff()
      end
   elseif key == 'return' then
      if selected == 1 then
         newGame()
      end
      if selected == 2 then
         Gamestate.switch(highScoreState)
      end
      if selected == 3 then
         Gamestate.switch(helpStoryState)
      end
      if selected == 4 then
         love.event.push('q')
      end
   end
end

-- End of game state
function gameOverState:draw()
   gfx.setColor(224, 27, 99, 200)
   gfx.rectangle('fill', 50, 50, SCREEN_WIDTH-100, SCREEN_HEIGHT-100)

   local gameOverString = string.format("Game Over!\nYour score was %0.2f\n\nPress 'h' for high scores\nor 'm' for the main menu.", score)
   love.graphics.setFont(ASSETS.largeFont)
   gfx.setColor(5, 255, 5)
   love.graphics.print(gameOverString, SCREEN_WIDTH/2 - gameOverString:len()*4, SCREEN_HEIGHT/4)
   wereInActualGameNowLoLGlobalsBad = false
end

function gameOverState:keyreleased(key)
   if key == 'h' then
      Gamestate.switch(highScoreState)
   elseif key == 'm' then
      resetGame()
      Gamestate.switch(menuGameState)
   end
end

-- Highscore menu
function highScoreState:draw()
   gfx.setColor(224, 27, 99, 200)
   gfx.rectangle('fill', 50, 50, SCREEN_WIDTH-100, SCREEN_HEIGHT-100)
   gfx.setColor(255, 255, 255)
   local line = ""
   gfx.setFont(ASSETS.largeFont)
   love.graphics.print("High Scores", 190, 100)

   gfx.setFont(ASSETS.smallFont)
   for i, score, name in highscore() do
      line = string.format("%2d.     %.2f", i, score)
      love.graphics.print(line, 250, (i * 30) + 150)
   end
end

function highScoreState:keyreleased(key)
   if key == 'left' or key == 'b' or key == 'a' then
      Gamestate.switch(menuGameState)
   end
end

-- Help/Story menu
function helpStoryState:draw()
   gfx.setColor(224, 27, 99, 200)
   gfx.rectangle('fill', 50, 50, SCREEN_WIDTH-100, SCREEN_HEIGHT-100)
   gfx.setColor(255, 255, 255)
   local line = ""
   gfx.setFont(ASSETS.largeFont)
   love.graphics.print("Haiku Instructions", 175, 90)

   local text = {
      "Rainbows are scary.",
      "They will eat you alive, son.",
      "Run away with 'd'.",
      "",
      "Press 'spacebar' to jump.",
      "If you do not, you will die.",
      "Stop to reproduce.",
      "",
      "Press 'm' to stop pain,",
      "if sound irritates your ears.",
      "'Escape' kills them all."
   }
   
   local backText = {
      "Press 'b' to go back.",
      "The other menus aren't as good.",
      "Come back again soon!"
   }

   gfx.setFont(ASSETS.smallFont)
   for i, line in pairs(text) do
      love.graphics.print(line, 145, (i * 30) + 140)
   end
   
   gfx.setFont(ASSETS.verySmallFont)
   for i, line in pairs(backText) do
      love.graphics.print(line, 485, (i * 15) + 480)
   end
end

function helpStoryState:keyreleased(key)
   if key == 'left' or key == 'b' or key == 'a' or key == 'return' then
      Gamestate.switch(menuGameState)
   end
end

-- Helper functions
function drawMenuItemStuff()
   local offset = 0

   gfx.setFont(ASSETS.largeFont)
   menuText = {'New Game', 'High Scores', 'Controls & Story', 'Quit'}
   for i, text in pairs(menuText) do
      if i == selected then
         gfx.setColor(0, 255, 4)
      else
         gfx.setColor(133, 249, 255)
      end

      gfx.print(text, 150, 200+offset, 0, 1, 1)
      offset = offset + 90
   end
end

function newGame()
   wereInActualGameNowLoLGlobalsBad = true
   load_time = love.timer.getTime()
   Gamestate.switch(newGameState)
end

return menuGameState, newGameState, gameOverState, highScoreState
